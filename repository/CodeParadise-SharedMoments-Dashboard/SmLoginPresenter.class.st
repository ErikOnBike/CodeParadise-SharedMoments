Class {
	#name : #SmLoginPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #'event handling' }
SmLoginPresenter >> login: anActionRequested [

	| credentials account |

	credentials := SmCredentials fromDictionary: anActionRequested parameters.

	account := SmAccount withCredentials: credentials.

	account ifNil: [
		self view renderFailedLogin.
		^ self ].

	self model account: account
]

{ #category : #view }
SmLoginPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpActionRequested id: #login) send: #login: to: self
]
