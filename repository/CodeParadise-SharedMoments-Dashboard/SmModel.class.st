Class {
	#name : #SmModel,
	#superclass : #CpBaseModel,
	#instVars : [
		'id',
		'createdAt',
		'updatedAt',
		'deletedAt'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #'instance creation' }
SmModel class >> fromDictionary: aDictionary [

	"Answer an instance of the receiver using the specified Dictionary for content"

	^ self new
		fromDictionary: aDictionary ;
		yourself
]

{ #category : #API }
SmModel class >> get: aString withParameters: aDictionary [

	"Perform GET operation on REST API"

	| path client |

	path := (CpNodeJSRestPathPattern fromString: aString)
		pathUsingParameters: aDictionary.

	client := ZnClient new
		forJsonREST ;
		get: path.

	client isSuccess
		ifTrue: [ ^ client contents ]
		ifFalse: [ self error: 'Failed to read data from REST API' ]
]

{ #category : #support }
SmModel class >> isFuture: anInteger [

	"Answer whether the specified timestamp is in the future"

	^ self timestampNow < anInteger
]

{ #category : #API }
SmModel class >> post: aString body: anObject [

	"Perform POST operation on REST API"

	^ self
		post: aString
		withParameters: Dictionary new
		body: anObject
]

{ #category : #API }
SmModel class >> post: aString withParameters: aDictionary body: anObject [

	"Perform POST operation on REST API"

	| path client |

	path := (CpNodeJSRestPathPattern fromString: aString)
		pathUsingParameters: aDictionary.

	client := ZnClient new
		forJsonREST ;
		post: path contents: anObject asDictionary.

	client isSuccess
		ifTrue: [ ^ client contents ]
		ifFalse: [ self error: 'Failed to write data to REST API' ]
]

{ #category : #accessing }
SmModel class >> removalPeriod [

	"Answer the number of seconds after deletion that a model will be removed"

	^ 259200 "3 days = 60 * 60 * 24 * 3"
]

{ #category : #support }
SmModel class >> timestampNow [

	"Answer the current timestamp as seconds since Unix epoch (midnight Jan 1, 1970, UTC).

	Implementation:
	Since currently the tiny image for CodeParadise does not support any Date and Time classes,
	use a simple Unix timestamp. This value can be retrieved in both environments. It allows
	easy comparison and storage."

	(Smalltalk classNamed: #DateAndTime)
		ifNotNil: [ :dateAndTimeClass | ^ dateAndTimeClass now asUnixTime ].

	(Smalltalk classNamed: #CpJavaScriptClass)
		ifNotNil: [ :jsClass | ^ ((jsClass forName: #Date) apply: #now) // 1000 ].

	self error: 'No Data or DateAndTime class available in the current environment'
]

{ #category : #support }
SmModel class >> timestampStringFor: anInteger [

	"Answer the specified timestamp (in seconds since Unix epoch) as an ISO-8601 string.

	Implementation:
	Since currently the tiny image for CodeParadise does not support any Date and Time classes,
	use a different implementation per environment."

	(Smalltalk classNamed: #DateAndTime)
		ifNotNil: [ :dateAndTimeClass | ^ (dateAndTimeClass fromUnixTime: anInteger) printString ].

	(Smalltalk classNamed: #CpJavaScriptClass)
		ifNotNil: [ :jsClass | ^ ((jsClass forName: #Date) newInstanceWithArguments: { anInteger * 1000 }) apply: #toISOString ].

	self error: 'No Data or DateAndTime class available in the current environment'
]

{ #category : #accessing }
SmModel class >> tokenPeriod [

	"Answer the number of seconds after sending that a token is valid"

	^ 259200 "3 days = 60 * 60 * 24 * 3"
]

{ #category : #converting }
SmModel >> asDictionary [

	"Answer a representation of the receiver as a Dictionary"

	| dictionary |

	dictionary := Dictionary new.

	self publicInstVarNames do: [ :each |
		dictionary at: each put: (self instVarNamed: each) ].

	^ dictionary
]

{ #category : #accessing }
SmModel >> createdAt [

	^ createdAt
]

{ #category : #actions }
SmModel >> delete [

	"Delete the receiver by setting its deletedAt timestamp"

	deletedAt ifNotNil: [ ^ self ].

	deletedAt := SmModel timestampNow.

	self valueChanged
]

{ #category : #accessing }
SmModel >> deletedAt [

	^ deletedAt
]

{ #category : #converting }
SmModel >> fromDictionary: aDictionary [

	"Update the receiver with the specified Dictionary"

	aDictionary keysAndValuesDo: [ :key :value |
		| prevValue |
		prevValue := self publicInstVarNamed: key.
		prevValue class == SmValueHolder
			ifTrue: [
				| newValue |
				newValue := (prevValue hasType and: [ value isDictionary ])
					ifTrue: [ prevValue type fromDictionary: value ]
					ifFalse: [ value ].
				prevValue value: newValue ]
			ifFalse: [
				prevValue class == SmCollectionHolder
					ifTrue: [
						| newValue type |
						newValue := ((type := prevValue type) isNotNil and: [ value allSatisfy: [ :each | each isDictionary ] ])
							ifTrue: [ value collect: [ :each | type fromDictionary: each ] ]
							ifFalse: [ value ].
						prevValue setCollection: newValue ]
					ifFalse: [ self publicInstVarNamed: key put: value ] ] ]
]

{ #category : #accessing }
SmModel >> id [

	^ id
]

{ #category : #initialization }
SmModel >> initialize [

	super initialize.

	id := self class allInstances size + 1.
	createdAt := SmModel timestampNow
]

{ #category : #testing }
SmModel >> isDeleted [

	^ deletedAt isNotNil
]

{ #category : #testing }
SmModel >> isNew [

	"Answer whether the receiver is new.

	Implementation:
	if the receiver has not set its primary id, it is assumed to be a new instance
	which has not been stored yet. The primary id is provided by the database."

	^ primId isNil
]

{ #category : #presenters }
SmModel >> preferredPresenterClass [

	"Answer the preferred Presenter class for the receiver (in its current state).
	By default the class with a matching name will be used (if present in the image).
	The matching name is created by postfixing #Presenter (optionally replacing an
	existing postfix #Model).
	Otherwise an error is raised to make clear a presenter class should be implemented
	or a subclass should override this method to answer a specific presenter class."

	<serverEnvironment>

	| className presenterClass |

	className := (self class name withoutSuffix: #Model) asSymbol , #Presenter.
	presenterClass := Smalltalk classNamed: className.

	"If no Presenter class is found, raise an error to indicate the class should be created
	or the subclass should implement #preferredPresenterClass"
	presenterClass
		ifNil: [ self error: 'The Presenter class ', className , ' does not exist. Either create it or implement ' , self class name , ' >> #preferredPresenterClass to answer a specific class' ].

	^ presenterClass
]

{ #category : #accessing }
SmModel >> publicInstVarNamed: aString [

	"Answer the public instance variable with the specified name of the receiver.
	By default all instance variables are public."

	^ self instVarNamed: aString
]

{ #category : #accessing }
SmModel >> publicInstVarNamed: aString put: anObject [

	"Store the specified value in the public instance variable with the specified name of the receiver.
	By default all instance variables are public."

	^ self instVarNamed: aString put: anObject
]

{ #category : #accessing }
SmModel >> publicInstVarNames [

	"Answer the public instance variables of the receiver.
	By default all instance variables are public."

	^ self class instVarNames
]

{ #category : #accessing }
SmModel >> removalTimestampString [

	"Answer the timestamp of removal as a String (in ISO 8601 format)
	or answer nil if the receiver has not been deleted"

	deletedAt ifNil: [ ^ nil ].

	^ SmModel timestampStringFor: deletedAt + SmModel removalPeriod
]

{ #category : #actions }
SmModel >> undelete [

	"Undelete the receiver by removing its deletedAt timestamp value"

	deletedAt ifNil: [ ^ self ].

	deletedAt := nil.

	self valueChanged
]

{ #category : #accessing }
SmModel >> updatedAt [

	^ updatedAt
]

{ #category : #announcing }
SmModel >> valueChanged [

	updatedAt := SmModel timestampNow.

	super valueChanged
]
