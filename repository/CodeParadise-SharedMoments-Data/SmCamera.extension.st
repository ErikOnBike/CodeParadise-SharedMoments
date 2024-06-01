Extension { #name : #SmCamera }

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmCamera >> asDictionary [

	^ {
		#name -> self name
	} asOrderedDictionary
]
