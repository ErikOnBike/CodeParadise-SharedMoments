Class {
	#name : #SmPhotoFrame,
	#superclass : #SmModel,
	#instVars : [
		'name'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #initialization }
SmPhotoFrame >> initialize [

	"Initialize the receiver.

	Implementation:
	The instance variable collection is only used as a reference
	back to the SmCollection the receiver lives in. It should
	therefore not be put in a ValueHolder."

	super initialize.

	name := SmValueHolder owner: self
]

{ #category : #initialization }
SmPhotoFrame >> initializeWithName: aString [

	self initialize.

	name setValue: aString
]

{ #category : #accessing }
SmPhotoFrame >> name [

	^ name value
]
