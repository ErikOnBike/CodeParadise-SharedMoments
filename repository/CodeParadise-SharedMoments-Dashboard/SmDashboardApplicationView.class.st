Class {
	#name : #SmDashboardApplicationView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'class initialization' }
SmDashboardApplicationView class >> beLoaded [

	SlAlert beLoaded.
	SlAvatar beLoaded.
	SlBadge beLoaded.
	SlButton beLoaded.
	SlCard beLoaded.
	SlDivider beLoaded.
	SlIcon beLoaded.
	SlIconButton beLoaded.
	SlInput beLoaded.
	SlRelativeTime beLoaded.
	SlSwitch beLoaded.
	SlTag beLoaded.
	SlTooltip beLoaded
]

{ #category : #'web resources' }
SmDashboardApplicationView class >> globalStyle [

	<webResource: #css>

	^ 'html, body {
		height: 100%;
		margin: 0;
		padding: 0;
	}
	body {
		font-family: "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
	}
	sl-icon::part(svg) {
		overflow: visible;
	}'
]

{ #category : #'web resources' }
SmDashboardApplicationView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	:host,
	#container {
		height: 100%;
	}'
]

{ #category : #'web resources' }
SmDashboardApplicationView class >> template [

	<webResource: #html>

	^ '<div id="container"><slot></slot></div>'
]
