Class {
	#name : #SmModel,
	#superclass : #CpBaseModel,
	#instVars : [
		'id',
		'createdAt',
		'updatedAt',
		'deletedAt'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #'as yet unclassified' }
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

{ #category : #initialization }
SmModel >> initialize [

	super initialize.

	createdAt := SmModel timestampNow
]

{ #category : #testing }
SmModel >> isDeleted [

	^ deletedAt isNotNil
]

{ #category : #accessing }
SmModel >> removeTimestampString [

	"Answer the timestamp of removal as a String (in ISO 8601 format)
	or answer nil if the receiver has not been deleted"

	deletedAt ifNil: [ ^ nil ].

	self flag: #FIXME. "Add support for when run in REST server"
	^ (DateAndTime fromUnixTime: deletedAt + SmModel removalPeriod) printString
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
