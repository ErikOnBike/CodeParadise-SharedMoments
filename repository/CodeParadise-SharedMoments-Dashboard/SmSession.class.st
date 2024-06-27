Class {
	#name : #SmSession,
	#superclass : #SmModel,
	#instVars : [
		'accessToken',
		'account'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmSession class >> withCredentials: aCredentials [

	"Answer a new instance of the receiver using the specified credentials"

	^ self fromDictionary: (self postBody: aCredentials asDictionary)
]

{ #category : #accessing }
SmSession >> accessToken [

	^ accessToken
]

{ #category : #accessing }
SmSession >> account [

	^ account value
]

{ #category : #testing }
SmSession >> hasAccount [

	^ account isNotNil
]

{ #category : #initialization }
SmSession >> initialize [

	super initialize.

	account := SmValueHolder type: SmAccount owner: self.

	"Access token is not user settable"
	"accessToken := nil"
]
