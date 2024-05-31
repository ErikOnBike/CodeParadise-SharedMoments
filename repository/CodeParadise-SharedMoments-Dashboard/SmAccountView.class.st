Class {
	#name : #SmAccountView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmAccountView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		height: 100%;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		overflow-y: scroll;
	}
	#info {
		font-size: 1.8em;
		margin-bottom: 2em;
	}
	#collections {
		width: 80%;
		max-width: 40em;
	}
	#add-collection sl-icon-button {
		font-size: 4em;
		cursor: pointer;
	}
	::slotted(sm-collection) {
		width: 100%;
		margin-bottom: 1em;
	}'
]

{ #category : #'web resources' }
SmAccountView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="info"><span>Dashboard for </span><slot name="email"></slot></div>
		<div id="collections"><slot name="collections"></slot></div>
		<div id="add-collection"><sl-icon-button id="add-collection-button" name="plus-circle-dotted"></sl-icon-button></div>
	</div>'
]

{ #category : #'event handling' }
SmAccountView >> addButton [

	^ self shadowedElementWithId: #'add-collection'
]

{ #category : #'event handling' }
SmAccountView >> addCollection [

	self serverAnnounce: (CpActionRequested id: #addCollection)
]

{ #category : #initialization }
SmAccountView >> initializeShadowRoot [

	super initializeShadowRoot.

	self addButton
		when: CpClickEvent basicPrimary send: #addCollection to: self
]

{ #category : #rendering }
SmAccountView >> renderEmail: aString [

	self replaceAllChildrenWith: aString asHtmlElement atSlotNamed: #email
]
