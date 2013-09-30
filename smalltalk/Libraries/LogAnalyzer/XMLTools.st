" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "

Object subclass: XMLTools [
    " This is an all class method class to help out with XML parsing "

    <comment: 'I am just a set of private utility method for XML processing'>
    <category: 'LogAnalyzer-Utilities'>

    XMLTools class >> new [
	" This is just a set of helper methods that should not be instansiated " 
	<category: 'instance creation'>
	^ self shouldNotImplement
    ]

    XMLTools class >> attributeDictionaryFromElement: anXMLElement [

	<category: 'parsing'>

	^ anXMLElement attributes collect:  [:each | each key type -> each value].
    ]

    XMLTools class  >> selectorFromElement: anXMLElement [
	"Convenience method that calls selectorFromElement:ignoreContent: with flag set to false "

	<category: 'parsing'>
	^ self selectorFromElement: anXMLElement ignoreContent: false
    ]

    XMLTools class >> selectorArrayFromElement: anXMLElement [
	"Convenience method that calls selectorArrayFromElement:ignoreContent: with flag set to false "
	
	<category: 'parsing'>
	^ self selectorArrayFromElement: anXMLElement ignoreContent: false
    ]

    XMLTools class >> selectorArrayFromElement: anXMLElement ignoreContent: flag [
	| selectorCollection c |
	" Create an array of key->values that are meant to be invoked perform:withArguments: "
	
	<category: 'parsing'>
	selectorCollection := OrderedCollection new.
	c := anXMLElement elements select: [:each | each class = XML.Element ].
	c do: [:each | selectorCollection add: (self selectorFromElement: each ignoreContent: flag)].
	^ selectorCollection
    ]

    XMLTools class >> selectorFromElement: anXMLElement ignoreContent: flag [
	" Create a selector from the XML.Element passed id.
	 rules are tagAttribute1:value1:attribute2:value2
	 If the element is not empty an additional value:cdata will be added."

	| selector parameters arguments |

	<category: 'parsing'>
	
	"TODO: Can this method be refactored? It is too many lines"

	arguments := OrderedCollection new.
	parameters := String new.
	(self attributeDictionaryFromElement: anXMLElement) 
		      do: [:each | 
			  parameters := parameters,(each key) asString,$: asString.
			  arguments add: each value.
		      ].

	(parameters size > 0) ifTrue: [parameters := parameters firstLetterCapitalized].
	selector := (anXMLElement tag type) asLowercase, parameters. 
	flag ifFalse: [
	    (anXMLElement isEmpty) ifFalse: [
		| subSelectors cdata |
		subSelectors := self selectorArrayFromElement: anXMLElement ignoreContent: flag.
		cdata := (anXMLElement elements select: [:each | 
		    each class = XML.Text ]) inject: '' into: [:sum :each | 
			sum,each characterData ].
		
		(anXMLElement hasAttributes) ifTrue: [selector := selector,'value'.]. 
		selector := selector,':'.
		arguments add: cdata. 
		(subSelectors size > 0) ifTrue: [
		    ^ OrderedCollection new 
			add: (Association key: selector asSymbol value: arguments asArray); 
			addAll: subSelectors; 
			yourself 
		]. 
	    ].
	].
	^ Association key: selector asSymbol value: arguments asArray
    ]
]
