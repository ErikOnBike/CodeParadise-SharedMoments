Class {
	#name : #CpAccountsRestHttpServerApplication,
	#superclass : #CpServerApplication,
	#category : #'CodeParadise-SharedMoments-Data-Application'
}

{ #category : #accessing }
CpAccountsRestHttpServerApplication class >> allowedPackages [

	"Answer a collection of Packages which are allowed to contain classes to install in the receiver.

	Add packages with CpSMAccount, CpNodeJSHttpServer and CpNodeJSRestHttpServer classes.

	See comment in superclass."

	^ super allowedPackages, { CpSMAccount package . CpNodeJSHttpServer package . CpNodeJSRestHttpServer package }
]

{ #category : #accessing }
CpAccountsRestHttpServerApplication class >> app [

	^ #'shared-moments-data'
]

{ #category : #actions }
CpAccountsRestHttpServerApplication >> load [

	super load.

	self
		installRequiredClass: CpNodeJSRestHttpServerStarter ;
		installRequiredClass: CpSMAccount
]
