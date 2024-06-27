Class {
	#name : #SmIconCameraView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmIconCameraView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<slot></slot>
	</div>'
]

{ #category : #rendering }
SmIconCameraView >> renderInitials: aString [

	self replaceAllChildrenWith: (SlAvatar new
		initials: aString ;
		yourself)
]
