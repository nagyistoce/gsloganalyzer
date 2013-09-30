" -*- mode: smalltalk; display-time-mode: on; mode: auto-complete -*- "
" TODO: Turn this into real SUnit tests "

| pd1 pd2 pd3 pd4 pd5 |
ParserRegistry forgetAll.
pd1 := ParserDefinition withName: 'pd1'.
pd1 logType: 'pd1-logtype'.

pd2 := ParserDefinition withName: 'pd2' extendParserWithName: 'pd1'.
pd2 logType: 'pd2-logtype'.

pd3 := ParserDefinition withName: 'pd3'.
pd3 logType: 'pd3-logtype'.

pd4 := ParserDefinition withName: 'pd4' extendParserWithName: 'pd3'.
pd4 logType: 'pd4-logtype'.

pd5 := ParserDefinition withName: 'pd5'.
pd5 requireParserWithName: 'pd2'.
pd5 optionalParserWithName: 'pd3'.

pd1 inspect.
pd2 inspect.
pd3 inspect.
pd4 inspect.
pd5 inspect. 

pd5 asXMLString inspect.

" Testing AbstractComponentDefinitions "
| d |
d := AbstractComponentDefinition withName: 'Test'.
d inspect.
ComponentRegistry inspect.
Transcript show: 'Valid:', d isValid printString;cr.

| d |
d := AbstractComponentDefinition new.
d addRequiredComponentNamed: 'Test2'.
d inspect.
Transcript cr;show: 'Valid:', d isValid printString;cr.

| o1 o2 o3 o4   |
ComponentRegistry reset.
o4 := AbstractComponentDefinition withName: 'Test4'.
o3 := AbstractComponentDefinition withName: 'Test3' extendComponentNamed:'Test4'.
o2 := AbstractComponentDefinition withName: 'Test2' extendComponentNamed:'Test3'.
o1 := AbstractComponentDefinition withName: 'Test1' extendComponentNamed:'Test2'.
Transcript show: 'I (o1) will generate the following XML';cr;show: o1 asXMLString contents;cr.
Transcript show: 'Am I valid? ',o1 isValid printString;cr.


" Testing single instance "
| o1 i1 x1 x  |
ComponentRegistry reset.
o1 := AbstractComponentDefinition withName: 'TestCodeLoad'.
o1 codeClassName: 'AbstractComponentTestClass'.
o1 codePath: 'AbstractComponentTestClass.st'.
Transcript show: 'Am I valid? ',o1 isValid printString;cr.
Transcript show: 'I (o1) will generate the following XML';cr;show: o1 asXMLString contents;cr.
x1 := XML.SAXParser defaultParserClass processDocumentString: (o1 asXMLString contents) beforeScanDo: [ :p | p validate: false].
x := (x1 root elements) 
      select: [:each | each class = XML.Element].
x do: [:each | 
    Transcript show: 'Content: ', each tag printString, ' -> '.
((each children) select: [:el | el class = XML.Element]) do: [:e | Transcript show: '(',e tag printString,') ',e;cr].
Transcript cr.
].
i1 := o1 getCodeInstance.
i1 inspect.

" Testing extended instance "
| o1 o2 o3 o4 i1 |
ComponentRegistry reset.
o1 := AbstractComponentDefinition withName: 'Dependent' extendComponentNamed:'Dependency'.
o1 codeClassName: 'AbstractComponentTestClass'.
o1 codePath: 'AbstractComponentTestClass.st'.
Transcript show: 'Am I valid? ',o1 isValid printString;cr.
o2 := AbstractComponentDefinition withName: 'Dependency'.
o2 codeClassName: 'AbstractComponentTest2Class'.
o2 codePath: 'AbstractComponentTest2Class.st'.
o3 := AbstractComponentDefinition withName: 'Optional1'.
o3 codeClassName: 'AbstractComponentTest2Class'.
o3 codePath: 'AbstractComponentTest2Class.st'.
o4 := AbstractComponentDefinition withName: 'Optional2'.
o4 codeClassName: 'AbstractComponentTest2Class'.
o4 codePath: 'AbstractComponentTest2Class.st'.
o1 addOptionalComponent: 'Optional1'.
o1 addOptionalComponent: 'Optional2'.
Transcript show: 'Am I valid? ',o1 isValid printString;cr.
Transcript show: 'I (o1) will generate the following XML';cr;show: o1 asXMLString contents;cr.
i1 := o1 getCodeInstance.
i1 inspect.
o1 inspect.

" Testing XML extension of Dictionary "
| d doc md |
d := Dictionary new.
d at: 'Key1' put: 'Value1'; 
at: #SymbolKey1 put:#SymbolValue1;
at: 2 put:'Integer key 2';
at: 'SubDictionary' put: ((Dictionary new) at: 'SubDictKey1' put: 'SubDictValue1'; yourself); 
at: 'NumberValueDictionary' put: (
(Dictionary new) 
  at: 'a' put: 1; 
  at: 'b' put: 2; 
  at: 'c' put: 3; 
yourself); 
at: 'MixedDictionary' put: (
(Dictionary new) 
  at: 'a' put: Time now; 
  at: 'b' put: 3.2345665423234; 
  at: 'c' put: 99999999999999999999; 
yourself); 
yourself.
md := Dictionary new.
md at: 'MixedDictionary' put: (
(Dictionary new) 
at: #valueTransform put: [:e | e keys]; 
"at: #xmlCreator put: [:node :key :val | 
	    (val respondsTo: #asXMLElement:itemTags:) ifTrue: [
		node addNode: (val asXMLElement: 'parsers' itemTags: key asString).
	    ].
];"
yourself
).

