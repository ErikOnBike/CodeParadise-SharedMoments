Class {
	#name : #SmCollectionHolder,
	#superclass : #SmValueHolder,
	#instVars : [
		'uniqueElements'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Support'
}

{ #category : #'instance creation' }
SmCollectionHolder class >> owner: aModel [

	"Answer an instance of the receiver, by default in an OrderedCollection with unique instances"

	^ self
		type: nil
		owner: aModel
		collection: OrderedCollection new
		unique: true
]

{ #category : #'instance creation' }
SmCollectionHolder class >> owner: aModel collection: aCollection [

	"Answer an instance of the receiver, by default assume unique instances in the collection"

	^ self
		type: nil
		owner: aModel
		collection: aCollection
		unique: true
]

{ #category : #'instance creation' }
SmCollectionHolder class >> owner: aModel collection: aCollection unique: aBoolean [

	"Answer a new instance of the receiver for the specified owner (a Model).
	The specified collection is used to collect the instances.
	If specified, only unique instances will be added to the collection.
	In case a collection is specified which only accepts unique
	instances (like Set), and unique is specified as `false`, then it
	will still only add unique instances. The holder will however
	request the owner model to announce a change in such a situation."

	^ self
		type: nil
		owner: aModel
		collection: aCollection
		unique: aBoolean
]

{ #category : #'instance creation' }
SmCollectionHolder class >> type: aClass owner: aModel [

	^ self type: aClass owner: aModel collection: OrderedCollection new unique: true
]

{ #category : #'instance creation' }
SmCollectionHolder class >> type: aClass owner: aModel collection: aCollection unique: aBoolean [

	"Answer a new instance of the receiver for the specified owner (a Model).
	The specified collection is used to collect the instances.
	The collection only allows objects of the specified type (if set).
	If specified, only unique instances will be added to the collection.
	In case a collection is specified which only accepts unique
	instances (like Set), and unique is specified as `false`, then it
	will still only add unique instances. The holder will however
	request the owner model to announce a change in such a situation."

	^ self basicNew
		initializeWithType: aClass owner: aModel collection: aCollection unique: aBoolean ;
		yourself
]

{ #category : #adding }
SmCollectionHolder >> add: anObject [

	"Add the specified Object to the receiver, announce a change and answer it.
	If the Object is already present in the receiver and the receiver only
	accepts unique instances, it will not be added again and no change will be
	announced."

	(type isNotNil and: [ (anObject isKindOf: type) not ])
		ifTrue: [ self error: 'Adding instance of an unexpected type' ].

	(uniqueElements and: [ value includes: anObject ])
		ifTrue: [ ^ anObject ].

	value add: anObject.
	owner valueChanged.

	^ anObject
]

{ #category : #enumerating }
SmCollectionHolder >> collect: aBlock [

	"Answer a collection of instances of the receiver mapped using the specified Block"

	^ value collect: aBlock
]

{ #category : #enumerating }
SmCollectionHolder >> collect: aBlock as: aCollectionClass [

	"Answer a collection of instances of the receiver mapped using the specified Block"

	^ value collect: aBlock as: aCollectionClass
]

{ #category : #initialization }
SmCollectionHolder >> initialize [

	super initialize.

	"By default elements in the receiver should be unique"
	uniqueElements := true
]

{ #category : #initialization }
SmCollectionHolder >> initializeWithType: aClass owner: aModel collection: aCollection unique: aBoolean [

	"Initialize the receiver"

	"Initialize without a type, because type is used for elements not the collection itself"
	self initializeWithType: nil owner: aModel value: aCollection.

	"Set the (element) type now the initial value has been set"
	type := aClass.
	uniqueElements := aBoolean
]

{ #category : #adding }
SmCollectionHolder >> remove: anObject [

	"Remove the specified Object to the receiver, announce a change and answer it.
	It is assumed the receiver's collection can remove elements."

	(type isNotNil and: [ (anObject isKindOf: type) not ])
		ifFalse: [ self error: 'Removing instance of an unexpected type' ].

	(value includes: anObject)
		ifFalse: [ ^ anObject ].

	value remove: anObject.
	owner valueChanged.

	^ anObject
]

{ #category : #enumerating }
SmCollectionHolder >> select: aBlock [

	"Answer a collection of instances of the receiver which evaluate to true when using the specified Block"

	^ value select: aBlock
]

{ #category : #accessing }
SmCollectionHolder >> setCollection: aCollection [

	"If the receiver does not contain the same elements as in the specified Collection,
	update the collection and signal a value change."

	(type isNotNil and: [ (aCollection allSatisfy: [ :each | each isKindOf: type ]) not ])
		ifTrue: [ self error: 'Setting collection with an unexpected element type' ].

	"Test two ways because of unique values and subcollections"
	((aCollection allSatisfy: [ :each | value includes: each ]) and: [ value allSatisfy: [ :each | aCollection includes: each ] ])
		ifTrue: [ ^ self ].

	value := aCollection.
	owner valueChanged
]
