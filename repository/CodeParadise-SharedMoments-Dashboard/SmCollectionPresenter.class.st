Class {
	#name : #SmCollectionPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmCollectionPresenter >> cameras [

	^ self collection cameras
]

{ #category : #accessing }
SmCollectionPresenter >> collection [

	^ self model
]

{ #category : #'event handling' }
SmCollectionPresenter >> handleAddCamera [

	self collection addCamera
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

{ #category : #accessing }
SmCollectionPresenter >> photoFrames [

	^ self collection photoFrames
]

{ #category : #rendering }
SmCollectionPresenter >> renderView [

	self view
		renderName: self collection name ;
		renderPhotoCount: self collection photoCount.

	self
		renderAllChildViewsForModels: self cameras
		usingPresenter: SmSmallCameraPresenter
		atSlotNamed: #cameras.

	self
		renderAllChildViewsForModels: self photoFrames
		usingPresenter: SmSmallPhotoFramePresenter
		atSlotNamed: #'photo-frames'
]

{ #category : #view }
SmCollectionPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #name) send: #handleNameChanged: to: self ;
		when: (CpActionRequested id: #addCamera) send: #handleAddCamera to: self ;
		when: (CpActionRequested id: #addPhotoFrame) send: #handleAddPhotoFrame to: self ;
		when: (CpActionRequested id: #delete) send: #handleDelete to: self
]
