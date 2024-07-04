Class {
	#name : #SmCaptureMomentWebClientBehavior,
	#superclass : #CpWebClientBehavior,
	#instVars : [
		'needsRestart'
	],
	#classVars : [
		'AccessToken'
	],
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #accessing }
SmCaptureMomentWebClientBehavior class >> accessToken [

	^ AccessToken ifNil: [
		AccessToken := CpClientEnvironment current
			variableAt: #ACCESS_TOKEN ]
]

{ #category : #'class initialization' }
SmCaptureMomentWebClientBehavior class >> beLoaded [

	CpBrowserLocation beLoaded.
	CpBrowserSnapshot beLoaded
]

{ #category : #accessing }
SmCaptureMomentWebClientBehavior class >> setAccessToken: aString [

	AccessToken := aString
]

{ #category : #'token handling' }
SmCaptureMomentWebClientBehavior >> addInviteForToken: aString [

	"For now store the invite as an access token"

	self flag: #TODO
]

{ #category : #'token handling' }
SmCaptureMomentWebClientBehavior >> handleAccessToken [

	"Extract access token from URL"

	(CpBrowserDocument current url searchParams get: #accessToken)
		ifNotNil: [ :accessToken |
			| location |
			self setAccessToken: accessToken.
			location := CpBrowserDocument current location.
			location search: (location search first: (location search indexOf: $&) - 1).
			needsRestart := true ]
		ifNil: [ self setAccessToken: self class accessToken ]
]

{ #category : #'token handling' }
SmCaptureMomentWebClientBehavior >> handleInvites [

	"Handle any invites provided in URL"

	CpBrowserDocument current url searchParams forEach: [ :value :key |
		key = #inviteToken
			ifTrue: [ self addInviteForToken: value ] ]
]

{ #category : #initialization }
SmCaptureMomentWebClientBehavior >> initialize [

	super initialize.

	needsRestart := false.

	self
		handleAccessToken ;
		handleInvites.

	needsRestart
		ifTrue: [ ^ self ].

	CpHtmlElement documentBody
		appendChild: SmCaptureMomentWebApplicationScreen new
]

{ #category : #actions }
SmCaptureMomentWebClientBehavior >> saveSnapshot [

	CpBrowserSnapshot saveSnapshot
]

{ #category : #'token handling' }
SmCaptureMomentWebClientBehavior >> setAccessToken: aString [

	self clientEnvironment
		variableAt: #ACCESS_TOKEN put: aString.

	self class setAccessToken: aString
]
