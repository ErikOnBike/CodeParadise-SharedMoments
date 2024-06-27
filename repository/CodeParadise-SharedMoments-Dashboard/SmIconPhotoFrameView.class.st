Class {
	#name : #SmIconPhotoFrameView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmIconPhotoFrameView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-tag id="name" size="medium" pill><slot></slot></sl-tag>
	</div>'
]

{ #category : #rendering }
SmIconPhotoFrameView >> renderName: aString [

	self replaceAllChildrenWith: (aString ifNil: [ '<unnamed>' ]) asHtmlElement
]
