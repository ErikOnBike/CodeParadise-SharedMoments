Class {
	#name : #SmDashboardPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #rendering }
SmDashboardPresenter >> renderView [

	"Render the menu and status bar as well as the account's info"

	self
		renderChildViewForModel: self model
		usingPresenter: SmDashboardMenuBarPresenter
		atSlotNamed: #'menu-bar'.

	self
		renderChildViewForModel: self model
		usingPresenter: SmDashboardStatusBarPresenter
		atSlotNamed: #'status-bar'.

	"@@Content"
]
