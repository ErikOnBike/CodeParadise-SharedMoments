Class {
	#name : #SmIconCameraInviteView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmIconCameraInviteView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		position: relative;
		overflow: display;
	}
	#count {
		position: absolute;
		top: -6px;
		right: -6px;
	}'
]

{ #category : #'web resources' }
SmIconCameraInviteView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-avatar id="avatar" shape="rounded"><sl-icon id="icon" slot="icon"></sl-icon></sl-avatar>
	</div>'
]

{ #category : #accessing }
SmIconCameraInviteView >> avatarIcon [

	^ self shadowedElementWithId: #icon
]

{ #category : #accessing }
SmIconCameraInviteView >> iconForStatus: aString [

	"Since the status is stored in an attribute, it is a String"

	aString ifNil: [ ^ #asterisk ].

	aString = #empty
		ifTrue: [ ^ #pencil ].

	aString = #unsent
		ifTrue: [ ^ #send ].

	aString = #sent
		ifTrue: [ ^ #'hour-glass-split' ].

	aString = #expired
		ifTrue: [ ^ #alarm ].

	aString = #accepted
		ifTrue: [ ^ #'check-lg' ].

	^ #'exclamation-triangle'
]

{ #category : #initialization }
SmIconCameraInviteView >> initializeShadowRoot [

	super initializeShadowRoot.

	self updateStatus
]

{ #category : #rendering }
SmIconCameraInviteView >> renderStatus: aSymbol [

	self attributeAt: #status put: aSymbol.

	self updateStatus
]

{ #category : #validation }
SmIconCameraInviteView >> updateStatus [

	| status |

	status := self attributeAt: #status.
	
	self avatarIcon name: (self iconForStatus: status)
]
