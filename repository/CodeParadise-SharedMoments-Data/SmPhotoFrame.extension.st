Extension { #name : #SmPhotoFrame }

{ #category : #'*CodeParadise-SharedMoments-Data' }
SmPhotoFrame >> asDictionary [

	^ {
		#name -> self name
	} asOrderedDictionary
]
