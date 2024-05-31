Extension { #name : #SmCollection }

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmCollection >> asDictionary [

	^ {
		#name -> name
	} asOrderedDictionary
]
