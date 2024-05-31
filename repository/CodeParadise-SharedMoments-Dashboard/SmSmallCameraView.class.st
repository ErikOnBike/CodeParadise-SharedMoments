Class {
	#name : #SmSmallCameraView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmSmallCameraView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-avatar id="avatar"></sl-avatar>
	</div>'
]

{ #category : #accessing }
SmSmallCameraView >> avatar [

	^ self shadowedElementWithId: #avatar
]

{ #category : #rendering }
SmSmallCameraView >> initializeShadowRoot [

	super initializeShadowRoot.

	self updateInitials
]

{ #category : #rendering }
SmSmallCameraView >> renderInitials: aString [

	self attributeAt: #initials put: aString.

	self updateInitials
]

{ #category : #rendering }
SmSmallCameraView >> updateInitials [

	self avatar initials: ((self attributeAt: #initials) ifNil: [ '?' ])
]
