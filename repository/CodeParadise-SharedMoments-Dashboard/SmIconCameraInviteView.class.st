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
	:host {
		overflow: display;
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
		<sl-avatar id="avatar" shape="rounded"><sl-icon id="icon"></sl-icon></sl-avatar><sl-badge id="count" variant="primary" pill></sl-badge>
	</div>'
]

{ #category : #accessing }
SmIconCameraInviteView >> acceptCount [

	^ self shadowedElementWithId: #count
]

{ #category : #accessing }
SmIconCameraInviteView >> avatarIcon [

	^ self shadowedElementWithId: #icon
]

{ #category : #accessing }
SmIconCameraInviteView >> iconForStatus: aSymbol [

	aSymbol == #empty
		ifTrue: [ ^ #pencil ].

	aSymbol == #unsent
		ifTrue: [ ^ #send ].

	aSymbol == #sent
		ifTrue: [ ^ #'hour-glass-split' ].

	aSymbol == #expired
		ifTrue: [ ^ #alarm ].

	aSymbol == #accepted
		ifTrue: [ ^ #'check-lg' ].

	^ #'exclamation-triangle'
]

{ #category : #initialization }
SmIconCameraInviteView >> initializeShadowRoot [

	super initializeShadowRoot.

	self
		updateStatus ;
		updateAcceptCount
]

{ #category : #rendering }
SmIconCameraInviteView >> renderAcceptCount: anInteger [

	self attributeAt: #accepted put: anInteger printString.

	self updateAcceptCount
]

{ #category : #rendering }
SmIconCameraInviteView >> renderStatus: aSymbol [

	self attributeAt: #status put: aSymbol.

	self updateStatus
]

{ #category : #rendering }
SmIconCameraInviteView >> updateAcceptCount [

	| count |

	count := self attributeAt: #accepted.

	self acceptCount textContent: count
]

{ #category : #validation }
SmIconCameraInviteView >> updateStatus [

	| status |

	status := self attributeAt: #status.
	
	self avatarIcon name: (self iconForStatus: status)
]
