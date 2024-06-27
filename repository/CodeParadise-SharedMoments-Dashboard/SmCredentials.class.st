Class {
	#name : #SmCredentials,
	#superclass : #SmModel,
	#instVars : [
		'email',
		'password'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmCredentials >> email [

	^ email value
]

{ #category : #accessing }
SmCredentials >> email: aString [

	email value: aString
]

{ #category : #initialization }
SmCredentials >> initialize [

	super initialize.

	email := SmValueHolder owner: self.
	password := SmValueHolder owner: self
]

{ #category : #accessing }
SmCredentials >> password [

	^ password value
]

{ #category : #accessing }
SmCredentials >> password: aString [

	password value: aString
]
