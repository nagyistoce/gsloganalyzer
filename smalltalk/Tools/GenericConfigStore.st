" -*- smalltalk -*- "
Namespace current: TKTools [

Object subclass: GenericConfigStore [
    | configfile |
    <comment: 'I provide access to a filebased Configuration Store'>
    <category: 'TKTools-SystemTools'>

    GenericConfigHandler class >> new [
	<category: 'instance creation'>
	^ self basicNew initialize.
    ]
]
]
