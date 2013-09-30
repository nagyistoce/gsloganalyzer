" -*- mode: smalltalk; mode: auto-complete -*- "
" TODO: Add extension to Association possibly "


String extend [
    
    asXMLElement: tag [
	| n |
	
	<category: 'XML Extension'>
	n := XML.Element tag: tag.
	n addNode: (XML.Text text: 
			(self displayString copyReplaceAll: '&' with: '&amp')).
	^ n
    ]
    
    firstLetterCapitalized [
	| s |

	<category: 'converting'>
	s := ReadWriteStream on: (String new).
	s nextPut: (self at: 1) asUppercase;
	  nextPutAll: (self copyFrom: 2 to: self size) asLowercase.
	^ s contents
    ]

    asBoolean [
	" return a boolean value from the string if it only contains 
	 true or false "
	<category: 'converting'>
	(self asLowercase = 'true') ifTrue: [ ^true ].
	(self asLowercase = 'false') ifTrue: [ ^false ].
	
	" Fallthrough to show that we could not convert the string."
	^ nil 
    ]
]

Dictionary extend [
    
    asXMLElement: tag [

	<category: 'XML Extension'>
	^ self asXMLElement: tag configurationDictionary: nil
    ]
]

Number extend [

	asXMLElement: tag [
	    | n |

	    <category: 'XML Extension'>
	    n := XML.Element tag: tag.
	    n addNode: (XML.Text text: 
			    (self asString copyReplaceAll: '&' with: '&amp')).
	    ^ n
	]
]

Collection extend [

    asXMLElement: collectionTag itemTags: itemTag [
	| n |

	<category: 'XML Extension'>
	n := XML.Element tag: collectionTag asString.
	self do: [:i |
	    (i respondsTo: #asXMLElement:) ifTrue: [
			n addNode: (i asXMLElement: itemTag asString).
		].
	].
	^ n
    ]
    
    asXMLElement: tag [

	<category: 'XML Extension'>
	" TODO: Replace this with a proper pluralizing " 
	^ self asXMLElement: tag itemTags: tag,'s'
    ]
]

Dictionary extend [
    
    asXMLElement: tag [

	<category: 'XML Extension'>
	^ self asXMLElement: tag marshallingRulesDictionary: nil
    ]

    asXMLElement: tag marshallingRulesDictionary: rules [
	| node xmlCreator |
	"  I will create a series of XML Element contained in 'tag'. 
	 The rules dictionary is used to affect the contents and how the 
	 tag is generated.
	 Currently are there two keys, #valueTransform and #xmlConverter, 
	 whose value should contain blocks or instance that responds to value

	 The block signatures are as follows:
	 #valueTransform [: e| <process and return value>]
	 #xmlCreator [:node :key :val | (val respondsTo: #asXMLElement:) 
	                  ifTrue: [ 
	                           node addNode: 
	                               (val asXMLElement: key asString. 
	                          ].
	 ].
	 Above shows the standard xml creator.
	 "

	<category: 'XML Extension'>
	node := XML.Element tag: tag.
	self keysAndValuesDo: [:k :v |
	    | tmpval |
	    xmlCreator := [:node :key :val | 
		(val respondsTo: #asXMLElement:marshallingRulesDictionary:) 
            ifTrue: [
		    node addNode: (val asXMLElement: key asString 
				       marshallingRulesDictionary: rules).
	            ] 
	    ifFalse: [
		    (val respondsTo: #asXMLElement:) ifTrue: [
			node addNode: (val asXMLElement: key asString).
		    ].
		].
	    ].   
	    " Copy the readonly value to tmpval since it might be transformed by 
	      the rules dictionary blocks "
	    tmpval := v. 
	    rules ifNotNil: [ 
		rules at: k ifPresent: [:conf | 
		    tmpval := conf at: #valueTransform ifPresent: [:vt | vt value: v]. 
		    xmlCreator := conf at: #xmlCreator ifAbsent: [xmlCreator].
		].
	    ].
	   xmlCreator value: node value: k value: tmpval.
	].
	^ node
    ]
]
