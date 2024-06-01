Class {
	#name : #SmCollectionPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

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
SmCollectionPresenter >> handleUndelete [

	self collection undelete
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

{ #category : #view }
SmCollectionPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #name) send: #handleNameChanged: to: self ;
		when: (CpActionRequested id: #addCameraInvite) send: #handleAddCameraInvite to: self ;
		when: (CpActionRequested id: #addPhotoFrame) send: #handleAddPhotoFrame to: self ;
		when: (CpActionRequested id: #delete) send: #handleDelete to: self ;
		when: (CpActionRequested id: #undelete) send: #handleUndelete to: self 
]
