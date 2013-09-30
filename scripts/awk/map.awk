#!/usr/bin/awk -f
##
## map.awk
## map lines from the stream to a csv
##
## Usage:
## map.awk <mapfile> <input>
## map.awk thread_dump.2013-03-07-192359.map top-bbuser-threads.log | 2csv.awk '-vrange=1-13'
{
if (mapfile=="") {mapfile=FILENAME} 
if (FILENAME==mapfile) {  # We are reading the mapfile from the stream
	split($0,thread,",");
	pid2thread[thread[1]]=thread[2]; 
	}
else {
# We passed the mapfile
if ($0~/^top/) { curTime=$3 }
	if($0~/^[0-9].*/) {
		printf("%s %s %s\n",curTime,$0,pid2thread[$1]);
		}
	} 
}