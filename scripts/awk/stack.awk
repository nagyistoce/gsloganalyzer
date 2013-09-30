#!/usr/bin/awk -f

# Print threads from a stacktrace with matching header and/or body
#
# Usage examples:
# 
# Example 1: Look for all threads that are BLOCKED waiting for a resource - NEEDS FIXING, output to a new docment will have new linennr
# cat /Volumes/OldMassive/Work/LRNSI-13540/thread_dump.2013-08-20-1745596506420771759346625.txt | stack.awk -v 'ai=B' -v 'hdr=.*waiting for monitor.*' -v 'body=.*waiting to lock.*' | 9p write acme/new/body
# 
# Example 2: Look for RMI threads that locks something but only list it as a Acme lookup index.
# stack.awk -v 'ai=B' -v 'hdr=.*RMI.*' -v 'body=.* locked.*' /Volumes/OldMassive/Work/LRNSI-13540/thread_dump.2013-08-20-1745596506420771759346625.txt 
#
#
#
# Output all threads:
# 	stack.awk thread_dump.2013-08-20-1745596506420771759346625.txt 
#
# Parameters:
#
#	ai=[Y|N|B] 		Acme index: Yes,No,Both. Defaults to No
#	hdr=<value> 	Regex pattern to search thread headers 
#	body=<value>	Regex pattern to search body for	

# killall awk


BEGIN { FS="\""}
{currentline++}
/^\"/ && $0~hdr {inStack=1;bMatch=0;s=""; split($0,tHdr,"\""); threadStart=currentline}
inStack { 
	if($0~/^$/) {
		if(bMatch) {
			stacklines=currentline-threadStart
			# No filename means that we are getting stuff from stdin
			if (FILENAME=="") {
				offset=offset+stacklines+1
				# print "offset:"offset" stacklines:"stacklines" currentline:"currentline" thdr:"tHdr[2] > "/dev/stderr"
				}
				else { offset=currentline }
			if (ai=="Y") {
				print FILENAME":"offset"\t"tHdr[2]
				}
			else if (ai=="B") {
				aidx[offset-stacklines]=tHdr[2]
				print s
				}
			else {
				print s
			}
			inStack=0
			bMatch=0
		}
	}
	s=s$0"\n"
	if($0~body) {bMatch=1} # empty body means match always
  }
/^$/ {inStack=0}
END {
	if (ai=="B") {
			print "Thread index:"
			print "============="
			for (lidx in aidx) {
			print FILENAME":"lidx"\t"aidx[lidx]
		}
	}
}