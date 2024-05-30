Extension { #name : #CpSMModel }

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMModel >> asDictionary [

	"Answer a Dictionary representing the receiver"

	self subclassResponsibility
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMModel class >> installClassMethod: aCompiledMethod [

	super installClassMethod: aCompiledMethod.

	CpNodeJSRestResource registerOperation: aCompiledMethod
]

{ #category : #'*CodeParadise-SharedMoments-Data' }
CpSMModel class >> removeClassMethod: aCompiledMethod [

	super removeClassMethod: aCompiledMethod.

	CpNodeJSRestResource unregisterOperation: aCompiledMethod
]
