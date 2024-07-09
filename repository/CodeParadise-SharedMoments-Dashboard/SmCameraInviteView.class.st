Class {
	#name : #SmCameraInviteView,
	#superclass : #CpFieldsView,
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
				<div id="name"><slot name="name"></slot></div>
				<div id="invitee"><slot name="email"></slot></div>
				<div id="token"><slot name="token"></slot></div>
			</div>
			<div id="footer" slot="footer">
				<sl-button id="invite" variant="primary">Invite</sl-button><div id="sent"><!--<span>This invite was sent </span><sl-relative-time></sl-relative-time>--></div>
			</div>
		</sl-card>
	</div>'
]

{ #category : #rendering }
SmCameraInviteView >> createEmailElement [

	"Create the receiver's email input element and hook up event listeners"

	(self appendChild: SlInput new atSlotNamed: #email)
		appendChild: ((SlIcon named: #at)
			slot: #prefix ;
			yourself) ;
		label: 'Email address' ;
		placeholder: '<email>' ;
		type: #email ;
		attachAsField: #email to: self
]

{ #category : #rendering }
SmCameraInviteView >> createNameElement [

	"Create the receiver's name input element and hook up event listeners"

	(self appendChild: SlInput new atSlotNamed: #name)
		label: 'Name' ;
		placeholder: '<name>' ;
		attachAsField: #name to: self
]

{ #category : #rendering }
SmCameraInviteView >> createTokenElement [

	"Create the receiver's name input element and hook up event listeners"

	(self appendChild: SlInput new atSlotNamed: #token)
		label: 'Token' ;
		beReadonly ;
		placeholder: '<token will be set when invite is sent>' ;
		attachAsField: #token to: self
]

{ #category : #initialization }
SmCameraInviteView >> initialize [

	super initialize.

	self
		createNameElement ;
		createEmailElement ;
		createTokenElement
]

{ #category : #rendering }
SmCameraInviteView >> renderCollection: aString [

	self replaceAllChildrenWith: aString asHtmlElement atSlotNamed: #collection
]

{ #category : #rendering }
SmCameraInviteView >> renderName: nameString email: emailString [

	self
		render: nameString toInputAtSlotNamed: #name ;
		render: emailString toInputAtSlotNamed: #email
]

{ #category : #rendering }
SmCameraInviteView >> renderToken: aString [

	self render: aString toInputAtSlotNamed: #token
]
