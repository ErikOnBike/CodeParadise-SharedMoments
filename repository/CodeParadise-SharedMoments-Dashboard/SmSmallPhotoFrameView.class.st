Class {
	#name : #SmSmallPhotoFrameView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmSmallPhotoFrameView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-tag id="name" size="medium" pill><slot></slot></sl-tag>
	</div>'
]

{ #category : #rendering }
SmSmallPhotoFrameView >> renderName: aString [

	self replaceAllChildrenWith: (aString ifNil: [ '<unnamed>' ]) asHtmlElement
]
