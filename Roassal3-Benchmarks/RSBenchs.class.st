"
Abstract class with some benchmarks for roassal3
"
Class {
	#name : #RSBenchs,
	#superclass : #SMarkSuite,
	#category : #'Roassal3-Benchmarks'
}

{ #category : #accessing }
RSBenchs >> customParameters [ 
	^ #()
]

{ #category : #accessing }
RSBenchs >> customParametersAndValues [

	| dictionary |
	dictionary := SmallDictionary new.
	self customParametersAndValuesDo: [ :key :value | 
		dictionary at: key put: value ].
	^ dictionary
]

{ #category : #accessing }
RSBenchs >> customParametersAndValuesDo: aFullBlockClosure [ 

	self customParameters do: [ :each |
		aFullBlockClosure
			value: each
			value: (self perform: each) ]

]

{ #category : #initialization }
RSBenchs >> instanceVariablesToPreserve [

	^ super instanceVariablesToPreserve, self customParameters
]
