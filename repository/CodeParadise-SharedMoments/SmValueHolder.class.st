Class {
	#name : #SmValueHolder,
	#superclass : #Object,
	#instVars : [
		'owner',
		'value'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #'instance creation' }
SmValueHolder class >> new [

	self errorNewReplacedBy: #owner:
]

{ #category : #accessing }
SmValueHolder class >> owner: aModel [

	"Answer a new instance of the receiver which belongs to the specified owner (a Model)"

	^ self basicNew
		initializeWithOwner: aModel ;
		yourself
]

{ #category : #accessing }
SmValueHolder class >> owner: aModel value: anObject [

	"Answer a new instance of the receiver which belongs to the specified owner (a Model)
	and has the specified initial value"

	^ self basicNew
		initializeWithOwner: aModel value: anObject ;
		yourself
]

{ #category : #testing }
SmValueHolder >> equals: anObject [

	"Answer whether the receiver's value equals the specified value"

	^ value = anObject
]

{ #category : #initialization }
SmValueHolder >> initializeWithOwner: aModel [

	self initialize.

	owner := aModel
]

{ #category : #initialization }
SmValueHolder >> initializeWithOwner: aModel value: anObject [

	self initialize.

	owner := aModel.
	value := anObject
]

{ #category : #private }
SmValueHolder >> setValue: anObject [

	"Set the receiver to the specified value without announcing a change"

	value := anObject
]

{ #category : #accessing }
SmValueHolder >> value [

	"Answer the value of the receiver"

	^ value
]

{ #category : #accessing }
SmValueHolder >> value: anObject [

	"Update the value of the receiver and announce a value change.
	If the provided value equals the existing value, no announcement
	is made."

	value = anObject
		ifTrue: [ ^ value ].

	value := anObject.
	owner valueChanged.

	^ value
]
