Class {
	#name : #SmCaptureMomentWebApplicationScreen,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Capture-View'
}

{ #category : #'web resources' }
SmCaptureMomentWebApplicationScreen class >> globalStyle [

	<webResource: #css>

	^ '*, *:before, *:after {
		box-sizing: border-box;
	}
	html, body {
		margin: 0;
		padding: 0;
	}'
]

{ #category : #'web resources' }
SmCaptureMomentWebApplicationScreen class >> style [

	<webResource: #css>

	^ '*, *:before, *:after {
		box-sizing: border-box;
	}
	::slotted([slot="camera"]) {
		position: absolute;
		display: block;
		width: 100vw;
		height: 100vh;
	}'
]

{ #category : #'web resources' }
SmCaptureMomentWebApplicationScreen class >> template [

	<webResource: #html>

	^ '<div id="container">
		<slot name="camera"></slot>
	</div>'
]

{ #category : #initialization }
SmCaptureMomentWebApplicationScreen >> initialize [

	super initialize.

	self appendChild: SmCamera new atSlotNamed: #camera
]
