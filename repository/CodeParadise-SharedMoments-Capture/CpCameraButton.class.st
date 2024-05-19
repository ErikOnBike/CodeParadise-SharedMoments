Class {
	#name : #CpCameraButton,
	#superclass : #CpTemplateComponent,
	#instVars : [
		'audio'
	],
	#category : #'CodeParadise-SharedMoments-Capture-View'
}

{ #category : #resources }
CpCameraButton class >> shutterSoundDataURL [

	^ 'data:audio/mpeg;base64,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0Kh0SgIGolGHiyjwKqPMOxLxL4dLLUDXWd+CrjsiWtIQVUDXqDpVpfhKiQDYIUyifkpAYVQ+YoVWFWlhalVXTEsIdqxqsjhwCSYGlA08S/hr53UeLFQC6Ih52Ct1bv//lRqhfAKRJRPkK2+en5GgK5mRoCn/FfP4SrmnKcVmv91ZP6zKrG+jI5fmUqOVH1Y0uZDK1Mv/2N9Uf/dZv+pU6P/a6kcqQRnhgwzAAA1KCIBBmlUD+BugEowcIykCQdPYaAOAn2+Pd6/ERZD3SU83/Vt50kWI4+LP9YCa5ezqK/yYyWJqTEFNRaoAAACSORJtoGaPE6jmMFCEdQEnFgEwKErnYCh1qKcjI0P5WnK+Q/9ujnetbuR+23//4mBoGh4LOAAC66pUG8UIR0Uldz4Sj6yIKnDAxra/Vtv/+5RktwACzxTNYewxoDsiWe08JnIJLZECB4RNwOQEIOTymEC2n/X/6da1b/v9v/66Pp//9dW///m//r///+jqUTMcBScABJiAAANgRgJHgnoCpa1d1mC7n1mZ3p/ZEs6pZE/////////9jKiP1R2VLOxlRFJ6Kv/+weCIREBdgBABx0iIaXida3GLOrKqJ3nBeh/4OfqGY9MT9kSyM0wkZGRGn5F//0RMJGmERDQjsIiGvfYSVjFUjt/9ymRSOxlZ0W+5URf0T/6WcqJ2dkVU/92MUwUGIFFDAyCp6kxBTUUzLjEwMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/+5Rk1oCBvgc96ekxgDpMV5k9ghZHSYLXpgCxYXQxV0WAijmqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqo='
]

{ #category : #'web resources' }
CpCameraButton class >> style [

	<webResource: #css>

	^ '*, *:before, *:after {
		box-sizing: border-box;
	}
	#container {
		aspect-ratio: 1/1;
	}
	#ring {
		position: relative;
		width: 100%;
		height: 100%;
		border-radius: 50%;
		border: 6px white solid;
	}
	#circle {
		position: absolute;
		width: 80%;
		height: 80%;
		top: 10%;
		left: 10%;
		border-radius: 50%;
		background-color: red;
	}'
]

{ #category : #'web resources' }
CpCameraButton class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="ring">
			<div id="circle"></div>
		</div>
	</div>'
]

{ #category : #'event handling' }
CpCameraButton >> clicked [

	"Make shutter sound"

	audio play
]

{ #category : #initialization }
CpCameraButton >> initialize [

	super initialize.

	"Prepare audio element to play shutter sound"
	audio := CpBrowserAudioElement url: self class shutterSoundDataURL.

	self when: CpClickEvent primary only send: #clicked to: self
]