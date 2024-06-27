Class {
	#name : #SmPhotoFrame,
	#superclass : #SmModel,
	#instVars : [
		'collection',
		'name'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #presenter }
SmPhotoFrame >> iconPresenterClass [

	<serverEnvironment>

	^ SmIconPhotoFramePresenter
]

{ #category : #initialization }
SmPhotoFrame >> initialize [

	"Initialize the receiver.

	Implementation:
	The instance variable collection is only used as a reference
	back to the SmCollection the receiver lives in. It should
	therefore not be put in a ValueHolder."

	super initialize.

	name := SmValueHolder owner: self.

	"Collection is not user settable"
	"collection := nil"
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

{ #category : #accessing }
SmPhotoFrame >> privateInstVarNames [

	^ #(#collection)
]
