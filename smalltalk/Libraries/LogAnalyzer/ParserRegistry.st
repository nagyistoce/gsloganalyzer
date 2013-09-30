" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "
"
A LogParser is defined using the following attributes:
name
extends
logtype
extendslogtype
requires
optional
description

-extends- defines what other LogParser this one extends. If undefined, is it considered as a base parser
-logtype- defines what type of log the parser can work on. If undefined is it considered as a general parser
-extendslogtype- defines what other logtype this parser extends.
-requires- defines what other parser this one needs to function. If it is extending a parser, 
that is considered required.
-optional- defines parsers that is preferred and wanted, but not necessery for the parser to work
-description- describes the function of the parser.
-name- is the unique name of the parser
"
Object subclass: ParserRegistry [
    
    Parsers := Dictionary new.

    <comment: 'I maintain all known parsers and their relations. 
               I am yet another singleton class.
               In the future will I use a proper ConfigStore backend'>
    <category: 'LogAnalyzer-Parsers'>

    ParserRegistry class >> new [
	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    ParserRegistry class >> forgetAll [
	<category: 'class accessing'>
	Parser := Dictionary new.
    ]
    
    ParserRegistry class >> registry [
	<category: 'class accessing'>
	^ Parsers
    ]

    ParserRegistry class >> register: aParser [
	<category: 'class accessing'>
	Parsers at: (aParser name) put: aParser.
    ]

    ParserRegistry class >> registeredWithName: aString [
	<category: 'class accessing'>
	^ Parsers at: aString ifAbsent: [ nil ]
    ]

    initialize [
	<category: 'initialize-release'>
    ]
]
