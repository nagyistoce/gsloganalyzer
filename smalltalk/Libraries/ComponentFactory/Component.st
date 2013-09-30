" -*- mode: smalltalk -*- "

Object subclass: Component [
    | metadict |

    <comment: 'I describe metadata for a Package that provides a Component'> 
    <category: 'LogAnalyzer-Components'>

    Component class >> new [

	<category: 'instance creation'>
	^ self basicNew initialize
    ]
    
    initialize [

	<category: 'initialize-release'>
	metadict := Dictionary new.
    ]
    
    name [
	
	<category: 'accessing'>
	^ metadict at: #name
    ]

    name: aString [

	<category: 'accessing'>
	metadict at: #name put: aString
    ]
    
    description [

	<category: 'accessing'>
	^ metadict at: #description
    ]
    
    methodsAndTypes [

	<category: 'accessing'>
	^ metadict at: #methodsAndTypes
    ]

    entryClass [

	<category: 'accessing'>
	^ metadict at: #entryClass
    ]

    load [
	| p |
	<category: 'accessing'>
	metadict at: #pl put: (PackageLoader fileInPackage: self name).
    ]


]
