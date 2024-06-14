Class {
	#name : #SmCamera,
	#superclass : #SmModel,
	#instVars : [
		'collections',
		'name'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #'instance creation' }
SmCamera class >> newWithName: aString [

	^ self basicNew
		initializeWithName: aString ;
		yourself
]

{ #category : #presenter }
SmCamera >> iconPresenterClass [

	<serverEnvironment>

	^ SmIconCameraPresenter
]

{ #category : #initialization }
SmCamera >> initialize [

	"Initialize the receiver.

	Implementation:
	The instance variable collection is only used as a reference
	back to the SmCollection the receiver lives in. It should
	therefore not be put in a ValueHolder."

	super initialize.

	name := SmValueHolder owner: self.

	"Collections are not user settable"
	collections := Set new
]

{ #category : #initialization }
SmCamera >> initializeWithName: aString [

	self initialize.

	name setValue: aString
]

{ #category : #accessing }
SmCamera >> name [

	^ name value
]

{ #category : #accessing }
SmCamera >> nameInitials [

	"Answer max 2 initials for the receiver's name"

	| first letter |

	self name ifNil: [ ^ nil ].

	letter := false.
	self name do: [ :each |
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
