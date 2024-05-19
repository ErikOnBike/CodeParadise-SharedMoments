Class {
	#name : #CpCaptureMomentWebApplicationScreen,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Capture-View'
}

{ #category : #'web resources' }
CpCaptureMomentWebApplicationScreen class >> globalStyle [

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
CpCaptureMomentWebApplicationScreen class >> style [

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
CpCaptureMomentWebApplicationScreen class >> template [

	<webResource: #html>

	^ '<div id="container">
		<slot name="camera"></slot>
	</div>'
]

{ #category : #initialization }
CpCaptureMomentWebApplicationScreen >> initialize [

	super initialize.

	self appendChild: CpCamera new atSlotNamed: #camera
]
