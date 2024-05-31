Class {
	#name : #SmCollection,
	#superclass : #SmModel,
	#instVars : [
		'createdAt',
		'account',
		'name',
		'cameras',
		'photoFrames',
		'photoCount'
	],
	#category : #'CodeParadise-SharedMoments-Model'
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

	account := anAccount
]

{ #category : #accessing }
SmCollection >> addCamera [

	^ self addCamera: SmCamera new
]

{ #category : #accessing }
SmCollection >> addCamera: aCamera [

	cameras add: aCamera.
	self valueChanged.

	"Set back link"
	aCamera collection: self.

	^ aCamera
]

{ #category : #accessing }
SmCollection >> addPhotoFrame [

	^ self addPhotoFrame: SmPhotoFrame new
]

{ #category : #accessing }
SmCollection >> addPhotoFrame: aPhotoFrame [

	photoFrames add: aPhotoFrame.
	self valueChanged.

	"Set back link"
	aPhotoFrame collection: self.

	^ aPhotoFrame
]

{ #category : #accessing }
SmCollection >> cameras [

	^ cameras
]

{ #category : #accessing }
SmCollection >> createdAt [

	^ createdAt
]

{ #category : #action }
SmCollection >> delete [

	account ifNil: [ ^ self ].

	account removeCollection: self
]

{ #category : #initialization }
SmCollection >> initialize [

	super initialize.

	createdAt := SmModel timestampNow.
	cameras := OrderedCollection new.
	photoFrames := OrderedCollection new.
	photoCount := 0
]

{ #category : #initialization }
SmCollection >> initializeWithName: aString [

	self initialize.

	name := aString
]

{ #category : #accessing }
SmCollection >> name [

	^ name
]

{ #category : #accessing }
SmCollection >> name: aString [

	name := aString.

	self valueChanged
]

{ #category : #accessing }
SmCollection >> photoCount [

	^ photoCount
]

{ #category : #accessing }
SmCollection >> photoFrames [

	^ photoFrames
]

{ #category : #accessing }
SmCollection >> removeCamera: aCamera [

	cameras remove: aCamera.
	self valueChanged.

	"Remove back link"
	aCamera collection: nil.

	^ aCamera
]

{ #category : #accessing }
SmCollection >> removePhotoFrame: aPhotoFrame [

	photoFrames remove: aPhotoFrame.
	self valueChanged.

	"Remove back link"
	aPhotoFrame collection: nil.

	^ aPhotoFrame
]
