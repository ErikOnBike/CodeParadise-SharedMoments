Class {
	#name : #CpAccountsRestHttpServerApplication,
	#superclass : #CpServerApplication,
	#category : #'CodeParadise-SharedMoments-Data-Application'
}

{ #category : #accessing }
CpAccountsRestHttpServerApplication class >> app [

	^ 'shared-moments-data'
]

{ #category : #actions }
CpAccountsRestHttpServerApplication >> load [

	super load.

	self environment
		addClass: CpNodeJSRestHttpServerStarter
]
