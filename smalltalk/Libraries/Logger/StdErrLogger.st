" -*- mode: smalltalk; fill-column: 80 -*- "

AbstractLogger subclass: StdErrLogger [

    StdErrLogger class >> new [
	| t |
	<category: 'instance creation'>
	t := self basicNew initialize.
	t logStream: stderr.
	t name: 'StandardErrorLogger'.
	^ t
    ]
]
