Class {
	#name : #SmModel,
	#superclass : #CpBaseModel,
	#instVars : [
		'primId',
		'id',
		'createdAt',
		'updatedAt',
		'deletedAt'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #support }
SmModel class >> isFuture: anInteger [

	"Answer whether the specified timestamp is in the future"

	^ self timestampNow < anInteger
]

{ #category : #support }
SmModel class >> randomToken [

	"Answer a random token value (as a String).

	Implementation:
	Since currently the tiny image for CodeParadise does not support the Pharo UUID class,
	use a different implementation for both, answering a String representation."

	(Smalltalk classNamed: #UUID)
		ifNotNil: [ :uuidClass | ^ uuidClass new printString ].

	(Smalltalk classNamed: #CpNodeJSCrypto)
		ifNotNil: [ :cryptoModule | ^ cryptoModule require randomUUID ].

	self error: 'No UUID class available in the current environment'
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
