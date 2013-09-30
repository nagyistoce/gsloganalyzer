| accessArray prser rt regex cnt |
ObjectMemory gcMessage: false.

accessArray := OrderedCollection new: 1000.
Transcript show: DateTime now printString, ' - Starting to fill array';cr.
1 to: 1000 do: [:idx |
accessArray add:  '12.22.242.',idx printString,' - _',idx printString, '_1 [04/Apr/2012:07:00:03 -0700] \"GET /webapps/blackboard/execute/modulepage/view?course_id=_22480_1&cmp_tab_id=_43193_1 HTTP/1.1\" 200 45455 \"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0\" BCD89F24D5B9263CE39905830033845B 0.319 319 45455'.
].
Transcript show: DateTime now printString, ' - Done fill array';cr.
regex :=  '^((?:\d{1,3}\.){3}\d{1,3})' asRegex.
cnt := 0.
Transcript show: DateTime now printString, ' - Starting to extraction';cr.
rt := Time millisecondsToRun: [
1 to: 500000 do: [:idx |
accessArray do: [:each |
each =~ regex ifMatched: [:m | cnt := cnt + 1.].
].
"Transcript show: 'Processing line ',idx asString;cr."
].
].
Transcript show: DateTime now printString, ' - Done with extraction. Process took ', rt printString, ' ms to perform';cr.
Transcript show: cnt printString,' IPs was found'.
Transcript show: accessArray size printString;cr.
ObjectMemory gcMessage: true.
