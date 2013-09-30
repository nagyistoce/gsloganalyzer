Eval [
    Smalltalk addSubspace: #LogAnalyzerTests
]


TestCase subclass: LogAnalyzerTestCase [
    
    <comment: nil>
    <category: 'LogAnalyzer-Tests'>
    
    defaultLogPolicyClass [
	<category: 'tests'>
	^TestVerboseLog
    ]
]

LogAnalyzerTestCase subclass: LogAnalyzerStreamTests [
    | file |

    <comment: nil>
    <category: 'LogAnalyzer-tests'>
    
    LogAnalyzerStreamTests class >> LICENSE [
	<category: 'LICENSE'>
	^'Copyright 2010 Tim Kack.
This class is part of the LogAnalyzer toolset, licensed under the General Lesser General Public License (LGPL2).'
]

    testCountLines [
	<category: 'tests'>
]
