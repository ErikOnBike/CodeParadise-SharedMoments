Class {
	#name : #SmSmallPhotoFramePresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmSmallPhotoFramePresenter >> photoFrame [

	^ self model
]

{ #category : #rendering }
SmSmallPhotoFramePresenter >> renderView [

	self view
		renderName: self photoFrame name
]
