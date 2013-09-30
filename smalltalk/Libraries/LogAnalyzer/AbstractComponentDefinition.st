" -*- mode: smalltalk; fill-column: 80; display-time-mode: on; mode: auto-complete -*- "
" TODO: 
Improve logging and loggers.
Make codePath URI's instead to allow for external off site code "

Object subclass: AbstractComponentDefinition [
    | properties relations |

    <comment: 'I am the base for all xDefinition classes'>
    <category: 'LogAnalyzer-Components'>

    registry := Dictionary new.

    AbstractComponentDefinition class >> new [

	<category: 'instance creation'>
	^ self basicNew initialize.
    ]

    AbstractComponentDefinition class >> fromXMLDefinition: anXMLElement [
	" Create an instance from the definition passed "

	<category: 'instance creation'>
	| c d |
	c := super new initialize.
	" Create the right type of object
	 (eventually destrying the base one above) "
	d := XMLTools selectorFromElement: anXMLElement root ignoreContent: true.
	c := c perform: (d key) withArguments: (d value).
	c ifNotNil: [ | commands |
			commands := (anXMLElement root elements) 
				 select: [:each | 
				     each class == XML.Element]. 
			commands do: [:each |
			    d := XMLTools selectorFromElement: each.
			    (d class = OrderedCollection ) ifFalse: [ 
				d := OrderedCollection new add: d; yourself. ].  
			    d do: [:each | c perform: (each key) withArguments: (each value) ].
			].
	].
	^ c
    ]

    AbstractComponentDefinition class >> fromXMLDocument: xDoc [
	" Create instance(s) from an XML definition "

    	<category:'instance creation'>
	| c |
	c := xDoc root elementsNamed: 'ComponentDefinition'.
	c inspect.
    ]

    AbstractComponentDefinition class >> withName: aString [

	<category: 'instance creation'>
	| t |
	t := super new initialize.
	t name: aString.
	registry at: aString put: t.
	^ t	
    ]

    initialize [
	<category: 'initialize-release'>
	properties := Dictionary new.
	properties
	    at: #name put: '';
	    at: #description put: '';
	    at: #dependencies put: Dictionary new;
	    at: #code put: Dictionary new;
	    at: #queryDictionary put: Dictionary new;
	    yourself.

	self initializeStandardRelations.
    ]

    initializeStandardRelations [

	<category: 'private'>
	| d |
        relations := Dictionary new.	
	relations 
	    at: #extends put: true;
	    at: #required put: true;
	    at: #optional put: false;
	    yourself.	    
	d := properties at: #dependencies.
	relations keysDo: [:each | d at: each put: Dictionary new].
    ]
    
    relations [

	<category: 'accessing'>
	^ relations
    ]
    
    isCodePathValid [

	<category: 'testing'>
	^ File exists: self codePath
    ]

    isValid [
	| v |

	<category: 'testing'>
	" Rules: If the relation in relations is marked as true must 
	 any dependency stored in that dictionary validate to true 
	 - regardless of its own validity setting.
	 If the relation in the relations dictionary is marked as false, 
	 must the dependency only validate to true if it is set for the 
	 specific dependent object. TODO: Clarify!
	 We are validating for meta data existance but it is cascading"
	v := true.
	self relations keysAndValuesDo: [ :relation :mustValidate | 
	    | dr drs |
	    dr := self dependenciesForRelation: relation.	
	    drs := self dependenciesForRelationsAsString: relation.
	    
	    Logger logDebug: 'In [',self name,'] validating dependency [',
		relation printString,':',mustValidate printString,
		'] for [',drs,']'.
	    
	    mustValidate ifTrue: [ 
		v := (dr keys includesAllOf: registry keys) and: [
		    dr keys allSatisfy: [:each | 
			(registry at: each) isValid ]
		].
		Logger logDebug: 'mustValidated collection returns: ', v printString.
	    ] 
			 ifFalse: [
			     | t |
			     " Only check for components that really are needed "
			     t := (dr select: [ :each | each = true ]).
			     (t size > 0) ifTrue: [ 
				 v := t detect: [:componentName |
				     " First test for existance then for validity "
				     ((registry includes: componentName) and: [
					 (registry at: componentName) isValid]).
				 ] ifNone: [ false ].
			     ].
			 ].
	].
	^ v
    ]
    
    name: aString [

	<category: 'accessing'>
	| r |
	properties at: #name put: aString.
    ]
    
    name [

	<category: 'accessing'>
	^ properties at: #name 
    ]

    description [

	<category: 'accessing'>
	^ properties at: #description
    ]
        
    registerRelation: aString shouldValidate: aBoolean [

	<category: 'configuration'>
  	relations at: aString put: aBoolean
    ]
    
    dependencies [

	<category: 'accessing'>
	^ properties at: #dependencies
    ]

    dependenciesForRelation: aSymbol [

	<category: 'accessing'>
	" Returns the dictionary for a specific relationship. 
	 If it does not exist will it be created "
	^ (self dependencies) at: aSymbol 
			      ifAbsentPut: [ 
				  self registerRelation: aSymbol shouldValidate: false.
				  Dictionary new ]  
    ]

    dependenciesForRelationsAsString: aSymbol [

	<category: 'accessing'>	
	^ ((self dependenciesForRelation: aSymbol) 
	       keys inject: '' 
 		      into: [:t :e | 
		  	      t,' ',e asString]
	       ) trimSeparators.
    ]

    codeClassName [

	<category: 'accessing'>
	| d |
	" return the class name for the component. "
	d := properties at: #code.
	^ d at: #className ifAbsent: [nil]
    ]

    codePath [

	<category: 'accessing'>
	| d |
	d := properties at: #code.
	^ d at: #classPath ifAbsent: [nil]
    ]
    
    keyworddictionary: cdata [

	<category: 'accessing'>
	" cdata is complete irrelevant for a querydictionary. Ignore it "
	properties at: #queryDictionary put: Dictionary new. 
    ]
    
    keyworddictionary [

	<category: 'accessing'>
	" return what messages the underlying component provides. "
	^ properties at: #queryDictionary
    ]
    
    keywordName: aString type: expectedClassNameString [

	<category: 'accessing'>
	" add a key to the query dictionary"
	(self keyworddictionary) at: aString put: expectedClassNameString.
	
    ]
    
    componentdefinitionName: aString type: aClassString [

	<category: 'private'>	
	^ (Smalltalk classAt: aClassString ifAbsent: [^nil]) withName: aString.
    ]

" ===================================
  ComponentDefinition XML hooks 
  =================================== "

    codeClassname: className path: pathToCode [

	<category: 'accessing XML api'>
	| d |
	" Add className and pathToCode for the loadable code "
	d := properties at: #code.
	d at: #className put: className;
	    at: #classPath put: pathToCode;
	    yourself.
    ]

    dependentName: aString relation: aSymbol [

	<category: 'accessing XML api'>
	self dependentName: aString relation: aSymbol validate: false.
    ]

    dependentName: aString relation: aSymbol validate: aStringOrBoolean [

    	<category: 'accessing XML api'>
	| d aRelation vflag |
	vflag := aStringOrBoolean.
	(aStringOrBoolean isString) ifTrue: [
	    vflag := aStringOrBoolean asBoolean.
	].
	aRelation := aSymbol asSymbol.
	d := self dependenciesForRelation: aRelation. 
	d at: aString put: vflag.
    ]

    description: aString [

	<category: 'accessing XML api'>
    	properties at: #description put: aString.
    ]
]
