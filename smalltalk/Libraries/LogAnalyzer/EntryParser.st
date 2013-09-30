" -*- smalltalk -*- "
Object subclass: EntryParser [
    | parsers logentry |
    <comment: 'I am responsible for calling parsers to parse different segments in an LogEntry'>
    <category: 'LogAnalyzer-Library'>

    EntryParser class >> new [
	<category: 'instance creation'>
	^ self basicNew initialize.
    ]

    initialize [
	<category: 'initialize-release'>
	parsers := OrderedCollection new.
    ]
]
