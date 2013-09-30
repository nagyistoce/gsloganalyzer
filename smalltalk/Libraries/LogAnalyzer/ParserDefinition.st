" -*- mode: smalltalk;  mode: auto-complete -*- "

AbstractComponentDefinition subclass: ParserDefinition [
    | properties loaded |

    <comment: 'I define metadata and properties for a log Parser and relations to other Parsers.'>
    <category: 'LogAnalyzer-Parsers'>
    
    ParserDefinition class >> new [

	" This is the standard instance creation class method "

	<category: 'instance creation'>
	^self basicNew initialize.
    ]

    " Convenience methods "

]
