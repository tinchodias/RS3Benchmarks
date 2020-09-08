Class {
	#name : #RSLabelBenchs,
	#superclass : #SMarkSuite,
	#instVars : [
		'numberOfLabels',
		'numberOfRenderings',
		'layoutSelector'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #accessing }
RSLabelBenchs >> applyFlowLayout: aRSCanvas [

	RSFlowLayout on: aRSCanvas shapes
]

{ #category : #accessing }
RSLabelBenchs >> applyForceBasedLayout: aRSCanvas [

	RSForceBasedLayout new
		doNotUseProgressBar;
		charge: -500;
		on: aRSCanvas nodes
]

{ #category : #accessing }
RSLabelBenchs >> applyGridLayout: aRSCanvas [

	RSGridLayout on: aRSCanvas shapes
]

{ #category : #accessing }
RSLabelBenchs >> applyNoLayout: _ [
	"Nothing"
]

{ #category : #benchmarking }
RSLabelBenchs >> benchLabels [

	| aRSCanvas morph form |
	aRSCanvas := RSCanvas new.

	"Add a number of labels"
	1 to: numberOfLabels do: [ :i | 
		aRSCanvas add: 
			(RSLabel new
	         model: i;
	         text: 'Label: ', i asString;
	         yourself) ].
	
	"Add edges between them"
	RSEdgeBuilder line
		shapes: aRSCanvas shapes;
		canvas: aRSCanvas;
		connectFrom: [ :n | n // 2 ].
	
	self perform: layoutSelector with: aRSCanvas.

	morph := aRSCanvas createMorph.
	form := FormCanvas extent: morph extent.
	numberOfRenderings timesRepeat: [ morph drawOn: form ]
]

{ #category : #accessing }
RSLabelBenchs >> customParameters [ 
	^ #(numberOfLabels numberOfRenderings layoutSelector)
]

{ #category : #accessing }
RSLabelBenchs >> customParametersAndValues [

	| dictionary |
	dictionary := SmallDictionary new.
	self customParametersAndValuesDo: [ :key :value | 
		dictionary at: key put: value ].
	^ dictionary
]

{ #category : #accessing }
RSLabelBenchs >> customParametersAndValuesDo: aFullBlockClosure [ 

	self customParameters do: [ :each |
		aFullBlockClosure
			value: each
			value: (self perform: each) ]

]

{ #category : #accessing }
RSLabelBenchs >> defaultLayoutSelector [

	^ #applyNoLayout:
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfIterations [
	"The default number of times that each benchmark will be executed."

	^ 10
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfLabels [

	^ 300
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfRenderings [

	^ 20
]

{ #category : #initialization }
RSLabelBenchs >> initialize [
	super initialize.
	
	numberOfRenderings := self defaultNumberOfRenderings.
	numberOfLabels := self defaultNumberOfLabels.
	layoutSelector := self defaultLayoutSelector.

]

{ #category : #initialization }
RSLabelBenchs >> instanceVariablesToPreserve [

	^ super instanceVariablesToPreserve, self customParameters
]

{ #category : #accessing }
RSLabelBenchs >> layoutSelector [
	^ layoutSelector
]

{ #category : #accessing }
RSLabelBenchs >> layoutSelector: aSymbol [
	layoutSelector := aSymbol
]

{ #category : #accessing }
RSLabelBenchs >> numberOfLabels [
	^ numberOfLabels
]

{ #category : #accessing }
RSLabelBenchs >> numberOfLabels: anInteger [
	numberOfLabels := anInteger
]

{ #category : #accessing }
RSLabelBenchs >> numberOfRenderings [
	^ numberOfRenderings
]

{ #category : #accessing }
RSLabelBenchs >> numberOfRenderings: anInteger [
	numberOfRenderings := anInteger
]

{ #category : #running }
RSLabelBenchs >> runLayoutSelector: aSymbol maxLabels: maxLabels [
	"Run the benchmarks using a determined layout, taking numberOfLabels as a variable. Print results on Transcript."

	layoutSelector := aSymbol.

	^ (10 to: maxLabels) collect: [ :each |
		numberOfLabels := each.

		"Run the benchmarks with these custom parameters"
		self class defaultRunner 
			execute: self
			with: self defaultNumberOfIterations.

		"Print on Transcript"
		self customParametersAndValues traceCr.
		runner reportOn: Transcript.

		"Value to collect"
		self customParametersAndValues -> runner ]

]

{ #category : #running }
RSLabelBenchs >> runOnNumberOfRenderings [

	^ (0 to: 20) collect: [ :each |
		numberOfRenderings := each.

		"Run the benchmarks with these custom parameters"
		self class defaultRunner 
			execute: self
			with: self defaultNumberOfIterations.

		"Print on Transcript"
		self customParametersAndValues traceCr.
		runner reportOn: Transcript.

		"Value to collect"
		self customParametersAndValues -> runner ]

]
