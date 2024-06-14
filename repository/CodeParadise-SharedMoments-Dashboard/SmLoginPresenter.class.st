Class {
	#name : #SmLoginPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmLoginPresenter >> dashboard [

	^ self model
]

{ #category : #'event handling' }
SmLoginPresenter >> login: anActionRequested [

	(self dashboard login: anActionRequested parameters)
		ifFalse: [ self view renderFailedLogin ]
]

{ #category : #view }
SmLoginPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpActionRequested id: #login) send: #login: to: self
]
