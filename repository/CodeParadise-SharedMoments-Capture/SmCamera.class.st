"
I represent the camera in or attached to your computer or mobile.
On mobile devices the front and back camera can be used. A camera
icon is visible for switching between the two. If only a single
camera is available on the device, switching camera will have no
effect.
A live image is shown to help take the picture. This image is
flipped horizontally to match the behaviour of many mobile
camera apps.
I can be used to take a picture. When taken a shutter sound is
played. Once taken, the still picture is shown and two buttons
appear allowing to keep the picture or take a new one.

"
Class {
	#name : #SmCamera,
	#superclass : #CpTemplateComponent,
	#instVars : [
		'facingMode',
		'videoStream',
		'visibilityChangeHandler',
		'orientationChangeHandler'
	],
	#category : #'CodeParadise-SharedMoments-Capture-View'
}

{ #category : #'class initialization' }
SmCamera class >> beLoaded [

	CpBrowserScreenOrientation beLoaded.
	CpBrowserMediaStream beLoaded.
	CpBrowserMediaStreamTrack beLoaded.
	CpBrowserCanvasRenderingContext2D beLoaded
]

{ #category : #'web resources' }
SmCamera class >> style [

	<webResource: #css>

	^ '*, *:before, *:after {
		box-sizing: border-box;
	}
	#container {
		height: 100%;
		background-color: black;
	}
	::slotted([slot="video"]) {
		width: 100%;
		height: 100%;
		max-width: 100vw;
		max-height: 100vh;
	}
	/* By default flip image for user facing camera */
	:host(.facing-user:not(.flipped)) ::slotted([slot="video"]) {
		transform: scale(-1,1);
	}
	::slotted([slot="picture"]) {
		width: 100%;
		height: 100%;
		max-width: 100vw;
		max-height: 100vh;
		object-fit: contain;
	}
	::slotted([slot="button"]) {
		display: block;
		position: absolute;
		left: calc(50% - 25px);
		bottom: 25px;
		width: 50px;
		height: 50px;
	}
	::slotted([slot="flip"]) {
		display: none;
		position: absolute;
		left: 25px;
		bottom: 25px;
		font-size: 50px;
		color: white;
	}
	:host(.facing-user) ::slotted([slot="flip"]) {
		display: block;
	}
	::slotted([slot="flip-status"]) {
		display: block;
		position: absolute;
		left: 50%;
		top: 25px;
		width: 12em;
		height: 2em;
		line-height: 2em;
		text-align: center;
		border-radius: 1em;
		transform: translateX(-50%);
		font-size: 20px;
		background-color: white;
		color: black;
		opacity: 0;
	}
	::slotted([slot="switch"]) {
		position: absolute;
		right: 25px;
		bottom: 25px;
		font-size: 50px;
		color: white;
	}
	#buttons {
		display: flex;
		justify-content: space-around;
		column-gap: 10%;
		align-content: stretch;
		position: absolute;
		bottom: 25px;
		left: 10%;
		width: 80%;
	}
	#buttons ::slotted(sl-button) {
		width: 100%;
	}
	/* Position buttons based on orientation */
	:host([orientation="left"]) ::slotted([slot="flip"]) {
		left: auto;
		bottom: auto;
		right: 25px;
		top: 25px;
	}
	:host([orientation="left"]) ::slotted([slot="button"]) {
		left: auto;
		bottom: auto;
		right: 25px;
		top: calc(50% - 25px);
	}
	:host([orientation="right"]) ::slotted([slot="flip"]) {
		left: 25px;
		bottom: auto;
		top: 25px;
	}
	:host([orientation="right"]) ::slotted([slot="button"]) {
		left: 25px;
		bottom: auto;
		top: calc(50% - 25px);
	}
	:host([orientation="right"]) ::slotted([slot="switch"]) {
		right: auto;
		left: 25px;
	}
	/* For use on desktop/laptop with mouse pointer */
	slot[name="button"],
	slot[name="switch"] {
		cursor: pointer;
	}
	:host(.captured) #capture {
		display: none;
	}
	:host(:not(.captured)) #captured {
		display: none;
	}'
]

{ #category : #'web resources' }
SmCamera class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="capture">
			<slot name="video"></slot>
			<slot name="button"></slot>
			<slot name="flip"></slot>
			<slot name="flip-status"></slot>
			<slot name="switch"></slot>
		</div>
		<div id="captured">
			<slot name="picture"></slot>
			<div id="buttons">
				<slot name="keep"></slot>
				<slot name="retake"></slot>
			</div>
		</div>
	</div>'
]

