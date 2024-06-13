Class {
	#name : #SmCollection,
	#superclass : #SmModel,
	#instVars : [
		'account',
		'name',
		'cameras',
		'photoFrames',
		'photoCount',
		'invites'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #'instance creation' }
SmCollection class >> newWithName: aString [

	^ self basicNew
		initializeWithName: aString ;
		yourself
]

{ #category : #private }
SmCollection >> account: anAccount [

	"Set the account of the receiver.

	Implementation:
	This is an internal method, do not announce a value changed."

	account setValue: anAccount
]

{ #category : #accessing }
SmCollection >> addCameraInvite [

	^ invites add: (SmCameraInvite forCollection: self)
]

{ #category : #accessing }
SmCollection >> addPhotoFrame [

	^ self addPhotoFrame: SmPhotoFrame new
]

{ #category : #accessing }
SmCollection >> addPhotoFrame: aPhotoFrame [

	^ photoFrames add: aPhotoFrame
]

{ #category : #accessing }
SmCollection >> cameraInvites [

	^ self invites select: [ :each | each class = SmCameraInvite ]
]

{ #category : #accessing }
SmCollection >> cameras [

	^ cameras value
]

{ #category : #accessing }
SmCollection >> camerasAndInvites [

	"Answer a collection of cameras and invites for cameras (in that order)"

	^ self cameras, self cameraInvites
]

{ #category : #initialization }
SmCollection >> initialize [

	super initialize.

	account := SmValueHolder type: SmAccount owner: self.
	name := SmValueHolder owner: self.
	cameras := SmCollectionHolder type: SmCamera owner: self.
	photoFrames := SmCollectionHolder type: SmPhotoFrame owner: self.
	photoCount := SmValueHolder owner: self value: 0.
	invites := SmCollectionHolder owner: self
]

{ #category : #initialization }
SmCollection >> initializeWithName: aString [

	self initialize.

	name setValue: aString
]

{ #category : #accessing }
SmCollection >> invites [

	^ invites value
]

{ #category : #accessing }
SmCollection >> name [

	^ name value
]

{ #category : #accessing }
SmCollection >> name: aString [

	name value: aString
]

{ #category : #accessing }
SmCollection >> photoCount [

	^ photoCount value
]

{ #category : #accessing }
SmCollection >> photoFrames [

	^ photoFrames value
]
