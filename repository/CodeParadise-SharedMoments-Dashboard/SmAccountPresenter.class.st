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

{ #category : #'event handling' }
SmAccountPresenter >> handleNameChanged: aFieldChanged [

	self account name: aFieldChanged value
]

{ #category : #rendering }
SmAccountPresenter >> renderView [

	| account |

	account := self account.

	self view
		renderName: account name email: account email.

	self renderAllChildViewsForModels: self collections atSlotNamed: #collections
]

{ #category : #view }
SmAccountPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpActionRequested id: #addCollection) send: #addCollection to: self ;
		when: (CpFieldChanged id: #name) send: #handleNameChanged: to: self
]
