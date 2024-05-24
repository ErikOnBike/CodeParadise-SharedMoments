Extension { #name : #CpSMAccount }

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMAccount class >> create: anObject [

	"Create a new account and answer its identifier"

	<restMethod: #POST path: '/accounts'>
	<restParam: 1 from: #body>

	self traceCr: 'create ', anObject printString, ' class ', anObject class printString.
	anObject keysAndValuesDo: [ :key :value |
		self traceCr: key printString, ' -> ', value printString ].

	^ 'YES'
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMAccount class >> delete: aString [

	"Delete an existing account"

	<restMethod: #DELETE path: '/accounts/:id'>
	<restParam: 1 from: #path at: #id>

	self traceCr: 'delete ', aString.

	^ aString, ' deleted'
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMAccount class >> gc [

	"Perform GC"

	<restMethod: #GET path: '/gc'>

	Object allSubclassesDo: [ :each |
		self traceCr: each class printString, ' - ', each allInstances size printString ].

	Smalltalk garbageCollect.

	^ 42
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMAccount class >> list [

	"Answer all accounts"

	<restMethod: #GET path: '/accounts'>

	self traceCr: 'list'.
	self class selectorsAndMethodsDo: [ :sel :met | self traceCr: 'selector ', sel ].

	^ { 1 . 2 . 3 }
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMAccount class >> update: aString with: anObject [

	"Update an existing account"

	<restMethod: #PATCH path: '/accounts/:id'>
	<restParam: 1 from: #path at: #id>
	<restParam: 2 from: #body>

	self traceCr: 'update ', aString, ' with ', anObject printString
]
