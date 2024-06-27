Class {
	#name : #SmRestApiService,
	#superclass : #Object,
	#instVars : [
		'database',
		'preparedStatements'
	],
	#classVars : [
		'Current'
	],
	#category : #'CodeParadise-SharedMoments-Data-Core'
}

{ #category : #accessing }
SmRestApiService class >> current [

	^ Current ifNil: [ Current := self basicNew initialize ; yourself ]
]

{ #category : #password }
SmRestApiService class >> hashPassword: plainTextPassword usingSalt: saltString [

	"Answer a hash by performing a Password-Based Key Derivation Function 2 (PBKDF2) on the specified plain text password"

	^ (CpNodeJSCrypto require
		pbkdf2Password: plainTextPassword
		salt: saltString
		iterations: 100000
		keylen: 64
		digest: #sha512) toStringEncoding: #hex
]

{ #category : #support }
SmRestApiService class >> installInstanceMethod: aCompiledMethod [

	"If a method is installed, marked as endpoint operation, register it"

	| operation |

	"First unregister (any possible) existing operation"
	(self methodDictionary at: aCompiledMethod selector ifAbsent: [ nil ])
		ifNotNil: [ :prevMethod |
			(self isEndpointOperation: prevMethod)
				ifTrue: [
					"Operation created below is same for old and new method"
					operation := self operationFor: aCompiledMethod.
					CpNodeJSRestEndpointOperation unregisterOperation: operation ] ].

	super installInstanceMethod: aCompiledMethod.

	"If new method is not an endpoint operation, we're done"
	(self isEndpointOperation: aCompiledMethod)
		ifFalse: [ ^ self ].

	"Resgiter operation, use previously created operation or create new one"
	operation ifNil: [ operation := self operationFor: aCompiledMethod ].
	CpNodeJSRestEndpointOperation registerOperation: operation
]

{ #category : #support }
SmRestApiService class >> isEndpointOperation: aCompiledMethod [

	aCompiledMethod pragmas
		detect: [ :each | #(#get: #post:) includes: each keyword ] ifNone: [ ^ false ].

	^ true
]

{ #category : #password }
SmRestApiService class >> matchPassword: plainTextPassword withHash: hashedPassword [

	"Answer whether the specified password matches the hashed password specified.

	Implementation:
	The hashed password consists of: 16 byte hex salt string followed by hashed password (PBKDF2).
	Therefore extract the first 32 characters (salt string is hex string of 16 bytes) to recreate
	the salt. Then perform hashing algorithm to create a hashed password value.
	Finally, check that value against the previously stored hashed value."

	| salt hash |

	salt := hashedPassword first: 32.

	hash := self hashPassword: plainTextPassword usingSalt: salt.

	^ (hashedPassword allButFirst: 32) = hash
]

{ #category : #'instance creation' }
SmRestApiService class >> new [

	self errorNewReplacedBy: #current
]

{ #category : #resources }
SmRestApiService class >> newId [

	"Answer a new random ID (for a row)"

	^ CpNodeJSCrypto require randomUUID
]

{ #category : #resources }
SmRestApiService class >> newToken [

	"Answer a new random token value"

	^ (CpNodeJSCrypto require randomBytes: 16) toStringEncoding: 'hex'
]

{ #category : #support }
SmRestApiService class >> operationFor: aCompiledMethod [

	"Answer a MessageSend (used in CpNodeJSRestEndpointOperation) for the receiver and the specified Compiled Method"

	| action pragma |

	action := MessageSend receiver: self current selector: aCompiledMethod selector.

	pragma := aCompiledMethod pragmas
		detect: [ :each | #(#get: #post:) includes: each keyword ] ifNone: [ ^ nil ].

	pragma keyword == #post:
		ifTrue: [ ^ CpNodeJSRestEndpointOperation path: pragma arguments first postOperation: action ].

	self error: 'Not implemented yet'
]

{ #category : #'class initialization' }
SmRestApiService class >> postInstallOnce [

	"Install the endpoint operations"

	self methodDictionary do: [ :each |
		(self isEndpointOperation: each)
			ifTrue: [
				| operation |

				operation := self operationFor: each.
				CpNodeJSRestEndpointOperation registerOperation: operation.
				self traceCr: 'Registered endpoint operation: ', operation printString ] ]
]

{ #category : #support }
SmRestApiService class >> removeInstanceMethod: aCompiledMethod [

	"If a method is removed unregister it (might not actually be registered, but just to be sure)"

	(self isEndpointOperation: aCompiledMethod)
		ifTrue: [ CpNodeJSRestEndpointOperation unregisterOperation: (self operationFor: aCompiledMethod) ].

	super removeInstanceMethod: aCompiledMethod
]

{ #category : #resources }
SmRestApiService class >> timestampNow [

	"Answer the current timestamp as seconds since Unix epoch (midnight Jan 1, 1970, UTC)"

	^ ((CpJavaScriptClass forName: #Date) apply: #now) // 1000
]

{ #category : #API }
SmRestApiService >> createSession: accountId response: aServerResponse [

	| id createdAt accessToken |

	id := self class newId.
	createdAt := self class timestampNow.
	accessToken := self class newToken.

	self
		insert: #createSession
		statement: 'INSERT INTO sessions (id, createdAt, accountId, accessToken) VALUES(:id, :createdAt, :accountId, :accessToken)'
		bind: {
			#id -> id.
			#createdAt -> createdAt.
			#accountId -> accountId.
			#accessToken -> accessToken
		} asDictionary.

	self
		send: {
			#id -> id.
			#createdAt -> createdAt.
			#accessToken -> accessToken.
			#accountId -> accountId } asOrderedDictionary
		response: aServerResponse
]

{ #category : #errors }
SmRestApiService >> errorInvalidLogin [

	self error: 'Credentials provided do not match an active account'
]

{ #category : #errors }
SmRestApiService >> errorMissingInput: aString [

	self error: 'Missing field in REST request: ', aString
]

{ #category : #errors }
SmRestApiService >> errorNoBody [

	self error: 'No body present in REST request'
]

{ #category : #initialization }
SmRestApiService >> initialize [

	super initialize.

	database := CpNodeJSSqlite3Database onPath: 'data/database.db' withOptions: Dictionary new.
	preparedStatements := Dictionary new
]

{ #category : #API }
SmRestApiService >> login: aRestRequest response: aServerResponse [

	<post: '/api/v1/login'>

	| body account |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#email #password).

	"Precaution to not divulge more information than needed"
	[
		"Read account"
		account := self
			selectOne: #getAccount
			statement: 'SELECT id, name, password FROM accounts WHERE email=:email'
			bind: {
				#email -> (body at: #email) } asDictionary.

		account ifNil: [ self errorInvalidLogin ].

		"Validate password"
		(self class matchPassword: (body at: #password) withHash: (account at: #password))
			ifFalse: [ self errorInvalidLogin ]
	] on: Error do: [ :err | self errorInvalidLogin ].

	"Create session"
	self createSession: (account at: #id) response: aServerResponse
]

{ #category : #database }
SmRestApiService >> perform: aSymbol statement: aString bind: aDictionary [

	"Update a row in the database"

	| resultInfo |

	resultInfo := (self prepare: aSymbol statement: aString)
		runWithBindings: aDictionary.

	(resultInfo at: #changes) == 1
		ifFalse: [ self error: 'Did not update a single row as expected' ]
]

{ #category : #database }
SmRestApiService >> prepare: aSymbol statement: aString [

	"Answer the prepared statement identified by a Symbol"

	^ preparedStatements
		at: aSymbol
		ifPresent: [ :statement |
			statement source = aString
				ifTrue: [ statement ]
				ifFalse: [ preparedStatements at: aSymbol put: (database prepare: aString) ] ]
		ifAbsentPut: [ database prepare: aString ]
]

{ #category : #database }
SmRestApiService >> selectMany: aSymbol statement: aString bind: aDictionary [

	"Select (possibly) multiple rows from the database and answer a collection"

	^ (self prepare: aSymbol statement: aString)
		allWithBindings: aDictionary
]

{ #category : #database }
SmRestApiService >> selectOne: aSymbol statement: aString bind: aDictionary [

	"Select a single row from the database and answer the object found"

	| rows |

	rows := (self prepare: aSymbol statement: aString)
		allWithBindings: aDictionary.

	rows size > 1
		ifTrue: [ self error: 'More than one row found for single row select' ].

	^ rows
		ifNotEmpty: [ rows first ]
		ifEmpty: [ nil ]
]

{ #category : #sending }
SmRestApiService >> send: anObject response: aServerResponse [

	aServerResponse
		statusCode: CpNodeJSRestHttpServer statusOK ;
		setHeaderWithName: 'Content-Type' value: 'application/json; charset=utf-8' ;
		writeChunk: (CpJavaScriptJSON stringify: anObject) ;
		end
]

{ #category : #validating }
SmRestApiService >> validateBody: body expectFields: aCollection [

	| missingFields |

	missingFields := aCollection select: [ :each |
		(body includesKey: each) not ].

	missingFields
		ifNotEmpty: [ self errorMissingInput: (', ' join: missingFields) ]
]
