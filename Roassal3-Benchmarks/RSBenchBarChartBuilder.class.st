"
For bar plots with RSMetricsProviderBenchs
"
Class {
	#name : #RSBenchBarChartBuilder,
	#superclass : #RSBenchChartBuilder,
	#instVars : [
		'providers'
	],
	#category : #'Roassal3-Benchmarks'
}

{ #category : #private }
RSBenchBarChartBuilder >> buildChart [
	| canvas y vertical lb size |
	
	chart := RSChart new.
	chart extent: 400@200.
	canvas := chart canvas.
	
	lb := RSLegend new.
	lb container: canvas.
	lb defaultLabel color: Color white; fontSize: 8.
	size := 15.
	providers keys doWithIndex: [ :k :index |
		| plot v |
		v := providers at: k.
		
		y := horizontalNames collect: [ :name | v at: name ] as: Array.
		plot := chart barHeights: y.
		plot barSize: size.
		plot barOffset: ((index-(providers size+1/ 2)) * (size+3) ).
		lb text: k withBoxColor: plot computeColor.
		 ].
	
	chart addDecoration: (RSHorizontalTick new fromNames: horizontalNames; labelRotation: 0).
	chart addDecoration: (vertical := RSVerticalTick new numberOfTicks: 5; integer).
	vertical shape 
		width: 0.5;
		capRound;
		dashArray: #(2 4).
	
	vertical configuration
		tickSize: -400.
	chart ylabel: 'TIME (ms) less is better'.
	chart build.
	canvas color: Color black.
	canvas shapes first borderColor: Color black.
	canvas shapes allButFirst
		reject: [ :s | s class = RSBox ]
		thenDo: [ :shape | shape color: Color white ].
	
	
	lb legendDo: [ :s | s border: (RSBorder new color: Color white); padding: 10 ].
	lb location offset: 0@ 20.
	lb build.
	
	chart plots do: [ :plot | 
		plot bars doWithIndex: [ :shape :index |
			| rectangle |
			rectangle := shape encompassingRectangle.
			shape height: 0.
			canvas newAnimation
				easing: RSEasing circleOut;
				delay: (index * 300) milliSeconds;
				duration: 2 second;
				from: rectangle origin x @ rectangle corner y;
				to: rectangle origin;
				onStepDo: [ :point |
					shape fromRectangle: (point corner: rectangle corner) ]
				
			 ].
		 ].
	chart := canvas.
	


]

{ #category : #'as yet unclassified' }
RSBenchBarChartBuilder >> exampleFile [
	<script: 'self new exampleFile'>
	| fileName materializedResults |
	fileName := '.' asFileReference files select: [ :file | file basename endsWith: 'fuel' ].
	fileName ifEmpty: [ self error: 'use createANewBench first' ].
	fileName := fileName first basename.
	
	materializedResults := (FLMaterializer materializeFromFileNamed: fileName).
	(self
		rawData: materializedResults;
		nameOfBenchmark: 'Labels';
		selectedCustomParameters: #(metricProviderClass stringSelector);
		build;
		chart
		) open
		setLabel: 'Metrics providers for Roassal3';
		extent: 800@600.
]

{ #category : #private }
RSBenchBarChartBuilder >> processRawData [
	providers := Dictionary new.
	horizontalNames := Set new.
	rawData do: [ :each | 
		| key row benchResults totalTimes name |
		key := each key at: #metricProviderClass.
		row := providers at: key ifAbsentPut: [ Dictionary new ].
		name := each key at: #stringSelector.
		horizontalNames add: name.
		benchResults := each value results at: #Labels.
		totalTimes := statsReporter totalResultsFor: benchResults.
		row at: name put: totalTimes average asFloat.
		].
	horizontalNames := horizontalNames asArray.
	
	

]
