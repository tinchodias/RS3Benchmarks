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
RSBenchBarChartBuilder >> addAnimation: canvas [
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
				onStepDo:
						[ :point | shape fromRectangle: (point corner: rectangle corner) ] ] ]
]

{ #category : #private }
RSBenchBarChartBuilder >> addErrorLines [
	| canvas lines |
	canvas := chart container.
	lines := OrderedCollection new.
	providers keys doWithIndex: [ :key :index |
		| errorDic errorRow plot lineTop lineBot sideLine |
		errorDic := errors at: key.
		errorRow := horizontalNames collect: [ :name | errorDic at: name ].
		plot := chart plots at: index.
		plot bars with: errorRow do: [ :shape :errNumber | 
			| line from to originPoint transformedPoint |
			transformedPoint := 0@ (plot yScale scale: errNumber) - (plot yScale scale: 0).
			originPoint := shape encompassingRectangle topCenter.
			from := originPoint + transformedPoint.
			to := originPoint - transformedPoint.
			line := RSLine new
				startPoint: from;
				endPoint: to;
				yourself.
			sideLine := plot barSize * 0.4 @ 0.
			lineTop := RSLine new
				startPoint: from + sideLine;
				endPoint: from - sideLine;
				yourself.
			lineBot := RSLine new
				startPoint: to + sideLine;
				endPoint: to - sideLine;
				yourself.
			lines add: line; add: lineTop; add: lineBot
			 ].
		 ].
	lines do: [ :line | line color: Color transparent ].
	canvas addAll: lines.
	canvas newAnimation
		delay: 2 seconds;
		from: Color transparent;
		to: Color white;
		onStepDo: [ :t |
			lines do: [ :line | line color: t ]
		].
]

{ #category : #private }
RSBenchBarChartBuilder >> buildChart [
	| canvas y vertical lb size |
	chart := RSChart new.
	chart extent: 400 @ 200.
	canvas := chart canvas.
	lb := RSLegend new.
	lb container: canvas.
	lb defaultLabel
		color: Color white;
		fontSize: 8.
	size := 15.
	providers keys
		doWithIndex: [ :k :index | 
			| plot v |
			v := providers at: k.
			y := horizontalNames collect: [ :name | v at: name ] as: Array.
			plot := chart barHeights: y.
			plot shape cornerRadius: 3.
			plot barSize: size.
			plot barOffset: (index - ((providers size + 1) / 2)) * (size + 3).
			lb text: k withBoxColor: plot computeColor ].
	chart
		addDecoration:
			(RSHorizontalTick new
				fromNames: horizontalNames;
				labelRotation: 0).
	chart
		addDecoration:
			(vertical := RSVerticalTick new
				numberOfTicks: 5;
				integer).
	vertical shape
		width: 0.5;
		capRound;
		dashArray: #(2 4).
	vertical configuration tickSize: -400.
	chart ylabel: 'TIME (ms) less is better'.
	chart build.
	
	canvas color: Color black.
	canvas shapes first borderColor: Color black.
	canvas shapes allButFirst
		reject: [ :s | s class = RSBox ]
		thenDo: [ :shape | shape color: Color white ].
	lb
		legendDo: [ :s | 
			s
				border: (RSBorder new color: Color white);
				padding: 10 ].
	lb location offset: 0 @ 20.
	lb build.
	self addErrorLines.
	self addAnimation: canvas.
	chart := canvas
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
	errors := Dictionary new.
	rawData do: [ :each | 
		| key row benchResults totalTimes name rowError |
		key := each key at: #metricProviderClass.
		row := providers at: key ifAbsentPut: [ Dictionary new ].
		rowError := errors at: key ifAbsentPut: [ Dictionary new ].
		name := each key at: #stringSelector.
		horizontalNames add: name.
		benchResults := each value results at: #Labels.
		totalTimes := statsReporter totalResultsFor: benchResults.
		row at: name put: totalTimes average asFloat.
		rowError at: name put: (statsReporter confidenceVariance: totalTimes).
		].
	horizontalNames := horizontalNames asSortedCollection.
	
	

]
