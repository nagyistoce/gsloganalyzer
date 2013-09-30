" -*- mode: smalltalk -*- "
" This class is using symbols as keys and will convert anything ID to symbols "
Object subclass: ComponentRegistry [
    
    <comment: 'I keep all the registries'>
    <category: 'LogAnalyzer-Base'>

    reg := Dictionary new.

    ComponentRegistry class >> convertStringOrClassToSymbol: anObject [
	| t |
	<category: 'private'>
	(anObject isSymbol | anObject isString ) ifFalse: [
	    t := anObject class printString asSymbol. 
	] ifTrue: [
	    t := anObject asSymbol.
	].
	^ t
    ]

    ComponentRegistry class >> new [

	<category: 'instance creation'>
	Logger logError: 'New should not be called'.
	^ self shouldNotImplement
    ]

    ComponentRegistry class >> withID: anObject [
	| s |
	" convenience method for lazily create registries "

 	<category: 'instance creation'>
	s := self convertStringOrClassToSymbol: anObject.
	Logger logDebug: 'Added ',s,' to the ComponentRegistry'.
	^ reg at: s ifAbsentPut: [ Dictionary new ]
    ]

    ComponentRegistry class >> withID: anObject hasName: anInstanceString [
	| s |
	" Test if a registry has a specific named definition "

	<category: 'testing'>
	s := self convertStringOrClassToSymbol: anObject.
	^ (reg at: s ifPresent: [:v | v includesKey: anInstanceString ]) ifNil: [false]

    ]

    ComponentRegistry class >> reset [
	" Drops the internal dictionary and creates a new ontop of it "

	<category: 'configuration'>
	reg := Dictionary new.
    ]

    ComponentRegistry class >> withID: anObject definitionForName: anInstanceString [
	| s |
	" returns the registered Definition or nil if missing "

	<category: 'accessing'>
	s := self convertStringOrClassToSymbol: anObject.
	^ reg at: s ifPresent: [:v | v at: anInstanceString ifAbsent: [nil]].
    ]
    
    ComponentRegistry class >> registerObject: anObject [
	| t s |
	" registers the instance in the instance class registry for the key instance name "

	<category: 'accessing'>
	s := self convertStringOrClassToSymbol: anObject.
	t := self withID: s.
	(anObject respondsTo: #name) ifTrue: [
	    Logger logDebug: 'Added ',anObject name,' to ComponentRegistry ',s. 
	    ^ t at: anObject name ifAbsentPut: [ anObject ]
	].
	^ nil
    ]
    
]

