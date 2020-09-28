"
This is a basic chart for RSLabelBenchs
"
Class {
	#name : #RSBenchChartBuilder,
	#superclass : #Object,
	#instVars : [
		'averages',
		'mins',
		'maxs',
		'errors',
		'chart',
		'rawData',
		'nameOfBenchmark',
		'theme',
		'statsReporter',
		'horizontalNames',
		'selectedCustomParameters'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #examples }
RSBenchChartBuilder class >> exampleFirstRenderings [

	| rawData |
	rawData := RSLabelBenchs new runOnNumberOfRenderings.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(numberOfRenderings);
		build;
		chart) open
]

{ #category : #examples }
RSBenchChartBuilder class >> exampleFlowLayout [

	| rawData |
	rawData := RSLabelBenchs new
		runLayoutSelector: #applyFlowLayout:
		maxLabels: 300.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(numberOfLabels);
		build;
		chart) open
]

{ #category : #examples }
RSBenchChartBuilder class >> exampleForceBasedLayout [

	| rawData |
	rawData := RSLabelBenchs new
		runLayoutSelector: #applyForceBasedLayout:
		maxLabels: 100.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(numberOfLabels);
		build;
		chart) open
]

{ #category : #examples }
RSBenchChartBuilder class >> exampleNoLayout [

	| rawData |
	rawData := RSLabelBenchs new
		runLayoutSelector: #applyNoLayout:
		maxLabels: 300.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(numberOfLabels);
		build;
		chart) open
]

{ #category : #building }
RSBenchChartBuilder >> build [
	self processRawData.
	self buildChart.

]

{ #category : #private }
RSBenchChartBuilder >> buildChart [

	| horizontalIndices horizontal |
	horizontalIndices := 1 to: horizontalNames size.
	chart := RSChart new.
	chart extent: 800@600.

	chart addPlot: (RSAreaPlot new 
		x: horizontalIndices y1: maxs y2: mins;
		color: theme lightBackgroundColor).

	chart addPlot: (RSAreaPlot new 
		x: horizontalIndices y1: averages + errors y2: averages - errors;
		color: theme balloonBackgroundColor).

	chart addPlot: (RSLinePlot new x: horizontalIndices y: averages; fmt: 'o'; color: theme textColor).

	chart addDecoration: (horizontal := RSHorizontalTick new fromNames: horizontalNames).
	horizontal labelLocation below; left.
	chart addDecoration: (RSVerticalTick new numberOfTicks: 10; asFloat).
	chart title: nameOfBenchmark.
	chart xlabel: self xlabelString.
	chart ylabel: 'Time (ms)'.

]

{ #category : #accessing }
RSBenchChartBuilder >> chart [

	^ chart
]

{ #category : #private }
RSBenchChartBuilder >> horizontalNameFor: anAssociation [
	
	^ String streamContents: [ :stream |
		selectedCustomParameters
			do: [ :each |
				stream << (anAssociation key at: each) asString ]
			separatedBy: [ 
				stream << ' + ' ] ]
]

{ #category : #initialization }
RSBenchChartBuilder >> initialize [
	super initialize.
	
	theme := Smalltalk ui theme.
	statsReporter := SMarkSimpleStatisticsReporter new.

]

{ #category : #initialization }
RSBenchChartBuilder >> nameOfBenchmark: aString [
	"Set the SMark name for the benchmark to graph. For example, if the method is named benchLabels, here you should set just 'Labels'."

	nameOfBenchmark := aString
]

{ #category : #private }
RSBenchChartBuilder >> processRawData [
	
	horizontalNames := OrderedCollection new.
	averages := OrderedCollection new.
	mins := OrderedCollection new.
	maxs := OrderedCollection new.
	errors := OrderedCollection new.

	rawData do: [ :each | self processRawDataItem: each ].

]

{ #category : #private }
RSBenchChartBuilder >> processRawDataItem: anAssociation [

	| totalTimes benchResults |
	horizontalNames add: (self horizontalNameFor: anAssociation).

	benchResults := anAssociation value results at: nameOfBenchmark.
	totalTimes := statsReporter totalResultsFor: benchResults.
"	totalTimes := benchResults collect: [ :result | (result criteria at: 'total') totalTime ]."
	errors add: (statsReporter confidenceVariance: totalTimes).
	averages add: totalTimes average asFloat.
	mins add: totalTimes min.
	maxs add: totalTimes max
]

{ #category : #initialization }
RSBenchChartBuilder >> rawData: aCollection [
	"Set the output of the benchmarks in the chart."

	rawData := aCollection
]

{ #category : #initialization }
RSBenchChartBuilder >> selectedCustomParameters: aCollectionOfSymbols [
	"Set the custom pararmetters of the benchmark that are considered as variables (for the horizontal axis)."

	selectedCustomParameters := aCollectionOfSymbols
]

{ #category : #private }
RSBenchChartBuilder >> xlabelString [
	^ String streamContents: [ :stream |
		stream << 'Custom Parameters: '.
		selectedCustomParameters
			do: [ :each | stream << each ]
			separatedBy: [ stream << ', ' ] ]
]
