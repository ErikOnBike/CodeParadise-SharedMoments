Class {
	#name : #SmCollectionPresenter,
	#superclass : #CpPresenter,
	#instVars : [
		'secondaryPresenter'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #presenter }
SmCollectionPresenter >> closeSecondaryPresenter [

	"Close the secondary presenter.

	Implementation:
	The view has has already become invisible, so only destroy it here."

	secondaryPresenter ifNil: [ ^ self ].

	secondaryPresenter destroy.
	secondaryPresenter := nil
]

{ #category : #accessing }
SmCollectionPresenter >> collection [

	^ self model
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleAddCameraInvite [

	self collection addCameraInvite
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleAddPhotoFrame [

	self collection addPhotoFrame
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleDelete [

	self collection delete
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleNameChanged: aFieldChanged [

	self collection name: aFieldChanged value
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleSelectSecondary: anActionRequested [

	"Handle the selection of a child presenter and open the secondary presenter on it"

	| childId childPresenter |

	childId := anActionRequested firstParameter asSymbol.
	childPresenter := self application presenterWithId: childId ifAbsent: [ ^ self ].
	childPresenter parent == self
		ifFalse: [ ^ self ].

	self openSecondaryPresenterOn: childPresenter model
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleUndelete [

	self collection undelete
]

{ #category : #presenter }
SmCollectionPresenter >> openSecondaryPresenterOn: aModel [

	"Open the secondary presenter on the specified model.

	Implementation:
	Re-use the existing presenter if it is of the expected 'type'.
	Otherwise remove the existing presenter and create a new one.
	Show the presenter after creation (making it appear/become
	visible)."

	secondaryPresenter ifNotNil: [
		secondaryPresenter class == aModel preferredPresenterClass
			ifTrue: [
				"Already the same presenter 'type', just update the model"
				secondaryPresenter model: aModel.
				self showSecondaryPresenter.
				^ self ].

		secondaryPresenter destroy.
		secondaryPresenter := nil ].

	"Create new secondary presenter and view"
	secondaryPresenter := self createChildPresenter: SmSecondaryPresenter forModel: aModel atSlotNamed: #secondary.
	self showSecondaryPresenter
]

{ #category : #rendering }
SmCollectionPresenter >> renderView [

	| collection |

	collection := self collection.

	self view
		renderRemoval: collection removalTimestampString ;
		renderName: collection name ;
		renderPhotoCount: collection photoCount.

	self
		renderAllChildViewsForModels: collection camerasAndInvites
		usingPresenter: [ :each | each iconPresenterClass ]
		atSlotNamed: #cameras.

	self
		renderAllChildViewsForModels: collection photoFrames
		usingPresenter: SmSmallPhotoFramePresenter
		atSlotNamed: #'photo-frames'
]

{ #category : #rendering }
SmCollectionPresenter >> showSecondaryPresenter [

	self view
		showSecondaryView
]

{ #category : #view }
SmCollectionPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #name) send: #handleNameChanged: to: self ;
		when: (CpActionRequested id: #addCameraInvite) send: #handleAddCameraInvite to: self ;
		when: (CpActionRequested id: #addPhotoFrame) send: #handleAddPhotoFrame to: self ;
		when: (CpActionRequested id: #delete) send: #handleDelete to: self ;
		when: (CpActionRequested id: #undelete) send: #handleUndelete to: self ;
		when: (CpActionRequested id: #selectSecondary) send: #handleSelectSecondary: to: self ;
		when: (CpActionRequested id: #closeSecondaryView) send: #closeSecondaryPresenter to: self
]
