Extension { #name : #SmModel }

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmModel >> asDictionary [

	"Answer a Dictionary representing the receiver"

	self subclassResponsibility
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmModel class >> installClassMethod: aCompiledMethod [

	super installClassMethod: aCompiledMethod.

	CpNodeJSRestResource registerOperation: aCompiledMethod
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmModel class >> removeClassMethod: aCompiledMethod [

	super removeClassMethod: aCompiledMethod.

	CpNodeJSRestResource unregisterOperation: aCompiledMethod
]
