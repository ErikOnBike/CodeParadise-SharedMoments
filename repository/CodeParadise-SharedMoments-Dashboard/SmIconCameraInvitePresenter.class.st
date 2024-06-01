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

	| cameraInvite |

	cameraInvite := self cameraInvite.

	self view
		renderStatus: cameraInvite status ;
		renderAcceptCount: cameraInvite acceptCount
]
