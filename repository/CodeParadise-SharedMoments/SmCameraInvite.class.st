Class {
	#name : #SmCameraInvite,
	#superclass : #SmModel,
	#instVars : [
		'collection',
		'invitee',
		'name',
		'token',
		'sentAt',
		'acceptCount'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #'instance creation' }
SmCameraInvite class >> forCollection: aCollection [

	^ self basicNew
		initializeWithCollection: aCollection ;
		yourself
]

{ #category : #accessing }
SmCameraInvite >> acceptCount [

	^ acceptCount
]

{ #category : #accessing }
SmCameraInvite >> collection [

	^ collection
]

{ #category : #testing }
SmCameraInvite >> hasInvitee [

	^ self invitee isEmptyOrNil not
]

{ #category : #initialization }
SmCameraInvite >> initialize [

	super initialize.

	collection := SmValueHolder owner: self.
	invitee := SmValueHolder owner: self.
	name := SmValueHolder owner: self.

	"Collection, sendAt, acceptCount and token are not user settable"
	"collection := nil."
	"sendAt := nil."
	acceptCount := 0.
	token := SmModel randomToken
]

{ #category : #initialization }
SmCameraInvite >> initializeWithCollection: aCollection [

	self initialize.

	collection := aCollection
]

{ #category : #accessing }
SmCameraInvite >> invitee [

	^ invitee value
]

{ #category : #accessing }
SmCameraInvite >> invitee: aString [

	invitee value: aString
]

{ #category : #testing }
SmCameraInvite >> isAccepted [

	^ acceptCount > 0
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
