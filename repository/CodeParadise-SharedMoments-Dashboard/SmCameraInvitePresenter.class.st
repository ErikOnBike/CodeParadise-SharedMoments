Class {
	#name : #SmCameraInvitePresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmCameraInvitePresenter >> cameraInvite [

	^ self model
]

{ #category : #'event handling' }
SmCameraInvitePresenter >> handleEmailChanged: aFieldChanged [

	self cameraInvite email: aFieldChanged value
]

{ #category : #'event handling' }
SmCameraInvitePresenter >> handleNameChanged: aFieldChanged [

	self cameraInvite name: aFieldChanged value
]

{ #category : #rendering }
SmCameraInvitePresenter >> renderView [

	| cameraInvite |

	cameraInvite := self cameraInvite.

	self view
		renderCollection: cameraInvite collection name ;
		renderName: cameraInvite name email: cameraInvite email
]

{ #category : #view }
SmCameraInvitePresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #name) send: #handleNameChanged: to: self ;
		when: (CpFieldChanged id: #email) send: #handleEmailChanged: to: self
]
