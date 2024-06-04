Class {
	#name : #SmCameraInviteView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmCameraInviteView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		align-items: stretch;
		height: 100%;
	}
	sl-card {
		flex: 1 1 auto;
		display: flex;
	}
	sl-card::part(base) {
		flex: 1 1 auto;
	}'
]

{ #category : #'web resources' }
SmCameraInviteView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-card>
			Camera invite
		</sl-card>
	</div>'
]
