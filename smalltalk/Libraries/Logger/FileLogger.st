" -*- mode: smalltalk; fill-column: 80 -*- "

AbstractLogger subclass: FileLogger [
    | filename fstream |

    FileLogger class >> new [
	| t |
	<category: 'instance creation'>
	t := self basicNew initialize.
	t initFileStream.
	^ t
    ]

    FileLogger class >> named: aString [
	| t |
	<category: 'instance creation'>
	t := self basicNew initialize.
	t filename: aString.
	t initFileStream.
	^ t
    ]

    filename: aString [
	
	<category: 'configuration'>
	filename := aString.
    ]

    filename [
	
	<category: 'accessing'>
	^ filename ifNil: ['application.log']
    ]
    
    initFileStream [
	
	<category: 'initialize-release'>
	fstream := FileStream open: self filename mode: FileStream write.
	self logStream: fstream.
    ]
]
