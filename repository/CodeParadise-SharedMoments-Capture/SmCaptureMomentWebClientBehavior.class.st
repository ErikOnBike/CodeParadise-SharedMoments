Class {
	#name : #SmCaptureMomentWebClientBehavior,
	#superclass : #CpWebClientBehavior,
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #'token handling' }
SmCaptureMomentWebClientBehavior >> addInviteForToken: aString [

	"For now store the invite as an access token"

	self clientEnvironment
		persistentVariableAt: #ACCESS_TOKEN put: aString
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

	CpHtmlElement documentBody
		appendChild: SmCaptureMomentWebApplicationScreen new.

	self handleInvites
]
