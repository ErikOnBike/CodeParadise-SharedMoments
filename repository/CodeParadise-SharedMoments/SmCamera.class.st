Class {
	#name : #SmCamera,
	#superclass : #SmModel,
	#instVars : [
		'collection',
		'name'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #'instance creation' }
SmCamera class >> newWithName: aString [

	^ self basicNew
		initializeWithName: aString ;
		yourself
]

{ #category : #private }
SmCamera >> collection: aCollection [

	"Set the collection of the receiver.

	Implementation:
	This is an internal method, do not announce a value changed."

	collection := aCollection
]

{ #category : #actions }
SmCamera >> delete [

	collection ifNil: [ ^ self ].

	collection removeCamera: self
]

{ #category : #initialization }
SmCamera >> initializeWithName: aString [

	self initialize.

	name := aString
]

{ #category : #accessing }
SmCamera >> name [

	^ name
]

{ #category : #'as yet unclassified' }
SmCamera >> nameInitials [

	"Answer max 2 initials for the receiver's name"

	| first letter |

	name ifNil: [ ^ nil ].

	letter := false.
	name do: [ :each |
		each isLetter
			ifTrue: [
				letter ifFalse: [
					first
						ifNotNil: [ ^ String with: first with: each ].
					first := each.
					letter := true ] ]
			ifFalse: [ letter := false ] ].

	^ first ifNotNil: [ String with: first ]
]
