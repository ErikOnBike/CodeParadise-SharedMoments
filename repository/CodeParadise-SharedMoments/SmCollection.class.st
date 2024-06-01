Class {
	#name : #SmCollection,
	#superclass : #SmModel,
	#instVars : [
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

	account setValue: anAccount
]

{ #category : #accessing }
SmCollection >> addCamera [

	^ self addCamera: SmCamera new
]

{ #category : #accessing }
SmCollection >> addCamera: aCamera [

	^ cameras add: aCamera
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
SmCollection >> cameras [

	^ cameras value
]

{ #category : #initialization }
SmCollection >> initialize [

	super initialize.

	account := SmValueHolder owner: self.
	name := SmValueHolder owner: self.
	cameras := SmCollectionHolder owner: self.
	photoFrames := SmCollectionHolder owner: self.
	photoCount := SmValueHolder owner: self value: 0
]

{ #category : #initialization }
SmCollection >> initializeWithName: aString [

	self initialize.

	name setValue: aString
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

{ #category : #accessing }
SmCollection >> removeCamera: aCamera [

	^ cameras remove: aCamera
]

{ #category : #accessing }
SmCollection >> removePhotoFrame: aPhotoFrame [

	^ photoFrames remove: aPhotoFrame
]
