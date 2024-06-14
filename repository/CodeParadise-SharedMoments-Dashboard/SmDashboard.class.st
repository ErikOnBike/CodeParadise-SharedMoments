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

	^ account
]

{ #category : #accessing }
SmDashboard >> account: anAccount session: aSession [

	account := anAccount.
	session := aSession.

	self valueChanged
]

{ #category : #'event handling' }
SmDashboard >> login: aDictionary [

	| credentials newSession newAccount |

	credentials := SmCredentials fromDictionary: aDictionary.

	newSession := SmSession withCredentials: credentials.

	newAccount := SmAccount forId: newSession accountId.
newAccount inspect.
	newAccount ifNil: [ ^ false ].

	self account: newAccount session: newSession
]

{ #category : #'event handling' }
SmDashboard >> logout [

	self account: nil session: nil
]

{ #category : #presenter }
SmDashboard >> preferredPresenterClass [

	account ifNil: [ ^ SmLoginPresenter ].

	^ super preferredPresenterClass
]

{ #category : #accessing }
SmDashboard >> session [

	^ session
]
