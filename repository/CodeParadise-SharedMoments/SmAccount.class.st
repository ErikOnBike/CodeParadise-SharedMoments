Class {
	#name : #SmAccount,
	#superclass : #SmModel,
	#instVars : [
		'email'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #accessing }
SmAccount class >> forCredentials: aDictionary [

	"Answer an instance of the receiver with the specified credentials.
	If such an instance does not exist, answer nil."

	| email |

	email := aDictionary at: #email ifAbsent: [ ^ nil ].

	email = 'nobody'
		ifFalse: [ ^ nil ].

	^ self basicNew
		initializeWithEmail: email ;
		yourself
]

{ #category : #initialization }
SmAccount >> initializeWithEmail: aString [

	self initialize.

	email := aString
]
