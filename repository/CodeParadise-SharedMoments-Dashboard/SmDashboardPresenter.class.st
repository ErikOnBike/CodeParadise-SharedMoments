Class {
	#name : #SmDashboardPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #accessing }
SmDashboardPresenter >> account [

	^ self dashboard account
]

{ #category : #accessing }
SmDashboardPresenter >> dashboard [

	^ self model
]

{ #category : #rendering }
SmDashboardPresenter >> renderView [

	"Render the menu and status bar as well as the account's info"

	self
		renderChildViewForModel: self dashboard
		usingPresenter: SmDashboardMenuBarPresenter
		atSlotNamed: #'menu-bar'.

	self renderChildViewForModel: self account atSlotNamed: #content.

	self
		renderChildViewForModel: self dashboard
		usingPresenter: SmDashboardStatusBarPresenter
		atSlotNamed: #'status-bar'
]
