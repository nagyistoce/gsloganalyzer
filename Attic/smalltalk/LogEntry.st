" -*- Mode: smalltalk; Mode: auto-complete -*- "
Namespace current: LogAnalyzer [
Object subclass: LogEntry [
    | entities matchtrees |

    <comment: 'I represent one LogEntry. I can be multiline or single line'>
    <category: 'LogAnalyzer-Basic'>

    LogEntry class >> new [
	<category: 'instance creation'>
	^super new initialize
    ]
    
    initialize [ 
	<category: 'Initialize-release'>
	entities := OrderedCollection new: 30.
	matchtrees := OrderedCollection new.
    ]
  ]
]
