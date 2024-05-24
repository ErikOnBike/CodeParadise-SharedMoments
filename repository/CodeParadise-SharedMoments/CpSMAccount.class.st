Class {
	#name : #CpSMAccount,
	#superclass : #CpNodeJSRestResource,
	#instVars : [
		'id',
		'email',
		'passwordHash'
	],
	#category : #'CodeParadise-SharedMoments-Model'
}

{ #category : #converting }
CpSMAccount >> asDictionary [

	^ {
		#email -> email
	} asOrderedDictionary
]
