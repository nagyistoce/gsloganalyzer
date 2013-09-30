" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

Object subclass: AbstractComponentTest2Class [

    <comment: 'I am a test class for component loading. I should be part of an SUnit test'>
    <category: 'LogAnalyzer-tests'>

    AbstractComponentTest2Class class >> new [
	" Standard instance creation method "

	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    initialize [
	" Does nothing, just returns self "

	<category: 'initialize-release'>
	^ self
    ]
]
