Class {
	#name : #BaselineOfRS3Benchmarks,
	#superclass : #BaselineOf,
	#category : #BaselineOfRS3Benchmarks
}

{ #category : #baseline }
BaselineOfRS3Benchmarks >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self
				"declareRoassal3On: spec;"
				declareSMarkOn: spec.

			spec
				package: 'Roassal3-Benchmarks' with: [ spec requires: #('Roassal3' 'SMark') ].
 ]
]

{ #category : #'external projects' }
BaselineOfRS3Benchmarks >> declareSMarkOn: spec [
	spec
		baseline: 'SMark'
		with: [ spec repository: 'github://smarr/SMark:v1.0.4/repository' ]
]
