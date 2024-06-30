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

	| current action pragma operation |

	current := self current.
	action := MessageSend receiver: current selector: aCompiledMethod selector.

	pragma := aCompiledMethod pragmas
		detect: [ :each | #(#get: #post: #put: #delete:) includes: each keyword ] ifNone: [ ^ nil ].

	pragma keyword == #get:
		ifTrue: [ operation := CpNodeJSRestEndpointOperation path: pragma arguments first getOperation: action ].
	pragma keyword == #post:
		ifTrue: [ operation := CpNodeJSRestEndpointOperation path: pragma arguments first postOperation: action ].
	pragma keyword == #put:
		ifTrue: [ operation := CpNodeJSRestEndpointOperation path: pragma arguments first putOperation: action ].

	"Add a default authorization handler for non public endpoints"
	(aCompiledMethod pragmas detect: [ :each | each keyword = #public ] ifNone: [ nil ]	)
		ifNil: [ operation setAuthorizationBlock: [ :restRequest | current isAuthorizedRequest: restRequest ] ].

	"Add (or replace the default authorization handler with) a custom authorization handler (if specified)"
	(aCompiledMethod pragmas detect: [ :each | each keyword = #authorization: ] ifNone: [ nil ])
		ifNotNil: [ :authorizationPragma |
			operation setAuthorizationBlock: [ :restRequest | current perform: authorizationPragma arguments first withArguments: { restRequest } ] ].

	operation
		ifNotNil: [ ^ operation ].

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
SmRestApiService >> addPhoto: aRestRequest response: aServerResponse [

	<post: '/api/v1/photos'>
	<authorization: #isAuthorizedCameraRequest:>

	| body createdAt collectionIds width height orientation fileName |

	body := (aRestRequest body) ifNil: [ self errorNoBody ].

	createdAt := self class timestampNow.
	collectionIds := (aRestRequest headerAt: #'sm-collection-ids')
		ifNotNil: [ :ids | ids findTokens: ',' ]
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

{ #category : #'API - support' }
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

	CpNodeJSRestUnauthorizedError signal: 'Credentials provided do not match an active account'
]

{ #category : #errors }
SmRestApiService >> errorInvalidPhotoFrame [

	CpNodeJSRestUnauthorizedError signal: 'Missing or invalid access token for PhotoFrame'
]

{ #category : #errors }
SmRestApiService >> errorMissingHeader: aString [

	CpNodeJSRestBadRequestError signal: 'Missing header in REST request: ', aString
]

{ #category : #errors }
SmRestApiService >> errorMissingInput: aString [

	CpNodeJSRestBadRequestError signal: 'Missing field in REST request: ', aString
]

{ #category : #errors }
SmRestApiService >> errorNoBody [

	CpNodeJSRestBadRequestError signal: 'No body present in REST request'
]

{ #category : #API }
SmRestApiService >> getAccount: aRestRequest response: aServerResponse [

	<get: '/api/v1/accounts/:id'>

	| account |

	account := Dictionary new.
	self readAccountWithId: (aRestRequest pathParameterAt: #id) into: account.

	"Answer account"
	self send: account response: aServerResponse
]

{ #category : #API }
SmRestApiService >> getPhoto: aRestRequest response: aServerResponse [

	<get: '/api/v1/photos/next'>
	<authorization: #isAuthorizedPhotoFrameRequest:>

	| accessToken photoFrame recentPhotoIds photos photo |

	accessToken := (aRestRequest headerAt: #authorization)
		ifNotNil: [ :header | header withoutPrefix: 'Bearer ' ]
		ifNil: [ self errorInvalidPhotoFrame ].

	"Retrieve photo frame"
	photoFrame := self
		selectOne: #getPhotoFrame
		statement: 'SELECT id, collectionId, recentPhotoIds FROM photo_frames WHERE accessToken=:accessToken'
		bind: { #accessToken -> accessToken } asDictionary.
	photoFrame ifNil: [ self errorInvalidPhotoFrame ].
	recentPhotoIds := (photoFrame at: #recentPhotoIds) findTokens: ','.

	"Retrieve all photo records"
	photos := self
		selectMany: #allPhotos
		statement: 'SELECT id, orientation, filename FROM photos WHERE collectionId=:collectionId ORDER BY id'
		bind: { #collectionId -> (photoFrame at: #collectionId) } asDictionary.

	"Select photos"
	photos size > recentPhotoIds size
		ifTrue: [ photos := photos reject: [ :each | recentPhotoIds includes: (each at: #id) ] ]
		ifFalse: [
			photos := Array with: recentPhotoIds first.
			recentPhotoIds := recentPhotoIds allButFirst ].

	"Pick a more recent or otherwise random photo"
	recentPhotoIds ifNotEmpty: [
		| mostRecentPhotoId mostRecentIndex |
		mostRecentPhotoId := recentPhotoIds last.
		mostRecentIndex := photos findFirst: [ :each | (each at: #id) = mostRecentPhotoId ].
		(mostRecentIndex > 0 and: [ mostRecentIndex < photos size ])
			ifTrue: [ photos := Array with: (photos at: mostRecentIndex + 1) ] ].
	photo := photos at: (photos size = 1
		ifTrue: [ 1 ]
		ifFalse: [ (CpNodeJSCrypto require randomIntBetween: 1 and: photos size + 1) ]).

	"Keep track of recent photos"
	recentPhotoIds := recentPhotoIds copyWith: (photo at: #id).
	recentPhotoIds size > 10
		ifTrue: [ recentPhotoIds := recentPhotoIds allButFirst: recentPhotoIds size - 10 ].
	self
		perform: #updatePhotoFrameRecentPhotos
		statement: 'UPDATE photo_frames SET recentPhotoIds=:recentPhotoIds WHERE id=:id'
		bind: {
			#id -> (photoFrame at: #id).
			#recentPhotoIds -> (',' join: recentPhotoIds) } asDictionary. 

	self
		send: {
			#url -> (photo at: #filename).
			#orientation -> (photo at: #orientation) } asDictionary
		response: aServerResponse
]

{ #category : #initialization }
SmRestApiService >> initialize [

	super initialize.

	database := CpNodeJSSqlite3Database onPath: 'data/database.db' withOptions: Dictionary new.
	preparedStatements := Dictionary new
]

{ #category : #'API - authorization' }
SmRestApiService >> isAuthorizedCameraRequest: aRestRequest [

	"Authorization handler for cameras"

	| accessToken |

	accessToken := (aRestRequest headerAt: #authorization)
		ifNotNil: [ :header | header withoutPrefix: 'Bearer ' ]
		ifNil: [ ^ false ].

	"Check for valid camera"
	[
		| matchedCameras |

		matchedCameras := self
			selectCount: #isAuthorizedCamera
			statement: 'SELECT COUNT(*) FROM cameras WHERE accessToken=:accessToken'
			bind: { #accessToken -> accessToken } asDictionary.

		matchedCameras = 1
			ifFalse: [ ^ false ].
	] on: Error do: [ ^ false ].

	^ true
]

{ #category : #'API - authorization' }
SmRestApiService >> isAuthorizedPhotoFrameRequest: aRestRequest [

	"Authorization handler for photo frames"

	| accessToken |

	accessToken := (aRestRequest headerAt: #authorization)
		ifNotNil: [ :header | header withoutPrefix: 'Bearer ' ]
		ifNil: [ ^ false ].

	"Check for valid photo frame"
	[
		| matchedPhotoFrames |

		matchedPhotoFrames := self
			selectCount: #isAuthorizedPhotoFrame
			statement: 'SELECT COUNT(*) FROM photo_frames WHERE accessToken=:accessToken'
			bind: { #accessToken -> accessToken } asDictionary.

		matchedPhotoFrames = 1
			ifFalse: [ ^ false ].
	] on: Error do: [ ^ false ].

	^ true
]

{ #category : #'API - authorization' }
SmRestApiService >> isAuthorizedRequest: aRestRequest [

	"Default authorization handler"

	| sessionId accessToken |

	sessionId := (aRestRequest headerAt: #'sm-session-id') ifNil: [ ^ false ].
	accessToken := (aRestRequest headerAt: #authorization)
		ifNotNil: [ :header | header withoutPrefix: 'Bearer ' ]
		ifNil: [ ^ false ].

	"Check for valid session"
	[
		| matchedSessions |

		matchedSessions := self
			selectCount: #isAuthorized
			statement: 'SELECT COUNT(*) FROM sessions WHERE id=:id AND accessToken=:accessToken'
			bind: {
				#id -> sessionId.
				#accessToken -> accessToken } asDictionary.

		matchedSessions = 1
			ifFalse: [ ^ false ].
	] on: Error do: [ ^ false ].

	^ true
]

{ #category : #API }
SmRestApiService >> login: aRestRequest response: aServerResponse [

	<post: '/api/v1/sessions'>
	<public>

	| body account |

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

	self readAccountWithId: (account at: #id) into: account.

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

{ #category : #'API - support' }
SmRestApiService >> readAccountWithId: aString into: aDictionary [

	| collections |

	"Read collections and add to account"
	collections := self
		selectMany: #getCollections
		statement: 'SELECT id, createdAt, updatedAt, name FROM collections WHERE deletedAt IS NULL AND accountId=:accountId'
		bind: { #accountId -> aString } asDictionary.
	aDictionary at: #collections put: collections.

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

	"Read photo count and add to collections"
	collections do: [ :each |
		| photoCount |
		photoCount := self
			selectCount: #photoCount
			statement: 'SELECT COUNT(*) FROM photos WHERE deletedAt IS NULL AND collectionId=:collectionId'
			bind: { #collectionId -> (each at: #id) } asDictionary.
		each at: #photoCount put: photoCount ]
]

{ #category : #database }
SmRestApiService >> selectCount: aSymbol statement: aString bind: aDictionary [

	"Answer the count of a count query.
	It is assumed the statement uses 'COUNT(*)' as result.
	This is case sensitive."

	^ (self selectOne: aSymbol statement: aString bind: aDictionary)
		at: #'COUNT(*)'
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
