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
		detect: [ :each | #(#get: #post: #put: #delete:) includes: each keyword ] ifNone: [ ^ false ].

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
		detect: [ :each | #(#get: #post: #put: #delete:) includes: each keyword ] ifNone: [ ^ nil ].

	pragma keyword == #get:
		ifTrue: [ ^ CpNodeJSRestEndpointOperation path: pragma arguments first getOperation: action ].
	pragma keyword == #post:
		ifTrue: [ ^ CpNodeJSRestEndpointOperation path: pragma arguments first postOperation: action ].
	pragma keyword == #put:
		ifTrue: [ ^ CpNodeJSRestEndpointOperation path: pragma arguments first putOperation: action ].

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
SmRestApiService >> addCameraInvite: aRestRequest response: aServerResponse [

	<post: '/api/v1/collections/:id/camera-invites'>

	| id createdAt body collectionId |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#name #email #token #sentAt #acceptedAt).

	id := self class newId.
	createdAt := self class timestampNow.
	collectionId := aRestRequest pathParameterAt: #id.

	self
		perform: #addCameraInvite
		statement: 'INSERT INTO camera_invites (id, createdAt, collectionId, name, email, token, sentAt, acceptedAt) VALUES(:id, :createdAt, :collectionId, :name, :email, :token, :sentAt, :acceptedAt)'
		bind: {
			#id -> id.
			#createdAt -> createdAt.
			#collectionId -> collectionId.
			#name -> (body at: #name).
			#email -> (body at: #email).
			#token -> (body at: #token).
			#sentAt -> (body at: #sentAt).
			#acceptedAt -> (body at: #acceptedAt)
		} asDictionary.

	self
		send: {
			#id -> id.
			#createdAt -> createdAt } asDictionary
		response: aServerResponse
]

{ #category : #API }
SmRestApiService >> addCollection: aRestRequest response: aServerResponse [

	<post: '/api/v1/accounts/:id/collections'>

	| id createdAt body accountId |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#name).

	id := self class newId.
	createdAt := self class timestampNow.
	accountId := aRestRequest pathParameterAt: #id.

	self
		perform: #addCollection
		statement: 'INSERT INTO collections (id, createdAt, accountId, name) VALUES(:id, :createdAt, :accountId, :name)'
		bind: {
			#id -> id.
			#createdAt -> createdAt.
			#accountId -> accountId.
			#name -> (body at: #name)
		} asDictionary.

	self
		send: {
			#id -> id.
			#createdAt -> createdAt } asDictionary
		response: aServerResponse
]

{ #category : #API }
SmRestApiService >> addhoto: aRestRequest response: aServerResponse [

	<post: '/api/v1/photos'>

	| body createdAt collectionIds width height orientation fileName |

	body := (aRestRequest body) ifNil: [ self errorNoBody ].

	createdAt := self class timestampNow.
	collectionIds := (aRestRequest headerAt: #'sm-collection-ids')
		ifNotNil: [ :ids | ids findTokens: $, ]
		ifNil: [ self errorMissingHeader: #'SM-Collection-IDs' ].
	width := (aRestRequest headerAt: #'sm-photo-width') asNumber.
	height := (aRestRequest headerAt: #'sm-photo-height') asNumber.
	orientation := aRestRequest headerAt: #'sm-photo-orientation'.

	"Create file containing the photo"
	fileName := './files/', self class newToken, '.png'.
	CpNodeJSFS require syncWriteFile: fileName data: body options: { #flush -> true } asDictionary.

	collectionIds do: [ :each |

		"Insert record per photo per collection it is stored in"
		self
			perform: #addPhoto
			statement: 'INSERT INTO photos (id, createdAt, collectionId, width, height, orientation, fileName) VALUES(:id, :createdAt, :collectionId, :width, :height, :orientation, :fileName)'
			bind: {
				#id -> self class newId.
				#createdAt -> createdAt.
				#collectionId -> each.
				#width -> width.
				#height -> height.
				#orientation -> orientation.
				#fileName -> fileName
			} asDictionary ].

	aServerResponse
		statusCode: CpNodeJSRestHttpServer statusOK ;
		end
]

{ #category : #API }
SmRestApiService >> createSessionForAccount: aDictionary response: aServerResponse [

	| id createdAt accessToken |

	id := self class newId.
	createdAt := self class timestampNow.
	accessToken := self class newToken.

	self
		perform: #createSession
		statement: 'INSERT INTO sessions (id, createdAt, accountId, accessToken) VALUES(:id, :createdAt, :accountId, :accessToken)'
		bind: {
			#id -> id.
			#createdAt -> createdAt.
			#accountId -> (aDictionary at: #id).
			#accessToken -> accessToken
		} asDictionary.

	self
		send: {
			#id -> id.
			#createdAt -> createdAt.
			#accessToken -> accessToken.
			#account -> aDictionary } asOrderedDictionary
		response: aServerResponse
]

{ #category : #errors }
SmRestApiService >> errorInvalidLogin [

	self error: 'Credentials provided do not match an active account'
]

{ #category : #errors }
SmRestApiService >> errorMissingHeader: aString [

	self error: 'Missing header in REST request: ', aString
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

	<post: '/api/v1/sessions'>

	| body account collections |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#email #password).

	"Precaution to not divulge more information than needed"
	[
		"Read account"
		account := self
			selectOne: #login
			statement: 'SELECT id, createdAt, updatedAt, name, email, password FROM accounts WHERE deletedAt IS NULL AND email=:email'
		bind: {
			#email -> (body at: #email) } asDictionary.

		account ifNil: [ self errorInvalidLogin ].

		"Validate password"
		(self class matchPassword: (body at: #password) withHash: (account at: #password))
			ifFalse: [ self errorInvalidLogin ]
	] on: Error do: [ :err | self errorInvalidLogin ].

	"Read collections and add to account"
	collections := self
		selectMany: #getCollections
		statement: 'SELECT id, createdAt, updatedAt, name FROM collections WHERE deletedAt IS NULL AND accountId=:accountId'
		bind: { #accountId -> (account at: #id) } asDictionary.
	account at: #collections put: collections.

	"Read cameras and add to collections"
	collections do: [ :each |
		| cameras |
		cameras := self
			selectMany: #getCameras
			statement: 'SELECT id, createdAt, updatedAt, name FROM cameras WHERE deletedAt IS NULL AND collectionId=:collectionId'
			bind: { #collectionId -> (each at: #id) } asDictionary.
		each at: #cameras put: cameras ].

	"Read photo frames and add to collections"
	collections do: [ :each |
		| photoFrames |
		photoFrames := self
			selectMany: #getPhotoFrames
			statement: 'SELECT id, createdAt, updatedAt, name FROM photo_frames WHERE deletedAt IS NULL AND collectionId=:collectionId'
			bind: { #collectionId -> (each at: #id) } asDictionary.
		each at: #photoFrames put: photoFrames ].
 
	"Create session and respond it"
	self createSessionForAccount: account response: aServerResponse
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

{ #category : #API }
SmRestApiService >> updateAccount: aRestRequest response: aServerResponse [

	<put: '/api/v1/accounts/:id'>

	| updatedAt body |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#name).

	updatedAt := self class timestampNow.

	self
		perform: #updateAccount
		statement: 'UPDATE accounts SET updatedAt=:updatedAt, name=:name WHERE id=:id'
		bind: {
			#updatedAt -> updatedAt.
			#name -> (body at: #name).
			#id -> (aRestRequest pathParameterAt: #id)
		} asDictionary.

	self
		send: { #updatedAt -> updatedAt } asDictionary
		response: aServerResponse
]

{ #category : #API }
SmRestApiService >> updateCollection: aRestRequest response: aServerResponse [

	<put: '/api/v1/collections/:id'>

	| updatedAt body |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#name).

	updatedAt := self class timestampNow.

	self
		perform: #updateCollection
		statement: 'UPDATE collections SET updatedAt=:updatedAt, name=:name WHERE id=:id'
		bind: {
			#updatedAt -> updatedAt.
			#name -> (body at: #name).
			#id -> (aRestRequest pathParameterAt: #id)
		} asDictionary.

	self
		send: { #updatedAt -> updatedAt } asDictionary
		response: aServerResponse
]

{ #category : #validating }
SmRestApiService >> validateBody: body expectFields: aCollection [

	| missingFields |

	missingFields := aCollection select: [ :each |
		(body includesKey: each) not ].

	missingFields
		ifNotEmpty: [ self errorMissingInput: (', ' join: missingFields) ]
]
