Class {
	#name : #SmCaptureMomentWebClientBehavior,
	#superclass : #CpWebClientBehavior,
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #initialization }
SmCaptureMomentWebClientBehavior >> initialize [

	super initialize.

	CpHtmlElement documentBody
		appendChild: SmCaptureMomentWebApplicationScreen new
]
