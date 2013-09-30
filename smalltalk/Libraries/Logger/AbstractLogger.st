" -*- mode: smalltalk; fill-column: 80 -*- "

Object subclass: AbstractLogger [
    | levels currentLevel logStream loggerName msgHandler |

    <comment: 'I am a simple log framework to allow for some decent logging features'>
    <category: 'LogAnalyzer-Utils'>

    AbstractLogger class >> new [
	
	<category: 'instance creation'>
	^ self basicNew initialize; yourself
    ]

    AbstractLogger class >> withName: aString [
	| t |
	
	<category: 'instance creation'>
	t := super new initialize.
	t name: aString.
	^ t
    ]

    initialize [

	<category: 'initialize-release'>
	levels := #(#Debug #Info #Warning #Error).
	
	self logLevel: #Warning.
	self messageHandler: [ :m :l | 
	    logStream
		nextPut: $[;
		nextPutAll: l asString;
		nextPut: $];
		nextPutAll: '  ';
		nextPut: $[;
		nextPutAll: DateTime now printString;
		nextPut: $];
		nextPutAll: '  ';
		nextPutAll: m;
		nextPut: Character cr;
		nextPut: Character lf.
	].
    ]

    name [
	
	<category: 'accessing'>
	^ loggerName ifNil: ['unnamed']
    ]

    name: aString [

	<category: 'accessing'>
	loggerName := aString.
    ]

    messageHandler: aBlock [

	<category: 'configuration'>
	msgHandler := aBlock.
    ]

    logStream: aStream [

	<category: 'configuration'>
	logStream := aStream.
    ]

    logLevel: aSymbol [

	<category: 'configuration'>
	currentLevel := aSymbol.
    ]
    
    logLevels [

	<category: 'accessing'>
	^ levels 
    ]

    logLevel [
	
	<category: 'accessing'>
	^ currentLevel
    ]

    log: aString atLevel: aLevelSymbol [
	
	<category: 'printing'>
	((levels indexOf: aLevelSymbol) >= (levels indexOf: currentLevel)) ifTrue: [ 
	    msgHandler value: aString value: aLevelSymbol.
	].
    ]

    " TODO: Possibly convert these into a dnu handler instead "

    logWarning: aString [
	
	<category: 'printing'>
	self log: aString atLevel: #Warning.
    ]

    logError: aString [
	
	<category: 'printing'>
	self log: aString atLevel: #Error.
    ]

    logInfo: aString [
	
	<category: 'printing'>
	self log: aString atLevel: #Info.
    ]

    logDebug: aString [
	
	<category: 'printing'>
	self log: aString atLevel: #Debug.
    ]

    finalize [

	<category: 'initialize-release'>
	logStream close.
    ]

]


