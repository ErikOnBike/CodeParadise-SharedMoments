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
	}
	sl-card::part(body) {
		flex: 1 1 auto;
	}
	#header {
		display: flex;
		align-items: center;
		column-gap: 1em;
	}
	#title slot {
		display: inline-block;
		margin-left: .25em;
	}
	#content {
		display: flex;
		flex-direction: column;
		row-gap: .8em;
	}
	#footer {
		display: flex;
		align-items: center;
		column-gap: 1em;
	}
	sl-icon {
		font-size: 1.6em;
	}'
]

{ #category : #'web resources' }
SmCameraInviteView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-card>
			<div id="header" slot="header">
				<sl-icon name="send"></sl-icon><span id="title"><span>Camera invite for</span><slot name="collection"></slot></span>
			</div>
			<div id="content">
				<sl-input id="name" label="Name"></sl-input>
				<sl-input id="invitee" label="Email address" type="email"></sl-input>
				<sl-input id="token" label="Token" placeholder="<token will be set when invite is sent>" readonly></sl-input>
			</div>
			<div id="footer" slot="footer">
				<sl-button id="invite" variant="primary">Invite</sl-button><div id="sent"><span>This invite was sent </span><sl-relative-time></sl-relative-time></div>
			</div>
		</sl-card>
	</div>'
]

{ #category : #rendering }
SmCameraInviteView >> renderCollection: aString [

	self replaceAllChildrenWith: aString asHtmlElement atSlotNamed: #collection
]
