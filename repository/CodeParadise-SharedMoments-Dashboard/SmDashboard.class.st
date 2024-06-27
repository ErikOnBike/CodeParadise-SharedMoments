Class {
	#name : #SmDashboard,
	#superclass : #CpModel,
	#instVars : [
		'account',
		'session'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmDashboard >> account [

	^ session
		ifNotNil: [ session account ]
]

{ #category : #testing }
SmDashboard >> hasAccount [

	^ session
		ifNotNil: [ session hasAccount ]
		ifNil: [ false ]
]

{ #category : #'event handling' }
SmDashboard >> login: aDictionary [

	"Try to login with the specified credentials (email/password)
	and answer a Boolean indicating whether the login was successful"

	| credentials |

	credentials := SmCredentials fromDictionary: aDictionary.

	self session: (SmSession withCredentials: credentials).

	^ true
]

{ #category : #'event handling' }
SmDashboard >> logout [

	self session: nil
]

{ #category : #presenter }
SmDashboard >> preferredPresenterClass [

	self hasAccount
		ifFalse: [ ^ SmLoginPresenter ].

	^ super preferredPresenterClass
]

{ #category : #accessing }
SmDashboard >> session [

	^ session
]

{ #category : #accessing }
SmDashboard >> session: aSession [

	session := aSession.
	self valueChanged
]
