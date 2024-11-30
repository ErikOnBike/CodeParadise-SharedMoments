Class {
	#name : #SmTime,
	#superclass : #Object,
	#instVars : [
		'offset'
	],
	#classVars : [
		'Default'
	],
	#category : #'CodeParadise-SharedMoments-Data'
}

{ #category : #accessing }
SmTime class >> default [

	"Answer the default instance"

	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
SmTime class >> now [

	"Answer the current timestamp as seconds since Unix epoch (midnight Jan 1, 1970, UTC)"

	^ ((CpJavaScriptClass forName: #Date) apply: #now) // 1000
]

{ #category : #accessing }
SmTime >> now [

	"See class method comment"

	^ self class now
]
