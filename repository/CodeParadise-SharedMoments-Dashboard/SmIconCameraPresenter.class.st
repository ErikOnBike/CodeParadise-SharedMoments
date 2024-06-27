Class {
	#name : #SmIconCameraPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmIconCameraPresenter >> camera [

	^ self model
]

{ #category : #rendering }
SmIconCameraPresenter >> renderView [

	self view
		renderName: self camera name
]
