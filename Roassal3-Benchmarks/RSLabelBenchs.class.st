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
			         fontSize: i;
			         text: text;
			         model: i;
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

{ #category : #benchmarking }
RSLabelBenchs >> defaultNumberOfIterations [
	^ 15
]

{ #category : #benchmarking }
RSLabelBenchs >> defaultNumberOfLabels [

	^ 50
]

{ #category : #benchmarking }
RSLabelBenchs >> defaultNumberOfRenderings [

	^ 30 * 10
]

{ #category : #benchmarking }
RSLabelBenchs >> instanceVariablesToPreserve [

	^ super instanceVariablesToPreserve, #(numberOfLabels numberOfRenderings)
]

{ #category : #benchmarking }
RSLabelBenchs >> runFor: aNumberOfIterations [

	^ self class defaultRunner 
		execute: self
		with: aNumberOfIterations
]

{ #category : #benchmarking }
RSLabelBenchs >> runOnNumberOfLabels [
	<script: 'self new runOnNumberOfLabels inspect'>

	| reportByParameter |
	numberOfRenderings := self defaultNumberOfRenderings.

	reportByParameter := OrderedDictionary new.
	(10 to: self defaultNumberOfLabels by: 10) do: [ :each |
		numberOfLabels := each.
		reportByParameter
			at: each
			put: (self runFor: self defaultNumberOfIterations) report ].
	
	^ reportByParameter
]
