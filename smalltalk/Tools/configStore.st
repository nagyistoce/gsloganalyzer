" -*- smalltalk -*- "
Namespace current: TKTools [

Object subclass: ConfigStore [
    | configKV configHandlers currentOS |

    sharedInstance := nil.

    <comment: 'I provide platform specific configuration services. 
On MacOSX will I use Defaults, Windows will I use the registry (or ini file) and in Linux will I use dot files. 
On all platforms can file based config files used be used.'>
	<category: 'TKTools-SystemTools'>

    ConfigStore class >> new [
	| os |
	<category: 'instance creation'>
	os := ((Smalltalk hostSystem subStrings: '-') at: 2).
	(sharedInstance isNil) ifTrue: [
	    sharedInstance := self basicNew initializeWith: os.
	].
	^ sharedInstance
    ]
    
    ConfigStore class >> sharedInstance [
	<category: 'instance creation'>
	<comment: 'I return the singleton instance of ConfigStore'>
	^ sharedInstance.
    ]

    initializeWith: anOSstring [
	<category: 'initialize-release'>
	configHandlers := Dictionary new.
	currentOS := Association key: (anOSstring asSymbol) value: nil.
    ]
]
]
