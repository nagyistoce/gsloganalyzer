" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

TestCase subclass: AbstractComponentDefinitionTest [
    | queryTermsComponentXML componentTestMultipleXML dependentComponentXML simpleComponentXML invalidSimpleComponentXML c1 c2 c3 c4 |

    <comment: nil>
    <category: 'LogAnalyzer-Tests-Components'>

    setUp [
	| f logger |
        <category: 'running'>
	logger := StdErrLogger new.
	logger logLevel: #Debug.
	Logger sharedInstance associateLogger: 'StandardErrorLogger' 
	                             forClass: 'ComponentRegistry'.
	Logger sharedInstance associateLogger: 'StandardErrorLogger' 
                                     forClass: 'AbstractComponentDefinition'.
        ComponentRegistry reset.
	[ 
	    f := FileStream open: 'AbstractDefinitions.xml' 
	                    mode: FileStream read.
	  componentTestMultipleXML := f contents.
	] ensure: [ f close ].

	c1 := AbstractComponentDefinition withName: 'c1'.
	c2 := AbstractComponentDefinition withName: 'c2'.
	c3 := AbstractComponentDefinition withName: 'c3'.

	simpleComponentXML := XML.SAXParser defaultParserClass
	    processDocumentString: '
<ComponentDefinition name="SimpleComponent" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="AbstractComponentTestClass.st" />
<description>I am a simple component</description>
</ComponentDefinition>'
	    beforeScanDo: [ :p | p validate: false ].

	invalidSimpleComponentXML := XML.SAXParser defaultParserClass
	    processDocumentString: '
<ComponentDefinition name="SimpleComponent" type="NotFoundDefinition">
<code className="AbstractComponentTestClass" path="AbstractComponentTestClass.st" />
<description>I am a simple component</description>
</ComponentDefinition>'
	    beforeScanDo: [ :p | p validate: false ].
	
	dependentComponentXML := XML.SAXParser defaultParserClass 
            processDocumentString: '
<ComponentDefinition name="ComponentB" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="AbstractComponentTestClass.st" />
<description>
Free text that describes the AbstractComponentDefinition
</description>
<dependent name="c1" relation="extends" validate="true" />
<dependent name="c2" relation="required" validate="true" />
<dependent name="c3" relation="optional" />
</ComponentDefinition>' 
	    beforeScanDo: [ :p | p validate: false ].
	
	queryTermsComponentXML := XML.SAXParser defaultParserClass
	    processDocumentString: '
<ComponentDefinition name="QueryTermsComponent" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="AbstractComponentTestClass.st" />
<description>I am a simple component</description>
<keywordDictionary>
<keyword name="key1" type="String" />
<keyword name="key2" type="Number" />
<keyword name="key3" type="Dictionary" />
</keywordDictionary>
</ComponentDefinition>
'
	    beforeScanDo: [ :p | p validate: false ].
    ]
    
    testDefaultRelations [
	self should: [
	    (c1 relations keys) includesAllOf: 
		 #(#extends #required #optional)
	]
    ]

    testSimpleXMLDefinition [
	| c |
	c := AbstractComponentDefinition 
	     fromXMLDefinition: simpleComponentXML.
	self should: [
	    (c class == AbstractComponentDefinition) &
		(c codeClassName = 'AbstractComponentTestClass') &
		(c codePath = 'AbstractComponentTestClass.st') &
		(c description = 'I am a simple component')
	]
    ]

    testInvalidSimpleXMLDefinition [
	| c |
	self shouldnt: [ 
	  (AbstractComponentDefinition 
             fromXMLDefinition: invalidSimpleComponentXML) class == 
		AbstractComponentDefinition ]
    ]

    testDependeniesExistance  [
	| c |
	c := AbstractComponentDefinition 
	     fromXMLDefinition: dependentComponentXML.
	self should: [ | deps |
	    deps := c dependencies.
	    (deps includesKey: #extends) &
	    (deps includesKey: #required) &
            (deps includesKey: #optional) &
            ((deps at: #extends) includesKey: 'c1') &
	    ((deps at: #required) includesKey: 'c2') &
            ((deps at: #optional) includesKey: 'c3')
	]
    ]

    testIsValid [
	| c |
	c := AbstractComponentDefinition fromXMLDefinition: dependentComponentXML.
	self should: [
	    c isValid = true
	]
    ]

    testQueryTermsXMLDefinition [
	| c |
	c := AbstractComponentDefinition 
	    fromXMLDefinition: queryTermsComponentXML.
	self should: [
	    ((c keyworddictionary) class = Dictionary) & 
		((c keyworddictionary) includesKey: 'key1') &
		((c keyworddictionary) includesKey: 'key2') &
		((c keyworddictionary) includesKey: 'key3')
	].
    ]
    
    ]


