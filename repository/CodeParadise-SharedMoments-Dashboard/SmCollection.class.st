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

{ #category : #'as yet unclassified' }
SmCollection class >> forAccount: anAccount [

	| collection |

	collection := self newForAccount: anAccount.

	"Store the collection and update its internals"
	collection fromDictionary: (SmAccount
		post: '/:id/collections'
		withParameters: {  #id -> anAccount id } asDictionary
		body: collection asDictionary).

	^ collection
]

{ #category : #'instance creation' }
SmCollection class >> newForAccount: anAccount [

	^ self basicNew
		initializeWithAccount: anAccount ;
		yourself
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

	name := SmValueHolder owner: self value: ''.
	cameras := SmCollectionHolder type: SmCamera owner: self.
	photoFrames := SmCollectionHolder type: SmPhotoFrame owner: self.
	photoCount := SmValueHolder owner: self value: 0.
	invites := SmCollectionHolder owner: self.

	"Account is not user settable"
	"account := nil"
]

{ #category : #initialization }
SmCollection >> initializeWithAccount: anAccount [

	self initialize.

	account := anAccount
]

{ #category : #accessing }
SmCollection >> invites [

	^ invites value
]

{ #category : #accessing }
SmCollection >> modelInstVarNames [

	^ #(#name)
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
