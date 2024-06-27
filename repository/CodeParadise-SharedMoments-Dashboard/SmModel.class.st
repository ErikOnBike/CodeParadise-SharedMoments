Class {
	#name : #SmModel,
	#superclass : #CpBaseModel,
	#instVars : [
		'id',
		'createdAt',
		'updatedAt',
		'deletedAt',
		'updateState'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #API }
SmModel class >> basePath [

	^ 'http://localhost:8181/api/v1/', self nameWithoutPrefix asKebabCase asPlural
]

{ #category : #API }
SmModel class >> forId: aString [

	^ (self
		get: '/:id'
		withParameters: { #id -> aString } asDictionary)
			ifNotNil: [ :dict | self fromDictionary: dict ]
]

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

	path := self basePath, ((CpNodeJSRestPathPattern fromString: aString)
		pathUsingParameters: aDictionary).

	[
		client := ZnClient new
			forJsonREST ;
			enforceHttpSuccess: true ;
			get: path ;
			yourself
	] on: ZnHttpUnsuccessful do: [ :httpError |
		httpError response isNotFound
			ifTrue: [ ^ nil ].
		httpError signal ].

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
		withParameters: nil
		body: anObject
]

{ #category : #API }
SmModel class >> post: aString withParameters: aDictionary body: anObject [

	"Perform POST operation on REST API"

	| path client |

	path := self basePath, ((CpNodeJSRestPathPattern fromString: aString)
		pathUsingParameters: aDictionary).

	client := ZnClient new
		forJsonREST ;
		enforceHttpSuccess: true ;
		post: path contents: anObject asDictionary ;
		yourself.

	client isSuccess
		ifTrue: [ ^ client contents ]
		ifFalse: [ self error: 'Failed to write data to REST API' ]
]

{ #category : #API }
SmModel class >> postBody: anObject [

	"Perform POST operation on REST API"

	^ self
		post: ''
		withParameters: nil
		body: anObject
]

{ #category : #API }
SmModel class >> put: aString body: anObject [

	"Perform PUT operation on REST API"

	^ self
		put: aString
		withParameters: nil
		body: anObject
]

{ #category : #API }
SmModel class >> put: aString withParameters: aDictionary body: anObject [

	"Perform PUT operation on REST API"

	| path client |

	path := self basePath, ((CpNodeJSRestPathPattern fromString: aString)
		pathUsingParameters: aDictionary).

	client := ZnClient new
		forJsonREST ;
		enforceHttpSuccess: true ;
		put: path contents: anObject asDictionary ;
		yourself.

	client isSuccess
		ifTrue: [ ^ client contents ]
		ifFalse: [ self error: 'Failed to write data to REST API' ]
]

{ #category : #API }
SmModel class >> putBody: anObject [

	"Perform PUT operation on REST API"

	^ self
		put: ''
		withParameters: nil
		body: anObject
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

	self modelInstVarNames do: [ :each |
		| value |
		value := self modelInstVarNamed: each.
		value class == SmValueHolder
			ifTrue: [
				value := value value.
				(value isKindOf: SmModel)
					ifTrue: [ value := value asDictionary ] ]
			ifFalse: [
				value class == SmCollectionHolder
					ifTrue: [
						value := value
							collect: [ :element |
								(element isKindOf: SmModel)
									ifTrue: [ element asDictionary ]
									ifFalse: [ element ] ]
							as: Array ] ].
		dictionary at: each put: value ].

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

	| needUpdate |

	updateState := id
		ifNotNil: [ #updating ]
		ifNil: [ #initializing ].

	aDictionary keysAndValuesDo: [ :key :value |
		| prevValue |
		prevValue := self modelInstVarNamed: key.
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
					ifFalse: [ self modelInstVarNamed: key put: value ] ] ].

	"Check if an update is needed (then reset state to allow #valueChanged to have effect)"
	needUpdate := updateState == #updated.
	updateState := nil.

	"Announce receiver has changed (if applicable)"
	needUpdate
		ifTrue: [ self valueChanged ]
]

{ #category : #accessing }
SmModel >> id [

	^ id
]

{ #category : #testing }
SmModel >> isDeleted [

	^ deletedAt isNotNil
]

{ #category : #testing }
SmModel >> isNew [

	^ id isNil
]

{ #category : #accessing }
SmModel >> modelInstVarNamed: aString [

	"Answer the public instance variable with the specified name of the receiver.
	By default all instance variables are public."

	^ self instVarNamed: aString
]

{ #category : #accessing }
SmModel >> modelInstVarNamed: aString put: anObject [

	"Store the specified value in the public instance variable with the specified name of the receiver.
	By default all instance variables are public."

	^ self instVarNamed: aString put: anObject
]

{ #category : #accessing }
SmModel >> modelInstVarNames [

	"Answer the model instance variables of the receiver.
	These are the instance variables which can be get/set.
	By default all instance variables are get/set-able,
	except for variables explicitly set to private."

	| privateInstVarNames |

	privateInstVarNames := self privateInstVarNames.

	^ self class instVarNames
		reject: [ :each | privateInstVarNames includes: each ]
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
SmModel >> privateInstVarNames [

	"Answer the private instance variables of the receiver.
	These are the instance variables which can NOT be get/set.
	By default no instance variable is private."

	^ #()
]

{ #category : #accessing }
SmModel >> removalTimestampString [

	"Answer the timestamp of removal as a String (in ISO 8601 format)
	or answer nil if the receiver has not been deleted"

	deletedAt ifNil: [ ^ nil ].

	^ SmModel timestampStringFor: deletedAt + SmModel removalPeriod
]

{ #category : #database }
SmModel >> retrieve [

	"Retrieve the (full) receiver from the DB"

	self fromDictionary: (self class
		get: '/:id'
		withParameters: { #id -> id } asDictionary)
]

{ #category : #database }
SmModel >> store [

	"Store the receiver in the DB and update its internal fields"

	self fromDictionary: (self isNew
		ifTrue: [ self class postBody: self asDictionary ]
		ifFalse: [ self class put: '/:id' withParameters: { #id -> id } asDictionary body: self asDictionary ])
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

	updateState == #updating
		ifTrue: [ updateState := #updated ].
	updateState ifNotNil: [ ^ self ].

	super valueChanged.

	self store
]
