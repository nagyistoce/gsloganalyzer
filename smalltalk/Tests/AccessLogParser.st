" -*- mode: smalltalk -*- "

" Non dynamic version "

Object subclass: LogStream [
    | p b s |

    LogStream class >> newUsingParserClass: aClass [
	"Setup an instance parsing stdin"
	| c |
	c := super new initialize.
	c parser: aClass new.
	c stream: stdin.
	^ c
    ]
    
    
    parse [
	
    ]

    parser: aLogParser [
	|p |
	"sets a parser object that can parse the input into fields"
	<category: 'accessing'>
	p := aParser
    ]

    stream: aFileStream [
	<category: 'accessing-private'>
	s := aFileStream.
    ]

]

"Really unnecessery object since a plain OrderedCollection backing a Dictionary would do"
Object subclass: LogEntry [
    | fields |

    LogEntry class >> new [
	<category: 'instance creation'>
	^ super new initialize
    ]

    initialize [p4
