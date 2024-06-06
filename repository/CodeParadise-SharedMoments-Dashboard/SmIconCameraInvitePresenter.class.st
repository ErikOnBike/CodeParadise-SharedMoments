Class {
	#name : #SmIconCameraInvitePresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmIconCameraInvitePresenter >> cameraInvite [

	^ self model
]

{ #category : #rendering }
SmIconCameraInvitePresenter >> renderView [

	self view
		renderStatus: self cameraInvite status
]
