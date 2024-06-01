Class {
	#name : #SmIconCameraView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmIconCameraView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-avatar id="avatar"></sl-avatar>
	</div>'
]

{ #category : #accessing }
SmIconCameraView >> avatar [

	^ self shadowedElementWithId: #avatar
]

{ #category : #rendering }
SmIconCameraView >> initializeShadowRoot [

	super initializeShadowRoot.

	self updateInitials
]

{ #category : #rendering }
SmIconCameraView >> renderInitials: aString [

	self attributeAt: #initials put: aString.

	self updateInitials
]

{ #category : #rendering }
SmIconCameraView >> updateInitials [

	self avatar initials: ((self attributeAt: #initials) ifNil: [ '?' ])
]
