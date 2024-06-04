Class {
	#name : #SmSecondaryView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmSecondaryView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		flex-wrap: nowrap;
		height: 100%;
		justify-content: space-between;
		align-items: center;
	}
	#navigation {
		flex: 0 0 auto;
		font-size: 3em;
	}
	#content {
		flex: 1 1 auto;
		height: 100%;
	}'
]

{ #category : #'web resources' }
SmSecondaryView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="navigation">
			<sl-icon-button id="back" name="arrow-left-circle"></sl-icon-button>
		</div>
		<div id="content">
			<slot></slot>
		</div>
	</div>'
]

{ #category : #accessing }
SmSecondaryView >> backButton [

	^ self shadowedElementWithId: #back
]

{ #category : #actions }
SmSecondaryView >> goBack [

	"Close the receiver by asking parent to close the secondary view"

	self parent closeSecondaryView
]

{ #category : #initialization }
SmSecondaryView >> initializeShadowRoot [

	super initializeShadowRoot.

	self backButton
		when: CpClickEvent basicPrimary send: #goBack to: self
]
