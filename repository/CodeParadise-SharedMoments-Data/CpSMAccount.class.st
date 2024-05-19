Class {
	#name : #CpSMAccount,
	#superclass : #CpNodeJSRestCollection,
	#category : #'CodeParadise-SharedMoments-Data-Model'
}

{ #category : #'REST api' }
CpSMAccount class >> create: anObject [

	"Create a new account and answer its identifier"

	<restMethod: #POST path: '/accounts'>
	<restParam: 1 from: #body>

]

{ #category : #'REST api' }
CpSMAccount class >> delete: aString [

	"Delete an existing account"

	<restMethod: #DELETE path: '/accounts/:id'>
	<restParam: 1 from: #path at: #id>

]

{ #category : #'REST api' }
CpSMAccount class >> list [

	"Answer all accounts"

	<restMethod: #GET path: '/accounts'>

]

{ #category : #'REST api' }
CpSMAccount class >> update: aString with: anObject [

	"Update an existing account"

	<restMethod: #PATCH path: '/accounts/:id'>
	<restParam: 1 from: #path at: #id>
	<restParam: 2 from: #body>

]
