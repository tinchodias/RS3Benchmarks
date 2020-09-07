# RS3Benchmarks
Benchmark suites to profile performance of [Roassal3](https://github.com/objectprofile/roassal3).

This project uses https://github.com/smarr/SMark to run and report benchmarks.

## Installation
First, load Roassal3.

```Smalltalk
Metacello new
	baseline: 'Roassal3';
	repository: 'github://ObjectProfile/Roassal3';
	load.
```

Second, load the benchmarks.
```Smalltalk
Metacello new
	baseline: 'RS3Benchmarks';
	repository: 'github://tinchodias/RS3Benchmarks';
	load
```

Note Roassal3 is not added as a dependency on purpose. The itention is to avoid loading confussions when benchmarking multiple versions of Roassal3. This way, the user will explicitely choose which version is being measured.

## How to use

### Visual version

Evaluate:

```Smalltalk
RSBenchChartBuilder exampleOnNumberOfLabels
```

### Text version

Evaluate:

```Smalltalk
RSLabelBenchs new runOnNumberOfLabels
```

You will find a series of results like this in Transcript:

```
a SmallDictionary(#numberOfLabels->1 #numberOfRenderings->100)
Report for: RSLabelBenchs
Benchmark Labels
Labels total: iterations=15 runtime: 5.7ms +/-1.9
```

## License
The code is licensed under [MIT](LICENSE).
