Class {
	#name : #SmLoginView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmLoginView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		height: 100%;
		justify-content: center;
		align-items: center;
	}
	sl-card::part(header) {
		font-size: 1.2em;
		text-align: center;
	}
	#instruction,
	sl-alert[open] {
		margin-bottom: 1.4em;
	}
	sl-input:first-child {
		margin-bottom: 1em;
	}'
]

{ #category : #'web resources' }
SmLoginView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<sl-card>
			<div slot="header">Shared Moments Dashboard</div>
			<div id="instruction">Please login using your email and password</div>
			<sl-alert id="warning" variant="warning">
				<sl-icon slot="icon" name="exclamation-triangle"></sl-icon>
				<div><slot name="warning-message"></slot></div>
			</sl-alert>
			<div id="credentials">
				<sl-input id="email" type="email" label="Email address"><sl-icon slot="prefix" name="at"></sl-icon></sl-input>
				<sl-input id="password" type="password" label="Password" password-toggle><sl-icon slot="prefix" name="shield-lock"></sl-icon></sl-input>
			</div>
			<div slot="footer"><sl-button id="login" variant="primary">Login</sl-button></div>
		</sl-card>
	</div>'
]

{ #category : #accessing }
SmLoginView >> emailInput [

	^ self shadowedElementWithId: #email
]

{ #category : #rendering }
SmLoginView >> hideWarning [

	self warningAlert beNotOpen
]

{ #category : #initialization }
SmLoginView >> initializeShadowRoot [

	super initializeShadowRoot.

	self loginButton
		when: CpClickEvent basicPrimary send: #login to: self
]

{ #category : #'event handling' }
SmLoginView >> login [

	| email password credentials |

	self hideWarning.

	email := self emailInput value.
	password := self passwordInput value.

	(email isEmptyOrNil or: [ password isEmptyOrNil ])
		ifTrue: [
			self showWarning: 'Both email and password need to be entered'.
			^ self ].

	credentials := {
		#email -> email.
		#password -> password
	} asDictionary.

	self serverAnnounce: (CpActionRequested id: #login parameters: credentials)
]

{ #category : #accessing }
SmLoginView >> loginButton [

	^ self shadowedElementWithId: #login
]

{ #category : #accessing }
SmLoginView >> passwordInput [

	^ self shadowedElementWithId: #password
]

{ #category : #rendering }
SmLoginView >> renderFailedLogin [

	self showWarning: 'Failed to login: Invalid credentials provided'
]

{ #category : #rendering }
SmLoginView >> showWarning: aString [

	self replaceAllChildrenWith: aString asHtmlElement atSlotNamed: #'warning-message'.

	self warningAlert beOpen
]

{ #category : #accessing }
SmLoginView >> warningAlert [

	^ self shadowedElementWithId: #warning
]
