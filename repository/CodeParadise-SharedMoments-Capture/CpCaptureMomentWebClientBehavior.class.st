Class {
	#name : #CpCaptureMomentWebClientBehavior,
	#superclass : #CpWebClientBehavior,
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #initialization }
CpCaptureMomentWebClientBehavior >> initialize [

	super initialize.

	CpHtmlElement documentBody
		appendChild: CpCaptureMomentWebApplicationScreen new
]
