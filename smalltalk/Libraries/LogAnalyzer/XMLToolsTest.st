" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

Object subclass: MockXMLToolsTestClass [

    <comment: nil>
    <category: 'LogAnalyzer-Tests-Mocks'>

    MockXMLToolsTestClass class >> new [

	<category: 'instance creation'>
	^ super new initialize
    ]

    initialize [
	
	<category: 'initialize-release'>

    ]

    selectorParameter1: arg1 parameter2: arg2 parameter3: arg3 [
	^ OrderedCollection new  
	    add: arg1; 
	    add: arg2; 
	    add: arg3;
	    yourself
    ]

    selector: arg1 [
	^ OrderedCollection new 
	    add: arg1; 
	    yourself
    ]

    selectorParameter1: arg1 parameter2: arg2 value: arg3 [
	^ OrderedCollection new
	    add: arg1; 
	    add: arg2;
	    add: arg3;
	    yourself
    ]

    selector [
	^ true
    ]
    
    selector: arg1 [
	^ OrderedCollection new 
	    add: arg1;
	    yourself
    ]

]

TestCase subclass: XMLToolsTest [
| testXML1 testXML2 testXML3 testXMLfile mock |

    <comment: nil>
    <category: 'LogAnalyzer-Tests-XMLTools'>

    setUp [
	| f s |
        <category: 'running'>
	[ 
	    f := FileStream open: 'AbstractDefinitions.xml' 
	                    mode: FileStream read.
	  s := f contents.
	] ensure: [ f close ].
	testXMLfile  := XML.SAXParser defaultParserClass 
	    processDocumentString: s beforeScanDo: [ :p | p validate: false ].
	
	testXML1 := XML.SAXParser defaultParserClass 
	    processDocumentString: '<selector parameter1="argument1" parameter2="argument2" parameter3="argument3" />' 
	    beforeScanDo: [ :p | p validate: false ].
	
	testXML2 := XML.SAXParser defaultParserClass 
	    processDocumentString: '<selector>argument1</selector>' 
	    beforeScanDo: [ :p | p validate: false ].

	testXML3 := XML.SAXParser defaultParserClass 
	    processDocumentString: '<selector parameter1="argument1" parameter2="argument2">argument3</selector>' 
	    beforeScanDo: [ :p | p validate: false ].

	mock := MockXMLToolsTestClass new.
    ]
    
    testSelectorWith3AttributesFromElement [
	| a r |
	a := XMLTools selectorFromElement: testXML1 root.
	self should: [
	    r :=  mock perform: (a key) withArguments: (a value).
	    ((r at: 1) = 'argument1') & 
		((r at: 2) = 'argument2') & 
		((r at: 3) = 'argument3')
	   ]
    ]

    testSelectorWithCharacterData [
	| a r |
	a := XMLTools selectorFromElement: testXML2 root.

	self should: [
	    r := mock perform: (a key) withArguments: (a value).
	    (r at: 1) = 'argument1'
	]
    ]
    
    testSelectorWith2AttributesAndText [
	| a r |
	a := XMLTools selectorFromElement: testXML3 root.

	self should: [
	    r := mock perform: (a key) withArguments: (a value).
	    ((r at: 1) = 'argument1') & 
		((r at: 2) = 'argument2') &
		((r at: 3) = 'argument3')
	]
    ]

]
