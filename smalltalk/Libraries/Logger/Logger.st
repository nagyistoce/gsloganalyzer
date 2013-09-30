" -*- mode: smalltalk; fill-column: 80 -*- "
" TODO: This package needs to consider namespaces "

Object subclass: Logger [
    | defaultLogger loggers classMap | 

    defaultInstance := nil.
    
    Logger class >> new [
	
	<category: 'instance creation'>
	defaultInstance ifNil: [
	    defaultInstance := super new initialize.
	].
	^ defaultInstance. 
    ]

    Logger class >> sharedInstance [
	| l |
	<category: 'instance creation'>
	^ defaultInstance ifNil: [self new].

    ]

    Logger class >> doesNotUnderstand: aMessage [
	| caller |
	" Any message sent to Logger starting with log, will be sent to the sharedinstance "
	
	<category: 'dispatching'>
	caller := thisContext client printString.
	aMessage sendTo: (self sharedInstance loggerForClass: caller).
	
    ]

    Logger class >> named: aString [
	
	<category: 'accessing'>
	^ self sharedInstance named: aString

    ]

    initialize [

	<category: 'initialize-release'>
	
	loggers := Dictionary new.
	classMap := LookupTable new.
	defaultLogger := StdErrLogger new.
	self registerLogger: defaultLogger.
    ]
    
    loggerForClass: aClassString [
	| l |
	<category: 'accessing'>
	^ classMap at: aClassString ifAbsent: [ defaultLogger ]

    ]

    registerLogger: aLogger [

	<category: 'configuration'>
	loggers at: aLogger name put: aLogger.
	
    ]
    
    named: aString [
	
	<category: 'accessing'>
	^ loggers at: aString ifAbsent: [nil]

    ]

    associateLogger: aString forClass: aClassString [
	
	<category: 'configuration'>
	classMap at: aClassString put: (loggers at: aString ifAbsent: [defaultLogger]).
    ]

]
