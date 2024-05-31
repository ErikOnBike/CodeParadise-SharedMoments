Class {
	#name : #SmDashboard,
	#superclass : #CpModel,
	#instVars : [
		'account'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Model'
}

{ #category : #accessing }
SmDashboard >> account: anAccount [

	account := anAccount.

	self valueChanged
]

{ #category : #'event handling' }
SmDashboard >> logout [

	self account: nil
]

{ #category : #presenter }
SmDashboard >> preferredPresenterClass [

	account ifNil: [ ^ SmLoginPresenter ].

	^ super preferredPresenterClass
]
