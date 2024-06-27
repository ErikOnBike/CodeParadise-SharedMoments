Class {
	#name : #SmAccountView,
	#superclass : #CpFieldsView,
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
		min-height: 100%;
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
		<div id="add-collection"><sl-icon-button id="add-collection-button" name="plus-circle"></sl-icon-button></div>
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

{ #category : #rendering }
SmAccountView >> createNameElement [

	"Create the receiver's name input element and hook up event listeners"

	(self appendChild: SlInput new atSlotNamed: #name)
		placeholder: '<name>' ;
		attachAsField: #name to: self
]

{ #category : #initialization }
SmAccountView >> initialize [

	super initialize.

	self createNameElement
]

{ #category : #initialization }
SmAccountView >> initializeShadowRoot [

	super initializeShadowRoot.

	self addButton
		when: CpClickEvent basicPrimary send: #addCollection to: self
]

{ #category : #rendering }
SmAccountView >> renderName: nameString email: emailString [

	self render: nameString toInputAtSlotNamed: #name.

	(self firstChildAtSlotNamed: #name)
		defaultValue: emailString
]
