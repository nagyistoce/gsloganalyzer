| testStrCol ipEx |
ObjectMemory gcMessage: false.
"Generate a test collection"
testStrCol := OrderedCollection new. 
1 to: 255 do: [:firstOctet |
	testStrCol add: (firstOctet asString,'.22.242.79 - _60291_1 [04/Apr/2012:07:00:03 -0700] "GET /webapps/blackboard/execute/modulepage/view?course_id=_22480_1&cmp_tab_id=_43193_1 HTTP/1.1" 200 45455 "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0" BCD89F24D5B9263CE39905830033845B 0.319 319 45455').
].

Transcript show: 'It took ',(Time millisecondsToRun: [
| aidx |   
       aidx := ApacheItemizer new.
1 to: 5000 do: [:v |
        testStrCol do: [:row | 
| ip |
        aidx extractRequestIP: row.
	].
].]) printString,' ms to run 5000*255 rows';cr.

ObjectMemory gcMessage: true.
"
It took 2640 ms to run 1000*255 rows
79585163 byte codes executed
which took 2.641 seconds (2.540s user+0.100s sys)
6630140 primitives, percent 8.33
self returns 255002, inst var returns 1021019, literal returns 19
99 method cache lookups since last cleanup, percent 0.00
33 method cache hits, 66 misses, 33.33 percent hits
returned value is FileStream
"
