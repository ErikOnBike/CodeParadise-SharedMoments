Class {
	#name : #SmAccountsRestHttpServerApplication,
	#superclass : #CpServerApplication,
	#category : #'CodeParadise-SharedMoments-Data-Application'
}

{ #category : #accessing }
SmAccountsRestHttpServerApplication class >> allowedPackages [

	"Answer a collection of Packages which are allowed to contain classes to install in the receiver.

	Add packages with CpSMAccount, CpNodeJSHttpServer and CpNodeJSRestHttpServer classes.

	See comment in superclass."

	^ super allowedPackages, {
		SmAccount package .
		CpNodeJSHttpServer package .
		CpNodeJSRestHttpServer package .
		CpNodeJSSqlite3Database package }
]

{ #category : #accessing }
SmAccountsRestHttpServerApplication class >> app [

	^ #'shared-moments-data'
]

{ #category : #actions }
SmAccountsRestHttpServerApplication >> load [

	super load.

	self
		installRequiredClass: CpNodeJSRestHttpServerStarter ;
		installRequiredClass: SmRestApiService
]
