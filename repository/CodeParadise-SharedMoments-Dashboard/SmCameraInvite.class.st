Class {
	#name : #SmCameraInvite,
	#superclass : #SmModel,
	#instVars : [
		'collection',
		'name',
		'email',
		'token',
		'sentAt',
		'acceptedAt'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #'instance creation' }
SmCameraInvite class >> forCollection: aCollection [

	| cameraInvite |

	cameraInvite := self newForCollection: aCollection.

	"Store the camera invite and update its internals"
	cameraInvite fromDictionary: (SmCollection
		post: '/:id/camera-invites'
		withParameters: {  #id -> aCollection id } asDictionary
		body: cameraInvite asDictionary).

	^ cameraInvite
]

{ #category : #'instance creation' }
SmCameraInvite class >> newForCollection: aCollection [

	^ self basicNew
		initializeWithCollection: aCollection ;
		yourself
]

{ #category : #accessing }
SmCameraInvite >> collection [

	^ collection
]

{ #category : #accessing }
SmCameraInvite >> email [

	^ email value
]

{ #category : #accessing }
SmCameraInvite >> email: aString [

	email value: aString
]

{ #category : #testing }
SmCameraInvite >> hasInvitee [

	^ self email isEmptyOrNil not
]

{ #category : #presenter }
SmCameraInvite >> iconPresenterClass [

	<serverEnvironment>

	^ SmIconCameraInvitePresenter
]

{ #category : #initialization }
SmCameraInvite >> initialize [

	super initialize.

	collection := SmValueHolder owner: self.
	email := SmValueHolder owner: self value: ''.
	name := SmValueHolder owner: self value: ''.
	token := SmValueHolder owner: self.
	
	"Collection, sendAt, acceptedAt and token are not user settable"
	"collection := nil."
	"sendAt := nil."
	"acceptedAt := nil."

]

{ #category : #initialization }
SmCameraInvite >> initializeWithCollection: aCollection [

	self initialize.

	collection := aCollection
]

{ #category : #testing }
SmCameraInvite >> isAccepted [

	^ acceptedAt isNotNil
]

{ #category : #testing }
SmCameraInvite >> isSent [

	^ sentAt isNotNil
]

{ #category : #testing }
SmCameraInvite >> isTokenValid [

	"Answer whether the receiver's token is still valid"

	^ SmModel isFuture: sentAt + SmModel tokenPeriod
]

{ #category : #accessing }
SmCameraInvite >> name [

	^ name value
]

{ #category : #accessing }
SmCameraInvite >> name: aString [

	name value: aString
]

{ #category : #accessing }
SmCameraInvite >> privateInstVarNames [

	^ #(#collection)
]

{ #category : #accessing }
SmCameraInvite >> status [

	"Answer the status of the receiver.
		#empty    - no invitee is set yet
		#unsert   - has invitee but not sent yet
		#sent     - has invitee and is sent
		#expired  - has invitee and is sent and is expired
		#accepted - has invitee and is sent and is accepted (by one or more users)"

	^ self isAccepted
		ifTrue: [ #accepted ]
		ifFalse: [
			self isSent
				ifTrue: [
					self isTokenValid
						ifTrue: [ #sent ]
						ifFalse: [ #expired ] ]
				ifFalse: [
					self hasInvitee
						ifTrue: [ #unsent ]
						ifFalse: [ #empty ] ] ]
]

{ #category : #accessing }
SmCameraInvite >> token [

	^ token value
]

{ #category : #accessing }
SmCameraInvite >> token: aString [

	token value: aString
]
