" -*- smalltalk -*- "
Object subclass: BaseLogAnalyzer [
    | factories logTypeParsers genericParsers logSinks collectors |
     logAnalyzer := nil. 
    <comment: 'I am responsible for setting up Factories for specified logTypes and provide facilities to drive log parsing'>
    <category: 'LogAnalyzer-Library'>

    BaseLogAnalyzer class >> new [
	<category: 'instance creation'>
	^ logAnalyzer ifNil: [
	    logAnalyzer := super new initialize
	]
    ]

    BaseLogAnalyzer class >> logAnalyzer [
	<category: 'instance creation'>
	^ logAnalyzer ifNil: [
	    self new
	]
    ]

    initialize [
	<category: 'initialize-release'>
	logTypeParsers := LogEntryParserRegistry sharedRegistry.
	factories := OrderedCollection new.
	genericParsers := Dictionary new.
	collectors := Dictionary new.
	logSinks := Dictionary new.
    ^ self
    ]
]
