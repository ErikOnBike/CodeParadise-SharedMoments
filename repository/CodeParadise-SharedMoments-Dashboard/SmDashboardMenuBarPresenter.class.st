Class {
	#name : #SmDashboardMenuBarPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-SharedMoments-Dashboard-Presenter'
}

{ #category : #'event handling' }
SmDashboardMenuBarPresenter >> logout [

	self model logout
]

{ #category : #view }
SmDashboardMenuBarPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpActionRequested id: #logout) send: #logout to: self
]
