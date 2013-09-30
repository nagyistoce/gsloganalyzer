" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

Object subclass: AbstractComponentTestClass [

    <comment: 'I am a test class for component loading. I should be part of an SUnit test'>
    <category: 'LogAnalyzer-tests'>

    AbstractComponentTestClass class >> new [
	" Standard instance creation method "

	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    initialize [
	" Does nothing, just returns self "

	<category: 'initialize-release'>
	^ self
    ]

    key1 [
	<category: 'accessing'>
	^ 'key1'
    ]
    
    key2 [
	<category: 'accessing'>
	^ 2
    ]
    
    key3 [
	<category: 'accessing'>
	^ Dictionary new
    ]
]
