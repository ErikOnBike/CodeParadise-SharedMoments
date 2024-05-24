Class {
	#name : #CpSharedMomentsDashboardWebApplication,
	#superclass : #CpMvpWebApplication,
	#instVars : [
		'dashboard'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Application'
}

{ #category : #accessing }
CpSharedMomentsDashboardWebApplication >> applicationModel [

	^ dashboard
]

{ #category : #initialization }
CpSharedMomentsDashboardWebApplication >> initialize [

	super initialize.

	dashboard := CpSmDashboard new
]
