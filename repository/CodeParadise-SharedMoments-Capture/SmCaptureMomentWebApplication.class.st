Class {
	#name : #SmCaptureMomentWebApplication,
	#superclass : #CpWebApplication,
	#category : #'CodeParadise-SharedMoments-Capture-Application'
}

{ #category : #accessing }
SmCaptureMomentWebApplication class >> allowedPackages [

	"Answer a collection of Packages which are allowed to contain classes to install in the receiver.

	Add package with the VideoElement class.

	See comment in superclass."

	^ super allowedPackages, { CpBrowserVideoElement package }
]

{ #category : #accessing }
SmCaptureMomentWebApplication class >> clientBehaviorClass [

	^ SmCaptureMomentWebClientBehavior
]
