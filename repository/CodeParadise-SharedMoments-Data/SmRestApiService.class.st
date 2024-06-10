Class {
	#name : #SmRestApiService,
	#superclass : #Object,
	#instVars : [
		'database',
		'preparedStatements'
	],
	#category : #'CodeParadise-SharedMoments-Data-Core'
}

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

	| body account |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].
	self validateBody: body expectFields: #(#email #password).

	"Read account"
	account := self
		selectOne: #getAccount
		statement: 'SELECT id, name, password FROM accounts WHERE email=:email'
		bind: {
			#email -> (body at: #email) } asDictionary.

	account ifNil: [ self errorInvalidLogin ].

	"Validate password"
	(self class matchPassword: (body at: #password) withHash: (account at: #password))
		ifFalse: [ self errorInvalidLogin ].

	"Create session"
	self traceCr: 'Create session'
]

{ #category : #database }
SmRestApiService >> selectOne: aSymbol statement: aString bind: aDictionary [

	"Select a single row from the database and answer the object found"

	| rows |

	rows := (preparedStatements at: aSymbol ifAbsentPut: [ database prepare: aString ])
		allWithBindings: aDictionary.

	rows size > 1
		ifTrue: [ self error: 'More than one row found for single row select' ].

	^ rows
		ifNotEmpty: [ rows first ]
		ifEmpty: [ nil ]
]

{ #category : #validating }
SmRestApiService >> validateBody: body expectFields: aCollection [

	| missingFields |

	missingFields := aCollection select: [ :each |
		(body includesKey: each) not ].

	missingFields
		ifNotEmpty: [ self errorMissingInput: (', ' join: missingFields) ]
]