{ #category : #view }
SmCamera >> addButton [

	| button |

	button := SmCameraButton new
		when: CpClickEvent primary only send: #takePicture to: self ;
		yourself.

	self appendChild: button atSlotNamed: #button
]

{ #category : #view }
SmCamera >> addCanvas [

	self
		appendChild: (CpHtmlElement newWithTag: #canvas)
		atSlotNamed: #picture
]

{ #category : #view }
SmCamera >> addFlip [

	| flip |

	flip := (SlIcon named: 'arrow-left-right')
		when: CpClickEvent primary only send: #flipImage to: self ;
		yourself.

	self appendChild: flip atSlotNamed: #flip
]

{ #category : #view }
SmCamera >> addKeepButton [

	| keepButton |

	keepButton := (SlButton label: 'Keep')
		bePill ;
		when: CpClickEvent primary only send: #keepPicture to: self ;
		yourself.

	self appendChild: keepButton atSlotNamed: #keep
]

{ #category : #view }
SmCamera >> addOrientationChangeHandler [

	"Add event handler for device orientation.

	Implementation:
	It also contains a fallback scenario for my iPhone SE 1st generation ;-)"

	| orientation |

	orientation := CpBrowserScreen current orientation.

	orientation ifNotNil: [
		orientationChangeHandler := orientation
			addEventListener: #change handler: [ self orientationChanged ].
		^ self ].

	"Fallback"
	(CpBrowserWindow current propertyAt: #DeviceOrientationEvent)
		ifNotNil: [ :orientationEventClass |
			(orientationEventClass propertyAt: #requestPermission)
				ifNotNil: [ :permissionFunction |
					(permissionFunction call: orientationEventClass withArguments: nil)
						then: [ :permission |
							permission = #granted
								ifTrue: [
									CpBrowserWindow current
										addEventListener: #deviceorientation handler: [ self orientationChanged ] ] ]
						catch: [
							CpHtmlElement documentBody appendChild: ((SlButton label: 'Start')
								when: CpClickEvent primary only do: [ :event |
									event target remove.
									(permissionFunction call: orientationEventClass withArguments: nil)
										then: [ :permission |
											permission = #granted
												ifTrue: [
													CpBrowserWindow current
														addEventListener: #deviceorientation handler: [ self orientationChanged ] ] ]
										catch: [
											self traceCr: 'no permission' ] ] ;
								yourself) ] ] ]

					"CpBrowserWindow current
						addEventListener: #deviceorientation handler: [ self orientationChanged ]"
]

{ #category : #view }
SmCamera >> addRetakeButton [

	| retakeButton |

	retakeButton := (SlButton label: 'Retake')
		bePill ;
		when: CpClickEvent primary only send: #retakePicture to: self ;
		yourself.

	self appendChild: retakeButton atSlotNamed: #retake
]

{ #category : #view }
SmCamera >> addSwitch [

	| switch |

	switch := (SlIcon named: 'camera')
		when: CpClickEvent primary only send: #switchCamera to: self ;
		yourself.

	self appendChild: switch atSlotNamed: #switch
]

{ #category : #view }
SmCamera >> addVideo [

	self
		appendChild: ((CpHtmlElement newWithTag: #video)
			attributeAt: 'playsinline' put: '' ;
			yourself)
		atSlotNamed: #video
]

{ #category : #view }
SmCamera >> addVisibilityChangeHandler [

	visibilityChangeHandler := CpBrowserDocument current
		addEventListener: #visibilitychange handler: [ self visibilityChanged ]
]

{ #category : #view }
SmCamera >> attachVideo [

	"Do not attach video if an image is captured"
	self hasCaptured
		ifTrue: [ ^ self ].

	self withVideoStreamDo: [ :stream |
		self videoElement
			srcObject: stream ;
			play ]
]

{ #category : #accessing }
SmCamera >> canvasElement [

	^ CpBrowserCanvasElement domElement: (self firstChildAtSlotNamed: #picture)
]

{ #category : #view }
SmCamera >> detachVideo [

	videoStream
		ifNotNil: [
			videoStream stop.
			videoStream := nil ].

	self videoElement
		pause ;
		srcObject: nil
]

{ #category : #actions }
SmCamera >> flipImage [

	| status statusElement |

	self toggleClass: #flipped.

	"Update status (default is mirrored)"
	status := (self isClassed: #flipped)
		ifTrue: [ 'Actual' ]
		ifFalse: [ 'Mirrored' ].

	statusElement := (self firstChildAtSlotNamed: #'flip-status')
		ifNotNil: [ :element | element textContent: status ]
		ifNil: [ self appendChild: status asHtmlElement atSlotNamed: #'flip-status' ].

	"Temporarily show status"
	statusElement animate: CpCssAnimation showTemporarilyKeyframes duration: 2500
]

{ #category : #testing }
SmCamera >> hasCaptured [

	^ self isClassed: #captured
]

{ #category : #initialization }
SmCamera >> initialize [

	super initialize.

	facingMode := #environment.

	self
		addVideo ;
		attachVideo ;
		addCanvas ;
		addButton ;
		addFlip ;
		addSwitch ;
		addKeepButton ;
		addRetakeButton.

	"Add event handler to turn off video when document is no longer visible"
	self addVisibilityChangeHandler.

	"Add event handler to switch UI when orientation changes"
	self addOrientationChangeHandler
]

{ #category : #actions }
SmCamera >> keepPicture [

	"Keep the current picture, announcing its content"

	self canvasElement toBlobType: 'image/png' thenDo: [ :blob |
		CpDownloader blob: blob filename: 'picture.png' ]
]

{ #category : #'event handling' }
SmCamera >> orientationChanged [

	"Add orientation attribute to the receiver to describe orientation
	(to allow position updates in CSS).

	Implementation:
	This method has a fallback if Orientation API is not supported."

	| orientation angle |

	orientation := CpBrowserScreen current orientation.

	angle := orientation
		ifNotNil: [ orientation angle ]
		ifNil: [ CpBrowserWindow current orientation ].

	self attributeAt: #orientation put: (self orientationFromAngle: angle)
]

{ #category : #accessing }
SmCamera >> orientationFromAngle: anInteger [

	anInteger == 0
		ifTrue: [ ^ #straight ].

	anInteger == 90
		ifTrue: [ ^ #left ].

	anInteger == -90
		ifTrue: [ ^ #right ].

	anInteger == 180
		ifTrue: [ ^ #upside ].

	"Fallback"
	^ #straight
]

{ #category : #initialization }
SmCamera >> release [

	self removeVisibilityChangeHandler.

	super release
]

{ #category : #view }
SmCamera >> removeVisibilityChangeHandler [

	CpBrowserDocument current
		removeEventListener: visibilityChangeHandler
]

{ #category : #actions }
SmCamera >> retakePicture [

	"Retake picture, so change state and start video"

	self removeClass: #captured.

	self attachVideo
]

{ #category : #actions }
SmCamera >> switchCamera [

	"Swich between user facing and environment facing camera.
	Stop and start video explicitly, otherwise it might remain in use."

	self detachVideo.

	facingMode := facingMode == #environment
		ifTrue: [ #user ]
		ifFalse: [ #environment ].

	self classed: #'facing-user' if: facingMode == #user.

	self attachVideo
]

{ #category : #actions }
SmCamera >> takePicture [

	"Take picture from the videa stream.
	Adjust size according to video source and update state."

	| video canvas context width height |

	video := self videoElement.
	canvas := self canvasElement.
	context := canvas getContext: '2d'.

	width := video videoWidth.
	height := video videoHeight.

	canvas width: width.
	canvas height: height.

	context drawImage: video at: 0 @ 0 size: width @ height.

	self addClass: #captured.

	self detachVideo
]

{ #category : #accessing }
SmCamera >> videoElement [

	^ CpBrowserVideoElement domElement: (self firstChildAtSlotNamed: #video)
]

{ #category : #accessing }
SmCamera >> videoStream [

	"Answer the MediaStream (as a Promise) for the current facing mode (i.e. environment or user)"

	^ CpBrowserMediaDevices current getUserMediaWithConstraints: {
		#video -> {
			#facingMode -> {
				#exact -> facingMode
			} asDictionary
		} asDictionary
	} asDictionary
]

{ #category : #'event handling' }
SmCamera >> visibilityChanged [

	"Stop the video if the document is not longer visible"

	CpBrowserDocument current isVisible
		ifTrue: [ self attachVideo ]
		ifFalse: [ self detachVideo ]
]

{ #category : #accessing }
SmCamera >> withVideoStreamDo: aBlock [

	"Perform an operation on the video stream"

	videoStream
		ifNotNil: [ aBlock value: videoStream ]
		ifNil: [
			self videoStream
				then: [ :stream |
					videoStream := stream.
					aBlock value: videoStream ]
				catch: [ :error |
					self traceCr: 'Failed to retrieve video device: ', error printString ] ]
]
