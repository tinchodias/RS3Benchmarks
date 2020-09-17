Class {
	#name : #RSMetricProviderBenchs,
	#superclass : #RSBenchs,
	#instVars : [
		'metricProviderClass',
		'stringSelector'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #running }
RSMetricProviderBenchs >> allMetricProviderClasses [

	^ {RSCairoFitMetricsProvider. RSPharoMetricsProvider. RSCairoMetricsProvider. RSCairoCachedMetricsProvider}
]

{ #category : #running }
RSMetricProviderBenchs >> allStringSelectors [

	^ { #stringDiverse. #stringRandom. #stringWithSameLetter. #stringLoremIpsum }
]

{ #category : #benchmarking }
RSMetricProviderBenchs >> benchLabels [

	| aRSCanvas morph form metricProvider labelString |
	aRSCanvas := RSCanvas new.
	metricProvider := metricProviderClass new.
	labelString := self perform: stringSelector.

	1 to: 1000 do: [ :i |
		aRSCanvas add:
			(RSLabel new
				metricsProvider: metricProvider;
				model: i;
				fontSize: 8 + (i % 16);
				text: labelString;
				yourself) ].

	RSFlowLayout on: aRSCanvas nodes.

	morph := aRSCanvas createMorph.
	form := FormCanvas extent: morph extent.
	10 timesRepeat: [ morph drawOn: form ]
]

{ #category : #accessing }
RSMetricProviderBenchs >> customParameters [ 
	^ #(metricProviderClass stringSelector)
]

{ #category : #examples }
RSMetricProviderBenchs >> exampleFuel [
	"Example of how to serialize and materialize results."

	<script: 'self new exampleFuel'>

	| results fileName materializedResults |

	"Generate results by running the benchmarks"
	results := RSMetricProviderBenchs new runAll.

	fileName := 'hola.benchs.fuel'.
	fileName asFileReference ensureDeleteFile.

	"Write results to image directory"
	FLSerializer serialize: results toFileNamed: fileName.

	"Read results from the file name in image directory"
	materializedResults := (FLMaterializer materializeFromFileNamed: fileName).

	(RSBenchChartBuilder new
		rawData: materializedResults;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(metricProviderClass stringSelector);
		build;
		chart) open

]

{ #category : #accessing }
RSMetricProviderBenchs >> metricProviderClass [
	^ metricProviderClass
]

{ #category : #accessing }
RSMetricProviderBenchs >> metricProviderClass: anObject [
	metricProviderClass := anObject
]

{ #category : #running }
RSMetricProviderBenchs >> runAll [

	| results |
	results := OrderedCollection new.
	
	self allMetricProviderClasses
		do: [ :providerClass |

			self allStringSelectors
				do: [ :selector |
					stringSelector := selector.
					metricProviderClass := providerClass.
					self class defaultRunner execute: self with: 15.
					results add: (self customParametersAndValues -> runner) ] 
				displayingProgress: [ :selector | 'Benchmarking ', selector ] ]

		displayingProgress: [ :each | 'Benchmarking ', each asString ].
	
	^ results
]

{ #category : #running }
RSMetricProviderBenchs >> stringDiverse [

	^ String streamContents: [ :s | 
		  1 to: 255 do: [ :i | s nextPut: (Character codePoint: i) ] ]
]

{ #category : #running }
RSMetricProviderBenchs >> stringLoremIpsum [

	^ String loremIpsum: 255
]

{ #category : #running }
RSMetricProviderBenchs >> stringRandom [

	^ String streamContents: [ :s |
		1 to: 255 do: [ :i |
			s nextPut: (Character codePoint: (SharedRandom globalGenerator nextInt: i))] ].

]

{ #category : #accessing }
RSMetricProviderBenchs >> stringSelector [
	^ stringSelector
]

{ #category : #accessing }
RSMetricProviderBenchs >> stringSelector: aSymbol [
	stringSelector := aSymbol
]

{ #category : #running }
RSMetricProviderBenchs >> stringWithSameLetter [

	^ String streamContents: [ :s | 1 to: 255 do: [ :i | s nextPut: $A ] ]
]
