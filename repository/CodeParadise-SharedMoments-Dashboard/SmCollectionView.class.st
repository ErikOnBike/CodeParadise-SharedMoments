Class {
	#name : #SmCollectionView,
	#superclass : #CpFieldsView,
	#instVars : [
		'photoCount'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmCollectionView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	:host {
		display: block;
	}
	sl-card {
		width: 100%;
	}
	#header,
	#footer {
		display: flex;
		align-items: center;
	}
	#header {
		column-gap: 1em;
	}
	#header ::slotted([slot="name"]) {
		flex: 1 1 auto;
	}
	.row {
		display: flex;
		align-items: center;
		column-gap: 1em;
		height: 4em;
		overflow: hidden;
	}
	.row .scrollable {
		display: flex;
		align-items: center;
		column-gap: 4px;
		height: 100%;
		overflow-x: scroll;
		-ms-overflow-style: none;
		scrollbar-width: none;
	}
	.row .scrollable::-webkit-scrollbar {
		display: none;
	}
	#delete-alert {
		display: none;
		color: red;
	}
	#delete-alert.show {
		display: inline-flex;
		align-items: center;
		column-gap: 6px;
	}
	sl-icon,
	sl-icon-button {
		font-size: 1.6em;
	}
	/* Fix Safari cutting off icons */
	sl-icon::part(svg) {
		overflow: visible;
	}'
]

{ #category : #'web resources' }
SmCollectionView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-card>
			<div id="header" slot="header"><sl-icon name="collection"></sl-icon><span>Collection</span><slot name="name"></slot></div>
			<div>
				<div id="cameras" class="row">
					<sl-tooltip content="Connected cameras" placement="right"><sl-icon name="camera"></sl-icon></sl-tooltip>
					<div class="scrollable"><slot name="cameras"></slot></div>
					<sl-icon-button id="add-camera" name="plus-circle-dotted"></sl-icon-button>
				</div>
				<div id="photo-frames" class="row">
					<sl-tooltip content="Connected photo frames" placement="right"><sl-icon name="display"></sl-icon></sl-tooltip>
					<div class="scrollable"><slot name="photo-frames"></slot></div>
					<sl-icon-button id="add-photo-frame" name="plus-circle-dotted"></sl-icon-button>
				</div>
				<div id="photos" class="row">
					<sl-tooltip content="Photos uploaded" placement="right"><sl-icon name="images"></sl-icon></sl-tooltip>
					<slot name="photos"></slot>
				</div>
			</div>
			<div id="footer" slot="footer">
				<sl-switch id="enable-delete"></sl-switch>
				<sl-button id="delete" variant="danger" disabled>Delete</sl-button>
				<span id="delete-alert">
					<sl-icon name="exclamation-triangle"></sl-icon>
					<span id="delete-alert-text"></span>
				</span>
			</div>
		</sl-card>
	</div>'
]

{ #category : #'event handling' }
SmCollectionView >> addCamera [

	self serverAnnounce: (CpActionRequested id: #addCamera)
]

{ #category : #accessing }
SmCollectionView >> addCameraButton [

	^ self shadowedElementWithId: #'add-camera'
]

{ #category : #'event handling' }
SmCollectionView >> addPhotoFrame [

	self serverAnnounce: (CpActionRequested id: #addPhotoFrame)
]

{ #category : #accessing }
SmCollectionView >> addPhotoFrameButton [

	^ self shadowedElementWithId: #'add-photo-frame'
]

{ #category : #rendering }
SmCollectionView >> createNameElement [

	"Create the receiver's name input element and hook up event listeners"

	(self appendChild: SlInput new atSlotNamed: #name)
		placeholder: '<name>' ;
		attachAsField: #name to: self
]

{ #category : #'event handling' }
SmCollectionView >> delete [

	self serverAnnounce: (CpActionRequested id: #delete)
]

{ #category : #accessing }
SmCollectionView >> deleteAlert [

	^ self shadowedElementWithId: #'delete-alert'
]

{ #category : #accessing }
SmCollectionView >> deleteAlertText [

	^ self shadowedElementWithId: #'delete-alert-text'
]

{ #category : #accessing }
SmCollectionView >> deleteButton [

	^ self shadowedElementWithId: #delete
]

{ #category : #accessing }
SmCollectionView >> enableDeleteSwitch [

	^ self shadowedElementWithId: #'enable-delete'
]

{ #category : #rendering }
SmCollectionView >> hideDeleteAlert [

	self deleteAlert removeClass: #show
]

{ #category : #initialization }
SmCollectionView >> initialize [

	super initialize.

	photoCount := 0.

	self createNameElement
]

{ #category : #initialization }
SmCollectionView >> initializeShadowRoot [

	super initializeShadowRoot.

	self addCameraButton
		when: CpClickEvent basicPrimary send: #addCamera to: self.

	self addPhotoFrameButton
		when: CpClickEvent basicPrimary send: #addPhotoFrame to: self.

	self deleteButton
		when: CpClickEvent basicPrimary send: #delete to: self.

	self enableDeleteSwitch
		when: SlChangeEvent send: #updateDeleteButton to: self
]

{ #category : #accessing }
SmCollectionView >> photoCount [

	^ photoCount
]

{ #category : #rendering }
SmCollectionView >> renderName: aString [

	self render: aString toInputAtSlotNamed: #name
]

{ #category : #rendering }
SmCollectionView >> renderPhotoCount: anInteger [

	| text |

	photoCount := anInteger.
	text := anInteger printString, ' photos'.

	self replaceAllChildrenWith: text asHtmlElement atSlotNamed: #photos
]

{ #category : #rendering }
SmCollectionView >> showDeleteAlert [

	self photoCount = 0
		ifTrue: [ ^ self ].

	self deleteAlert addClass: #show.

	self deleteAlertText textContent: self photoCount printString, ' photos will be deleted'
]

{ #category : #'event handling' }
SmCollectionView >> updateDeleteButton [

	| enableDelete |

	enableDelete := self enableDeleteSwitch isChecked.

	self deleteButton disabled: enableDelete not.

	enableDelete
		ifTrue: [ self showDeleteAlert ]
		ifFalse: [ self hideDeleteAlert ]
]
