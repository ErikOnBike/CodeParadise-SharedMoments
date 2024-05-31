Class {
	#name : #SmSmallCameraPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmSmallCameraPresenter >> camera [

	^ self model
]

{ #category : #rendering }
SmSmallCameraPresenter >> renderView [

	self view renderInitials: self camera nameInitials
]
