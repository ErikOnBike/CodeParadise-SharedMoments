Class {
	#name : #SmPhotoFrame,
	#superclass : #SmModel,
	#instVars : [
		'collection',
		'name'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #accessing }
SmPhotoFrame >> collection: aCollection [

	"Set the collection of the receiver.

	Implementation:
	This is an internal method, do not announce a value changed."

	collection := aCollection
]

{ #category : #actions }
SmPhotoFrame >> delete [

	collection ifNil: [ ^ self ].

	collection removePhotoFrame: self
]

{ #category : #initialization }
SmPhotoFrame >> initializeWithName: aString [

	self initialize.

	name := aString
]

{ #category : #accessing }
SmPhotoFrame >> name [

	^ name
]
