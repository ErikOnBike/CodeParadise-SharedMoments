Extension { #name : #SmModel }

{ #category : #'*CodeParadise-SharedMoments-Dashboard' }
SmModel >> preferredPresenterClass [

	"Answer the preferred Presenter class for the receiver (in its current state).
	By default the class with a matching name will be used (if present in the image).
	The matching name is created by postfixing #Presenter (optionally replacing an
	existing postfix #Model).
	Otherwise an error is raised to make clear a presenter class should be implemented
	or a subclass should override this method to answer a specific presenter class."

	| className presenterClass |

	className := (self class name withoutSuffix: #Model) asSymbol , #Presenter.
	presenterClass := Smalltalk classNamed: className.

	"If no Presenter class is found, raise an error to indicate the class should be created
	or the subclass should implement #preferredPresenterClass"
	presenterClass
		ifNil: [ self error: 'The Presenter class ', className , ' does not exist. Either create it or implement ' , self class name , ' >> #preferredPresenterClass to answer a specific class' ].

	^ presenterClass
]
