Class {
	#name : #SmRestApiService,
	#superclass : #Object,
	#instVars : [
		'database',
		'preparedStatements'
	],
	#category : #'CodeParadise-SharedMoments-Data-Core'
}

{ #category : #errors }
SmRestApiService >> errorNoBody [

	self error: 'No body present in REST request'
]

{ #category : #initialization }
SmRestApiService >> initialize [

	super initialize.

	database := CpNodeJSSqlite3Database onPath: 'data/database.db' withOptions: Dictionary new.
	preparedStatements := Dictionary new
]

{ #category : #API }
SmRestApiService >> login: aRestRequest response: aServerResponse [

	| body |

	body := (aRestRequest jsonBody) ifNil: [ self errorNoBody ].

	
]
