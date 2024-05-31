Class {
	#name : #SmAccount,
	#superclass : #SmModel,
	#instVars : [
		'email',
		'collections'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #accessing }
SmAccount class >> forCredentials: aDictionary [

	"Answer an instance of the receiver with the specified credentials.
	If such an instance does not exist, answer nil."

	| email instance |

	email := aDictionary at: #email ifAbsent: [ ^ nil ].

	email = 'nobody'
		ifFalse: [ ^ nil ].

	instance := self basicNew
		initializeWithEmail: email ;
		yourself.

	instance
		addCollection: (SmCollection newWithName: 'ESUG 2024 - Public') ;
		addCollection: (SmCollection newWithName: 'ESUG 2024 - Private').

	^ instance
]

{ #category : #accessing }
SmAccount >> addCollection [

	"Add a new (empty) Collection to the receiver"

	self addCollection: SmCollection new
]

{ #category : #accessing }
SmAccount >> addCollection: aCollection [

	collections add: aCollection.
	self valueChanged.

	"Add link back"
	aCollection account: self.

	^ aCollection
]

{ #category : #accessing }
SmAccount >> collections [

	^ collections
]

{ #category : #accessing }
SmAccount >> email [

	^ email
]

{ #category : #initialization }
SmAccount >> initialize [

	super initialize.
	
	collections := OrderedCollection new
]

{ #category : #initialization }
SmAccount >> initializeWithEmail: aString [

	self initialize.

	email := aString
]

{ #category : #accessing }
SmAccount >> removeCollection: aCollection [

	collections remove: aCollection.
	self valueChanged.

	"Remove link back"
	aCollection account: nil.

	^ aCollection
]
