Class {
	#name : #SmDashboard,
	#superclass : #CpModel,
	#instVars : [
		'account'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #presenter }
SmDashboard >> preferredPresenterClass [

	account ifNil: [ ^ SmLoginPresenter ].

	^ super preferredPresenterClass
]
