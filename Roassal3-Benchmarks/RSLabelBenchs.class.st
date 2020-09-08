Class {
	#name : #RSLabelBenchs,
	#superclass : #SMarkSuite,
	#instVars : [
		'numberOfLabels',
		'numberOfRenderings'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #benchmarking }
RSLabelBenchs >> benchLabels [

	| aRSCanvas text morph form |
	aRSCanvas := RSCanvas new.
	text := 'LP4_Genehmigungsplanungsheft'.

	1 to: numberOfLabels do: [ :i | 
		| box label |
		label := RSLabel new
			         model: i;
			         text: text;
			         yourself.

		box := RSBox new
			       extent: label width @ label height;
			       color: Color lightGray;
			       yourself.

		aRSCanvas add: box ].

	RSFlowLayout on: aRSCanvas shapes.

	morph := aRSCanvas createMorph.
	form := FormCanvas extent: morph extent.
	numberOfRenderings timesRepeat: [ morph drawOn: form ]
]

{ #category : #accessing }
RSLabelBenchs >> customParameters [ 
	^ #(numberOfLabels numberOfRenderings)
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
RSLabelBenchs >> defaultNumberOfIterations [
	"The default number of times that each benchmark will be executed."

	^ 30
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfLabels [

	^ 300
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfRenderings [

	^ 20
]

{ #category : #benchmarking }
RSLabelBenchs >> instanceVariablesToPreserve [

	^ super instanceVariablesToPreserve, self customParameters
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

{ #category : #benchmarking }
RSLabelBenchs >> runOnNumberOfLabels [
	"Run the benchmarks taking numberOfLabels as a variable. Print results on Transcript."

	<script: 'self new runOnNumberOfLabels inspect'>

	^ (1 to: self defaultNumberOfLabels * 3 by: 50) collect: [ :each |
		numberOfLabels := each.
		numberOfRenderings := self defaultNumberOfRenderings.

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

{ #category : #benchmarking }
RSLabelBenchs >> runOnNumberOfRenderings [
	<script: 'self new runOnNumberOfRenderings inspect'>

	^ (0 to: 5) collect: [ :each |
		numberOfLabels := self defaultNumberOfLabels.
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
