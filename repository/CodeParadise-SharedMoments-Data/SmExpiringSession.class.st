Class {
	#name : #SmExpiringSession,
	#superclass : #CpBaseModel,
	#instVars : [
		'accessToken',
		'expiresAt',
		'timer',
		'nextTimerDuration'
	],
	#category : #'CodeParadise-SharedMoments-Data'
}

{ #category : #accessing }
SmExpiringSession >> accessToken [

	^ accessToken
]

{ #category : #accessing }
SmExpiringSession >> accessToken: aString [

	accessToken = aString
		ifTrue: [ ^ self ].

	accessToken := aString.

	self valueChanged
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> announceTimers [

	"Announce the next duration before expiring has arrived"

	| announceDuration |

	"Keep next duration, because it will be changed before usage"
	announceDuration := nextTimerDuration.

	"Set the new timeout for another next duration.
	This allows the handler of the Announcement to update the duration/expiresAt of the receiver.
	That update will simply override the one set here."
	self setTimeout.

	announceDuration ifNil: [ ^ self ].

	self announce: (SmBeforeSessionExpires duration: announceDuration)
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> announceTimersBetween: oldDuration and: newDuration [

	"Announce the relevant timers/durations.

	Implementation:
	The oldDuration will be larger than the newDuration (we're getting closer to expiration).
	The oldDuration has already been triggered, only handle newer ones (substract 1).
	We should not yet trigger the newDuration, because it will be triggered by the timeout
	(therefore add 1)."

	| expiresDurations |

	expiresDurations := self expiresDurations.

	oldDuration - 1 to: newDuration + 1 by: -1 do: [ :duration |
		(expiresDurations includes: duration)
			ifTrue: [ self announce: (SmBeforeSessionExpires duration: duration) ] ]
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> duration [

	"Answer the number of seconds the receiver is (still) valid or nil if the session never expires"

	expiresAt ifNil: [ ^ nil ].

	"Answer -1 for already expired receivers"
	^ (expiresAt - MaEntity timestampNow) max: -1
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> duration: anInteger [

	"Set the number of seconds the receiver is (still) valid"

	(anInteger isInteger and: [ anInteger >= 0 ])
		ifFalse: [  self error: 'A Session''s duration should be an Integer >= 0' ].

	self expiresAt: MaEntity timestampNow + anInteger
]

{ #category : #accessing }
SmExpiringSession >> expiresAt [

	^ expiresAt
]

{ #category : #accessing }
SmExpiringSession >> expiresAt: anInteger [

	"Set the expiration timestamp (seconds sinds Unix epoch)"

	expiresAt = anInteger
		ifTrue: [ ^ self ].

	(anInteger isNil or: [ anInteger isInteger ])
		ifFalse: [ self error: 'A session''s expiresAt should be nil (never expires) or an Integer' ].

	self removeTimeout.
	expiresAt := anInteger.
	self setTimeout.

	self valueChanged
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> expiresDurations [

	"Answer a Collection of duration for BeforeSessionExpires Announcements"

	| durations |

	announcer ifNil: [ ^ #() ].

	durations := Set new.

	"Interface is a bit 'lame' first subscriptions answers the registry"
	announcer subscriptions subscriptions do: [ :each |
		(SmBeforeSessionExpires durationForSubscription: each) ifNotNil: [ :duration |
			durations add: duration ] ].

	^ durations
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> isExpired [

	"Answer whether the receiver is expired.
	If #expiresAt is nil it means the session never expires."

	^ expiresAt
		ifNotNil: [ MaEntity timestampNow > expiresAt ]
		ifNil: [ false ]
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> neverExpire [

	"Make the receiver never expire"

	self expiresAt: nil
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> removeTimeout [

	timer ifNil: [ ^ self ].

	CpBrowserWindow current clearTimeout: timer.

	timer := nil.
	nextTimerDuration := nil
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> setTimeout [

	"Set a timer for the 'next' duration (a duration still in the future).

	Implementation:
	Only durations which are smaller (or equal) to the remaining duration are taken into account.
	These durations are in the future, we select the one which should be triggered soonest.
	This is the highest duration smaller than the remaining duration. All higher durations are
	in the past."

	| remainingDuration expiresDurations newNextTimerDuration |

	remainingDuration := self duration.
	expiresDurations := self expiresDurations asSortedCollection: [ :a :b | a > b ].
	newNextTimerDuration := expiresDurations
		detect: [ :each | each <= remainingDuration and: [ nextTimerDuration isNil or: [ each < nextTimerDuration ] ] ]
		ifNone: [ nil ].

	"Announce all timers since the 'old' and the 'new' next duration.
	Because delays (timeouts are not always perfect on time and some operations might take more
	time) we might have missed certain durations, trigger/announce these now."
	nextTimerDuration ifNotNil: [
		self announceTimersBetween: nextTimerDuration and: (newNextTimerDuration ifNil: [ remainingDuration ]) ].

	(nextTimerDuration := newNextTimerDuration)
		ifNil: [ ^ self ].

	"Set the timer for the next duration"
	timer := CpBrowserWindow current
		setTimeout: (remainingDuration - nextTimerDuration) * 1000
		thenDo: [ self announceTimers ]
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> when: anInteger hoursBeforeExpiresSend: aSymbol to: anObject [

	self when: anInteger * 3600 secondsBeforeExpiresSend: aSymbol to: self
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> when: anInteger minutesBeforeExpiresSend: aSymbol to: anObject [

	self when: anInteger * 60 secondsBeforeExpiresSend: aSymbol to: self
]

{ #category : #'as yet unclassified' }
SmExpiringSession >> when: anInteger secondsBeforeExpiresSend: aSymbol to: anObject [

	self
		when: (SmBeforeSessionExpires duration: anInteger)
		send: aSymbol
		to: anObject
]
