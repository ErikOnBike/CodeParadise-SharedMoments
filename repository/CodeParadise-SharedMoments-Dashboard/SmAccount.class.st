Class {
	#name : #SmAccount,
	#superclass : #SmModel,
	#instVars : [
		'name',
		'email',
		'password',
		'collections'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmAccount class >> withCredentials: aDictionary [

	"Login using the specified credentials and evaluate the specified block using the matching account"

	| session |

	session := SmSession withCredentials: aDictionary.

	session inspect.

	^ nil
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

	^ collections value
]

{ #category : #accessing }
SmAccount >> email [

	^ email value
]

{ #category : #accessing }
SmAccount >> email: aString [

	email value: aString
]

{ #category : #initialization }
SmAccount >> initialize [

	super initialize.

	name := SmValueHolder owner: self.
	email := SmValueHolder owner: self.
	collections := SmCollectionHolder type: SmCollection owner: self.

	"Password (actually a hash of the plaintext password) is set explicitly, not using UI"
	"password := nil"
]

{ #category : #initialization }
SmAccount >> initializeWithEmail: aString [

	self initialize.

	email setValue: aString
]

{ #category : #accessing }
SmAccount >> name [

	^ name value
]

{ #category : #accessing }
SmAccount >> name: aString [

	name value: aString
]

{ #category : #accessing }
SmAccount >> password [

	^ password ifNil: [ 'Secret' ]
]

{ #category : #accessing }
SmAccount >> removeCollection: aCollection [

	collections remove: aCollection.
	self valueChanged.

	"Remove link back"
	aCollection account: nil.

	^ aCollection
]