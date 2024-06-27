Class {
	#name : #SmValueHolder,
	#superclass : #Object,
	#instVars : [
		'type',
		'owner',
		'value'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Support'
}

{ #category : #'instance creation' }
SmValueHolder class >> new [

	self errorNewReplacedBy: #owner:
]

{ #category : #accessing }
SmValueHolder class >> owner: aModel [

	"Answer a new instance of the receiver which belongs to the specified owner (a Model)"

	^ self type: nil owner: aModel
]

{ #category : #accessing }
SmValueHolder class >> owner: aModel value: anObject [

	"Answer a new instance of the receiver which belongs to the specified owner (a Model)
	and has the specified initial value"

	^ self type: nil owner: aModel value: anObject
]

{ #category : #accessing }
SmValueHolder class >> type: aClass owner: aModel [

	"Answer a new instance of the receiver for the specified type, which belongs to the specified owner (a Model)"

	^ self basicNew
		initializeWithType: aClass owner: aModel ;
		yourself
]

{ #category : #accessing }
SmValueHolder class >> type: aClass owner: aModel value: anObject [

	"Answer a new instance of the receiver for the specified type, which belongs to the specified owner (a Model)
	and has the specified initial value"

	^ self basicNew
		initializeWithType: aClass owner: aModel value: anObject ;
		yourself
]

{ #category : #testing }
SmValueHolder >> equals: anObject [

	"Answer whether the receiver's value equals the specified value"

	^ value = anObject
]

{ #category : #testing }
SmValueHolder >> hasType [

	^ type isNotNil
]

{ #category : #initialization }
SmValueHolder >> initializeWithType: aClass owner: aModel [

	self initialize.

	type := aClass.
	owner := aModel
]

{ #category : #initialization }
SmValueHolder >> initializeWithType: aClass owner: aModel value: anObject [

	self initialize.

	type := aClass.
	owner := aModel.

	(type isNotNil and: [ (anObject isKindOf: type) not ])
		ifTrue: [ self error: 'Instantiating object with an unexpected type' ].

	value := anObject
]

{ #category : #private }
SmValueHolder >> setValue: anObject [

	"Set the receiver to the specified value without announcing a change"

	(type isNotNil and: [ (anObject isKindOf: type) not ])
		ifTrue: [ self error: 'Setting value with an unexpected type' ].

	value := anObject
]

{ #category : #accessing }
SmValueHolder >> type [

	"Answer the Class representing the receiver's required content"

	^ type
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

	(type isNotNil and: [ (anObject isKindOf: type) not ])
		ifTrue: [ self error: 'Setting value with an unexpected type' ].

	value = anObject
		ifTrue: [ ^ value ].

	value := anObject.
	owner valueChanged.

	^ value
]
