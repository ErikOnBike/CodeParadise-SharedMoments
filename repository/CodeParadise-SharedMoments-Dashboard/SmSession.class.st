Class {
	#name : #SmSession,
	#superclass : #SmModel,
	#instVars : [
		'accessToken',
		'accountId'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmSession class >> withCredentials: aDictionary [

	"Answer a new instance of the receiver using the specified credentials"

	| email password |

	"Validate input"
	email := aDictionary at: #email ifAbsent: [ nil ].
	password := aDictionary at: #password ifAbsent: [ nil ].
	(email isEmptyOrNil or: [ password isEmptyOrNil ])
		ifTrue: [
			"Signal failed login"
			^ nil ].

	^ self fromDictionary: (self post: '/api/v1/login' body: aDictionary)
]

{ #category : #accessing }
SmSession class >> withCredentials: aDictionary do: aBlock [

	"Login using the specified credentials and evaluate the specified block using the matching account"

	| email password |

	"Validate input"
	email := aDictionary at: #email ifAbsent: [ nil ].
	password := aDictionary at: #password ifAbsent: [ nil ].
	(email isEmptyOrNil or: [ password isEmptyOrNil ])
		ifTrue: [
			"Signal failed login"
			aBlock value: nil.
			^ self ].

	^ self fromDictionary: (self post: '/api/v1/login' body: aDictionary)
]

{ #category : #initialization }
SmSession >> initialize [

	super initialize.

	"Account id and access token not user settable"
	"accountId := nil"
	"accessToken := nil"
]
