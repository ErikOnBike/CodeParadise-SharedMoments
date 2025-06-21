Class {
	#name : #SmBeforeSessionExpires,
	#superclass : #Announcement,
	#instVars : [
		'duration'
	],
	#category : #'CodeParadise-SharedMoments-Data'
}

{ #category : #accessing }
SmBeforeSessionExpires class >> duration: anInteger [

	"Answer a new instance of the receiver for the specified duration (inn seconds)
	before a Session expires"

	^ self basicNew
		initializeWithDuration: anInteger ;
		yourself
]

{ #category : #testing }
SmBeforeSessionExpires class >> durationForSubscription: anAnnouncementSubscription [

	"Answer the duration of the specified AnnouncementSubscription.
	If the AnnouncementSubscription does not contain (an instance of) the receiver, answer nil.

	Implementation:
	Since my instances are used as the 'announcementClass' check for its class to be equal to the receiver."

	| announcement |

	(announcement := anAnnouncementSubscription announcementClass) class = self
		ifFalse: [ ^ nil ].

	^ announcement duration
]

{ #category : #accessing }
SmBeforeSessionExpires >> duration [

	^ duration
]

{ #category : #testing }
SmBeforeSessionExpires >> handlesAnnouncement: anAnnouncement [

	"Answer whether the receiver handles the specified Announcement"

	^ (self class handlesAnnouncement: anAnnouncement)
		and: [ self duration = anAnnouncement duration ]
]

{ #category : #initialization }
SmBeforeSessionExpires >> initializeWithDuration: anInteger [

	self initialize.

	duration := anInteger
]
