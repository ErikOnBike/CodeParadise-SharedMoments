Class {
	#name : #SmSecondaryPresenter,
	#superclass : #CpPresenter,
	#instVars : [
		'secondaryPresenter'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #rendering }
SmSecondaryPresenter >> renderView [

	self renderChildViewForModel: self model
]
