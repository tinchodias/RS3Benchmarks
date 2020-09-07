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

	| c text morph |
	c := RSCanvas new.
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

		c add: box ].

	RSFlowLayout on: c shapes.

	morph := c createMorph.
	numberOfRenderings timesRepeat: [ morph drawOnMockCanvas ]
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

	#(numberOfLabels numberOfRenderings) do: [ :each |
		aFullBlockClosure
			value: each
			value: (self perform: each) ]

]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfIterations [
	^ 15
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfLabels [

	^ 75
]

{ #category : #accessing }
RSLabelBenchs >> defaultNumberOfRenderings [

	^ 100
]

{ #category : #benchmarking }
RSLabelBenchs >> instanceVariablesToPreserve [

	^ super instanceVariablesToPreserve, #(numberOfLabels numberOfRenderings)
]

{ #category : #accessing }
RSLabelBenchs >> numberOfLabels [
	^ numberOfLabels
]

{ #category : #accessing }
RSLabelBenchs >> numberOfLabels: anObject [
	numberOfLabels := anObject
]

{ #category : #accessing }
RSLabelBenchs >> numberOfRenderings [
	^ numberOfRenderings
]

{ #category : #accessing }
RSLabelBenchs >> numberOfRenderings: anObject [
	numberOfRenderings := anObject
]

{ #category : #benchmarking }
RSLabelBenchs >> runOnNumberOfLabels [
	"Run the benchmarks taking numberOfLabels as a variable. Print results on Transcript."

	<script: 'self new runOnNumberOfLabels inspect'>

	^ (1 to: self defaultNumberOfLabels by: 5) collect: [ :each |
		| customParametersAndValues |

		numberOfLabels := each.
		numberOfRenderings := self defaultNumberOfRenderings.

		"Calculate current parameters: they will be cleaned after execute:with: below."
		customParametersAndValues := self customParametersAndValues.

		"Run the benchmarks with these custom parameters"
		self class defaultRunner 
			execute: self
			with: self defaultNumberOfIterations.

		"Print on Transcript"
		customParametersAndValues traceCr.
		runner reportOn: Transcript.

		"Value to collect"
		self customParametersAndValues -> runner ]

]
