" -*- Mode: smalltalk -*- "
Time millisecondsToRun: [|logFile c|
c := 0.
logFile := FileStream open: '/Volumes/SuperMassive/Work/Istanbul/httpd.access_log.20091229.0140' mode: FileStream read.
[logFile atEnd] whileFalse: [|s| 
s:=logFile nextLine.
].
logFile close.
].
"
2906315601 byte codes executed
which took 14.749 seconds (13.570s user+0.678s sys)
4985200 primitives, percent 0.17
self returns 13, inst var returns 0, literal returns 0
11741948 method cache lookups since last cleanup, percent 0.40
11741737 method cache hits, 211 misses, 100.00 percent hits
returned value is 14749
"
