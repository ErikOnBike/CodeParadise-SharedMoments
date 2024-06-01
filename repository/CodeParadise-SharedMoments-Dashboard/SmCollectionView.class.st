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
	#delete-status {
		display: none;
		position: absolute;
		left: 50%;
		transform: translate(-50%, -.4em);
		z-index: 2;
	}
	:host(.deleted) #delete-status {
		display: block;
	}
	sl-card {
		position: relative;
		width: 100%;
	}
	:host(.deleted) sl-card {
		pointer-events: none;
		user-select: none;
		-webkit-user-select: none;
	}
	:host(.deleted) sl-card::after {
		content: " ";
		display: block;
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		border-radius: var(--sl-border-radius-medium);
		background-color: white;
		opacity: .7;
	}
	#undelete {
		display: none;
	}
	:host(.deleted) #delete {
		display: none;
	}
	:host(.deleted) #undelete {
		pointer-events: auto;
		display: inline-block;
		z-index: 3;
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
		<sl-tag id="delete-status" variant="warning" size="large" pill><span>Deleted (will be removed&nbsp;</span><sl-relative-time id="removal"></sl-relative-time><span>)</span></sl-tag>
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
				<sl-button id="delete" variant="danger">Delete</sl-button><sl-button id="undelete" variant="primary">Undelete</sl-button>
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
SmCollectionView >> deleteButton [

	^ self shadowedElementWithId: #delete
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

	self undeleteButton
		when: CpClickEvent basicPrimary send: #undelete to: self.

	"Update the current state"
	self updateRemovalText
]

{ #category : #accessing }
SmCollectionView >> nameInput [

	^ self firstChildAtSlotNamed: #name
]

{ #category : #accessing }
SmCollectionView >> photoCount [

	^ photoCount
]

{ #category : #accessing }
SmCollectionView >> removalTimestampText [

	^ self shadowedElementWithId: #removal
]

{ #category : #rendering }
SmCollectionView >> renderDeleteStatus: aBoolean [

	self classed: #deleted if: aBoolean.

	self nameInput disabled: aBoolean.
	self addCameraButton disabled: aBoolean.
	self addPhotoFrameButton disabled: aBoolean
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
SmCollectionView >> renderRemoval: aString [

	"Render the removal timestamp (as specified as a String).
	If the specified timestamp is nil, the receiver's model is
	not deleted."

	self renderDeleteStatus: aString isNotNil.

	self attributeAt: #removal put: aString.

	self updateRemovalText
]

{ #category : #'event handling' }
SmCollectionView >> undelete [

	self serverAnnounce: (CpActionRequested id: #undelete)
]

{ #category : #accessing }
SmCollectionView >> undeleteButton [

	^ self shadowedElementWithId: #undelete
]

{ #category : #rendering }
SmCollectionView >> updateRemovalText [

	"Set the text for the upcoming removal (if any) of the receiver's model"

	| removalTimestamp |

	removalTimestamp := self attributeAt: #removal.

	self removalTimestampText attributeAt: #date put: removalTimestamp
]
