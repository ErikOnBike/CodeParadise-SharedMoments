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
SmSession class >> withCredentials: aCredentials [

	"Answer a new instance of the receiver using the specified credentials"

	^ self fromDictionary: (self post: '/api/v1/login' body: aCredentials asDictionary)
]

{ #category : #accessing }
SmSession >> accessToken [

	^ accessToken
]

{ #category : #accessing }
SmSession >> accountId [

	^ accountId
]

{ #category : #initialization }
SmSession >> initialize [

	super initialize.

	"Account id and access token not user settable"
	"accountId := nil"
	"accessToken := nil"
]
