Class {
	#name : #SmDashboardWebApplication,
	#superclass : #CpMvpWebApplication,
	#instVars : [
		'dashboard'
	],
	#category : #'CodeParadise-SharedMoments-Dashboard-Application'
}

{ #category : #accessing }
SmDashboardWebApplication class >> allowedPackages [

	"Answer a collection of Packages which are allowed to contain classes to install in the receiver.

	Add package with the Shoelace elements.

	See comment in superclass."

	^ super allowedPackages, { SlElement package }
]

{ #category : #accessing }
SmDashboardWebApplication >> applicationModel [

	^ dashboard
]

{ #category : #presenter }
SmDashboardWebApplication >> applicationPresenterClass [

	"Answer an explicit Presenter class to make sure we have a fixed
	parent Presenter for our domain Presenters (allowing them to be
	updated when state changes, for example because of login/logout)"

	^ SmDashboardApplicationPresenter
]

{ #category : #initialization }
SmDashboardWebApplication >> initialize [

	super initialize.

	dashboard := SmDashboard new
]

{ #category : #actions }
SmDashboardWebApplication >> reload [

	"Reload account info"

	dashboard reload. 

	super reload
]
