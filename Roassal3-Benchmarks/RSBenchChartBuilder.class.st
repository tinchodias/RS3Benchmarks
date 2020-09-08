Class {
	#name : #RSBenchChartBuilder,
	#superclass : #Object,
	#instVars : [
		'averages',
		'mins',
		'maxs',
		'errors',
		'valuesOfSelectedVariable',
		'chart',
		'rawData',
		'nameOfBenchmark',
		'selectedVariable',
		'theme',
		'statsReporter'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #examples }
RSBenchChartBuilder class >> exampleOnNumberOfLabels [

	| rawData |
	rawData := RSLabelBenchs new runOnNumberOfLabels.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedVariable: #numberOfLabels;
		build;
		chart) open
]

{ #category : #examples }
RSBenchChartBuilder class >> exampleOnNumberOfRenderings [

	| rawData |
	rawData := RSLabelBenchs new runOnNumberOfRenderings.

	(self new
		rawData: rawData;
		nameOfBenchmark: 'Labels';
		selectedVariable: #numberOfRenderings;
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

	| horizontalIndices |
	horizontalIndices := 1 to: valuesOfSelectedVariable size.
	chart := RSChart new.
	chart extent: 800@600.

	chart addPlot: (RSAreaPlot new 
		x: horizontalIndices y1: maxs y2: mins;
		color: theme lightBackgroundColor).

	chart addPlot: (RSAreaPlot new 
		x: horizontalIndices y1: averages + errors y2: averages - errors;
		color: theme balloonBackgroundColor).

	chart addPlot: (RSLinePlot new x: horizontalIndices y: averages; fmt: 'o'; color: theme textColor).

	chart addDecoration: (RSHorizontalTick new fromNames: valuesOfSelectedVariable).
	chart addDecoration: (RSVerticalTick new numberOfTicks: 10; asFloat).
	chart title: nameOfBenchmark.
	chart xlabel: selectedVariable.
	chart ylabel: 'Time (ms)'.

]

{ #category : #accessing }
RSBenchChartBuilder >> chart [

	^ chart
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
	
	valuesOfSelectedVariable := OrderedCollection new.
	averages := OrderedCollection new.
	mins := OrderedCollection new.
	maxs := OrderedCollection new.
	errors := OrderedCollection new.

	rawData do: [ :each | self processRawDataItem: each ].

]

{ #category : #private }
RSBenchChartBuilder >> processRawDataItem: each [

	| totalTimes benchResults |
	valuesOfSelectedVariable add: (each key at: selectedVariable).

	benchResults := each value results at: nameOfBenchmark.
	totalTimes := statsReporter totalResultsFor: benchResults.
"	totalTimes := benchResults collect: [ :result | (result criteria at: 'total') totalTime ]."
	errors add: (statsReporter confidenceVariance: totalTimes).
	averages add: totalTimes average asFloat.
	mins add: totalTimes min.
	maxs add: totalTimes max
]

{ #category : #initialization }
RSBenchChartBuilder >> rawData: aCollection [
	rawData := aCollection
]

{ #category : #initialization }
RSBenchChartBuilder >> selectedVariable: aSelector [
	selectedVariable := aSelector
]
