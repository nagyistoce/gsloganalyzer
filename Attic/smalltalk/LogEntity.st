" -*- Mode: smalltalk; Mode: auto-complete -*- "
Namespace current: LogAnalyzer [
Object subclass: LogEntity [
  | probability delimiterHandler level parser decendants ancestor |

    <comment: 'I am a decorated n-tree, carrying the smallest knowledge bearing piece in a log. 
This class should really be redesigned into tree-node structure at one point.'>
    <category: 'LogAnalyzer-Basic'>

    LogEntity class >> new [
	<category: 'instance creation'>
	^super new initialize
    ]

    initialize [
	<category: 'initialize-release'> 
	probability := 0.
	delimiterHandler := nil.
	parser := nil.
	level := 0.
	decendants := SortedCollection sortBlock: [ :x :y | x probability < y probability ].
    ]
    
    addDecendant: anLogEntity  [
	<category: 'accessing'>
	decendants add: anLogEntity.
	anLogEntity ancestor: self.
    ]
    
    removeDecendant: anLogEntity [
	<category: 'accessing'>
	decendants remove: anLogEntity.
    ]

    decendants [
	<category: 'accessing'>
	^decendants.
    ]

    decendants: aCollection [
	<category: 'accessing'>
	"Add all in a collection to the decendants array, adjusting their levels etc"
	aCollection do: [:ent | decendants addDecendant: ent].
    ]
    
    level: aLevel [
	<category: 'accessing'>
	level := aLevel.
	decendants do: [ :childLogEntity | childLogEntity level: (aLevel + 1) ].
    ]

    level [
	<category: 'accessing'>
	^level.
    ]

    probability: aFloat [
	<category: 'accessing'>
	probability := aFloat asFloat.
    ]

    probability [
	<category: 'accessing'>
	^probability.
    ]

    parse: aStream [
	| data tmpStream |
	<category: 'actions'>
	<comment: 'parse stream using the delimiterHandler and parser'>
    ]

    ancestor: anLogEntity [
	<category: 'accessing'>
	(ancestor isNil) ifFalse: [ancestor removeDecendant: self].
	ancestor := anLogEntity.
	self level: (ancestor level) + 1.
    ]

    parser: anObject [
	<category: 'configuration'>
	parser := anObject.
	]
    
    delimiterHandler: anObject [
	<category: 'configuration'>
	delimiterHandler := anObject.
    ]

    isRoot [
	<category: 'testing'> 
	^ancestor isNil.
    ]
    
    isLeaf [
	<category: 'testing'> 
   ^(decendants size)  < 1 
    ]
]
]


