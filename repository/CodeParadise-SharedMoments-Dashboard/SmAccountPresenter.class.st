Class {
	#name : #SmAccountPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmAccountPresenter >> account [

	^ self model
]

{ #category : #adding }
SmAccountPresenter >> addCollection [

	self account addCollection
]

{ #category : #accessing }
SmAccountPresenter >> collections [

	^ self account collections
]

{ #category : #rendering }
SmAccountPresenter >> renderView [

	self view
		renderEmail: self account email.

	self renderAllChildViewsForModels: self collections atSlotNamed: #collections
]

{ #category : #view }
SmAccountPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpActionRequested id: #addCollection) send: #addCollection to: self
]
