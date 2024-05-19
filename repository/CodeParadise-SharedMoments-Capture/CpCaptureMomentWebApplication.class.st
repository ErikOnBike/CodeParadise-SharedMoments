Class {
	#name : #CpCaptureMomentWebApplication,
	#superclass : #CpWebApplication,
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #accessing }
CpCaptureMomentWebApplication class >> clientBehaviorClass [

	^ CpCaptureMomentWebClientBehavior
]
