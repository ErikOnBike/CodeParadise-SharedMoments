Class {
	#name : #SmIconPhotoFramePresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmIconPhotoFramePresenter >> photoFrame [

	^ self model
]

{ #category : #rendering }
SmIconPhotoFramePresenter >> renderView [

	self view
		renderName: self photoFrame name
]
