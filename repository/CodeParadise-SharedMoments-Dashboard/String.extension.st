Extension { #name : #String }

{ #category : #'*CodeParadise-SharedMoments-Dashboard' }
String >> asPlural [

	"Answer a String which has a plural extension (meaning in English end with s)"

	self ifEmpty: [ ^ self ].

	self last = $s
		ifTrue: [ ^ self ].

	^ self, 's'
]
