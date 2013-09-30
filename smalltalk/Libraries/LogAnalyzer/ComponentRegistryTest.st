" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

Object subclass: MockComponentBaseClass [

    <comment: 'Mock component to test the Component registry '>
    <category: 'LogAnalyzer-Test-Components'>

    
    MockComponentBaseClass >> new [

	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    initialize [

    ]

    name [
	^ self class printString
    ]
]

MockComponentBaseClass subclass: MockComponentSubClass [

    <comment: 'Mock component to test the Component registry '>
    <category: 'LogAnalyzer-Test-Components'>

    
    MockComponentSubClass >> new [

	<category: 'instance creation'>
	^ super new initialize
    ]
    

]

MockComponentSubClass subclass: MockComponentClass [
    | n |
    <comment: 'Mock component to test the Component registry '>
    <category: 'LogAnalyzer-Test-Components'>

    
    MockComponentClass >> new [

	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    name [
	^ n
    ]
    
    name: aString [
	n := aString.
    ]
]


TestCase subclass: ComponentRegistryTest [
    | mock1 mock2 mockbase mocksub |

    <comment: nil>
    <category: 'LogAnalyzer-Tests-Components'>

    setUp [
	| f |
        <category: 'running'>
	mockbase := MockComponentBaseClass new.
	mock1 := MockComponentClass new.
	mock1 name: 'Mock1'.
	mock2 := MockComponentClass new.
	mock2 name: 'Mock2'.
    ]

    tearDown [
	
	<category: 'running'>
	" Debug stuff 
	Transcript show: '---- [ DEBUG ] -----';cr.
	ComponentRegistry.reg keysAndValuesDo: [:k :v | 
	    Transcript show: k printString,' - ', v class printString;cr.].
	ComponentRegistry.reg inspect.
	Transcript show: '-------------- -----';cr.
	 "
        ComponentRegistry reset.
    ]
    
    testWithIDString [
	ComponentRegistry withID: 'testregistry'.
	self should: [ 
	    (ComponentRegistry.reg includesKey: #testregistry) &
	    ((ComponentRegistry.reg at: #testregistry) class == Dictionary)
	    ]. 
    ]
    
    testWithIDSymbol [
	ComponentRegistry withID: #testregistry.
	self should: [
	    (ComponentRegistry.reg includesKey: #testregistry) & 
           ((ComponentRegistry.reg at: #testregistry) class = Dictionary) 
	].
    ]

    testWithObject [

	ComponentRegistry registerObject: mock1.
	ComponentRegistry registerObject: mock2.
	self should: [
	    ((ComponentRegistry withID: #MockComponentClass) includesKey: 'Mock1') &
	    (((ComponentRegistry withID: #MockComponentClass) at: 'Mock1') class = MockComponentClass) &
	    ((ComponentRegistry withID: #MockComponentClass) includesKey: 'Mock2') &
	    (((ComponentRegistry withID: #MockComponentClass) at: 'Mock2') class = MockComponentClass)
	].
    ]
    	 
    testWithIDdefinitionForName [

	ComponentRegistry registerObject: mock1.
	self should: [
	    (ComponentRegistry withID: mock1  
			       definitionForName: 'Mock1') == mock1
	].
    ]

    testWithIDhasName [

	ComponentRegistry registerObject: mock1.
	ComponentRegistry registerObject: mock2.
	self should: [
	    (ComponentRegistry withID: #MockComponentClass hasName: 'Mock1') &
	    (ComponentRegistry withID: #MockComponentClass hasName: 'Mock2')
	].
    ]

    testReset [

	ComponentRegistry reset.
	self should: [
	    (ComponentRegistry.reg size) == 0
	].
    ]
]
