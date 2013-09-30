" -*- smalltalk -*- "
Namespace current: TKTools [

GenericConfigStore subclass: AppleConfigStore [
    | defaults |
    <comment: 'I provide access to two different ConfigurationStores, the User Defaults and the generic file store'>
    <category: 'TKTools-SystemTools'>

    AppleConfigStore class >> new [
	<category: 'instance creation'>
	^super new initialize.
    ]
    initialize [
	<category: 'initialize-release'>
	
    ]
]
]


