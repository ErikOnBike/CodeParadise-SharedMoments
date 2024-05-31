Class {
	#name : #SmDashboardMenuBarView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmDashboardMenuBarView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding-left: 1em;
		padding-right: 1em;
	}
	#slogan {
		font-style: italic;
		text-decoration: underline;
	}
	sl-divider {
		--spacing: 4px;
		height: 1.4em;
	}
	sl-icon-button {
		font-size: 1.4em;
	}'
]

{ #category : #'web resources' }
SmDashboardMenuBarView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="slogan">Shared Moments - Share your moments with your loved ones</div>
		<div><sl-divider vertical></sl-divider><sl-icon-button id="logout" name="box-arrow-right"></sl-icon-button></div>
	</div>'
]

{ #category : #initialization }
SmDashboardMenuBarView >> initializeShadowRoot [

	super initializeShadowRoot.

	self logoutButton
		when: CpClickEvent basicPrimary send: #logout to: self
]

{ #category : #accessing }
SmDashboardMenuBarView >> logout [

	self serverAnnounce: (CpActionRequested id: #logout)
]

{ #category : #accessing }
SmDashboardMenuBarView >> logoutButton [

	^ self shadowedElementWithId: #logout
]
