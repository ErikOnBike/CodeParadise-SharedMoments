Class {
	#name : #SmDashboardWebApplication,
	#superclass : #CpMvpWebApplication,
	#instVars : [
		'dashboard'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Application'
}

{ #category : #accessing }
SmDashboardWebApplication >> applicationModel [

	^ dashboard
]

{ #category : #initialization }
SmDashboardWebApplication >> initialize [

	super initialize.

	dashboard := SmDashboard new
]
