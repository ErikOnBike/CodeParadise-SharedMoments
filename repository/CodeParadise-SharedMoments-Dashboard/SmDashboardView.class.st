Class {
	#name : #SmDashboardView,
	#superclass : #CpView,
	#category : #'CodeParadise-SharedMoments-Dashboard-View'
}

{ #category : #'web resources' }
SmDashboardView class >> style [

	<webResource: #css>

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		flex-direction: column;
		height: 100%;
		justify-content: space-between;
		align-items: stretch;
	}
	#menu-bar {
		flex: 0 0 auto;
	}
	#content {
		flex: 1 0 0;
		overflow-y: scroll;
	}
	#status-bar {
		flex: 0 0 auto;
		background-color: rgba(0, 0, 255, .1);
	}'
]

{ #category : #'web resources' }
SmDashboardView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="menu-bar"><slot name="menu-bar">hello</slot></div>
		<div id="content"><slot name="content"></slot></div>
		<div id="status-bar"><slot name="status-bar">world</slot></div>
	</div>'
]
