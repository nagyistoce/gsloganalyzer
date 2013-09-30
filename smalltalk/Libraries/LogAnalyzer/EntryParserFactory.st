" -*- smalltalk -*- "
Object subclass: EntryParserFactory [
| parsers logtype |
<comment: 'I am responsible for creating configured LogEntryParsers for the logType asked for'>
<category: 'LogAnalyzer-Library'>

    EntryParserFactory class >> new [
	<category: 'instance creation'>
	^ self shouldNotImplement
    ]

    EntryParserFactory class >> withLogType: aType [
	| t |
	<category: 'instance creation'>
	t := self basicNew initialize.
	t logType: aType.
	^ t
    ]

    EntryParserFactory class >> knownParsers [
	| t |
	<category: 'utilities'>
	<comment: 'I will return all classes that implements parsesLogType class method'>
	t := Object selectSubclasses: [:each | (each selectors) includes: #parsesLogType ].
	^ t
    ]

    initialize [
	<category: 'initialize-release'>
	^ self
    ]

    logType: aString [
	<category: 'accessing'>
	logtype:= aString.
    ]

    logType [
	<category: 'accessing'>
	^logtype.
    ]
]
