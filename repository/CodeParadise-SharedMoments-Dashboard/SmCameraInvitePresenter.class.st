Class {
	#name : #SmCameraInvitePresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmCameraInvitePresenter >> cameraInvite [

	^ self model
]

{ #category : #accessing }
SmCameraInvitePresenter >> collection [

	^ self cameraInvite collection
]

{ #category : #rendering }
SmCameraInvitePresenter >> renderView [

	self view
		renderCollection: self collection name
]
