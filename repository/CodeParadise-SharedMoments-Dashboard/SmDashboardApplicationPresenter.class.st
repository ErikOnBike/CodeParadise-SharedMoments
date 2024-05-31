Class {
	#name : #SmDashboardApplicationPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #rendering }
SmDashboardApplicationPresenter >> renderView [

	"Render the dashboard (using the preferred Presenter class)"

	self renderChildViewForModel: self model
]