md at: 'NumberValueDictionary' put: (
(Dictionary new) 
at: #valueTransform put: [:e | e values]; 
at: #xmlCreator put: [:node :key :val | 
	    (val respondsTo: #asXMLElement:itemTags:) ifTrue: [
		node addNode: (val asXMLElement: 'values' itemTags: 'value').
	    ].
];
yourself
).

" Transcript show: d printString;cr." 
" Transcript show: md printString;cr."
Transcript show: (d asXMLElement: 'xmltestdict' marshallingRulesDictionary: md) printString.
 
 
| simpleComponentXML def | 
simpleComponentXML := XML.SAXParser defaultParserClass processDocumentString: '<ComponentDefinition name="SimpleComponent" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="Tests/AbstractComponentTestClass.st" />
<description>I am a simple component</description></ComponentDefinition>' beforeScanDo: [ :p | p validate: false ].
(XMLTools selectorFromElement: simpleComponentXML root ignoreContent: true) inspect.

| testXML |
testXML := XML.SAXParser defaultParserClass processDocumentString: '<dependent name="c1" relation="extends" validate="true" />' beforeScanDo: [ :p | p validate: false ].
(Dictionary from: ((testXML root attributes) collect: [:each | each key type -> each value])) inspect.
(XMLTools selectorFromElement: testXML root) inspect.
(XMLTools attributeDictionaryFromElement: testXML root) inspect.

" Some testsuites "
| r s |
s := ReadWriteStream on: (String new).
r := (TestSuite named: 'Components') 
  addTest: (AbstractComponentDefinitionTest selector: #testNew);
  addTest: (AbstractComponentDefinitionTest selector: #testInitRelationships);
  addTest: (AbstractComponentDefinitionTest selector: #testSimpleXMLDefinition);
  addTest: (AbstractComponentDefinitionTest selector: #testInvalidSimpleXMLDefinition);
  logPolicy: (SUnit.TestFailureLog on: s); 
  run.
Transcript show: s contents.

| testXML d t |
testXML := XML.SAXParser defaultParserClass processDocumentString: '<outer>
Test
<i1>abc</i1>
gfgfddghgfd
<i2>def</i2>Ytr
<i3>ghi</i3>
</outer>' beforeScanDo: [ :p | p validate: false ].
d := testXML root elements select: [:each | each class = XML.Element ].
t := testXML root elements select: [:each | each class = XML.Text ].
t inspect.

" Create a seqence of AbstractComponentDefinitions "
| c1 c1def c1xml c2 c2def c2xml c3 c3def c3xml |
ComponentRegistry reset.
Logger sharedInstance associateLogger: 'StandardErrorLogger' forClass: 'AbstractComponentDefinition'.
(Logger sharedInstance loggerForClass: 'AbstractComponentDefinition') logLevel: #Info.

c1def := '
<ComponentDefinition name="Component1" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="Tests/AbstractComponentTestClass.st" />
<description>I am a simple component</description>
<keywordDictionary>
<keyword name="key1" type="String" />
<keyword name="key2" type="Number" />
<keyword name="key3" type="Dictionary" />
</keywordDictionary>
</ComponentDefinition>
'.
c2def := '
<ComponentDefinition name="Component2" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="Tests/AbstractComponentTestClass.st" />
<description>I am a simple component</description>
<keywordDictionary>
<keyword name="key1" type="String" />
<keyword name="key2" type="Number" />
<keyword name="key3" type="Dictionary" />
</keywordDictionary>
</ComponentDefinition>
'.
c3def := '
<ComponentDefinition name="Component3" type="AbstractComponentDefinition">
<code className="AbstractComponentTestClass" path="Tests/AbstractComponentTestClass.st" />
<description>I am a simple component</description>
<dependent name="Component2" relation="extends" />
<dependent name="Component1" relation="required" />
<keywordDictionary>
<keyword name="key1" type="String" />
<keyword name="key2" type="Number" />
<keyword name="key3" type="Dictionary" />
</keywordDictionary>
</ComponentDefinition>
'.

c1xml := XML.SAXParser defaultParserClass
	    processDocumentString: c1def
	    beforeScanDo: [ :p | p validate: false ].
c2xml := XML.SAXParser defaultParserClass
	    processDocumentString: c2def
	    beforeScanDo: [ :p | p validate: false ].
c3xml := XML.SAXParser defaultParserClass
	    processDocumentString: c3def
	    beforeScanDo: [ :p | p validate: false ].

c1 := AbstractComponentDefinition fromXMLDefinition: c1xml.
c2 := AbstractComponentDefinition fromXMLDefinition: c2xml.
c3 := AbstractComponentDefinition fromXMLDefinition: c3xml.

c3 inspect.

| d |
d := ' -latr'.
Smalltalk system: 'ls',d.
