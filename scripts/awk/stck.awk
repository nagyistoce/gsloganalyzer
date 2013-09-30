#!/usr/bin/awk -f
##
## cat thread_dump.2013-03-07-192359.txt | stck.awk '-vquiet=true'
##
BEGIN {	
	FS="nid="; 
	verbose="false"; } 
{ 
 if($0~/nid=0x/) { 
     if (verbose=="true") { printf("%d,%s nid=%s\n",$2,$1,$2)}; 
     pid2thread[sprintf("%d",$2)]=$0;
 } 
 else {
      if (verbose=="true") {print $0}
 }
}
END { for (f in pid2thread) { 
	printf("%d,%s\n",f,pid2thread[f]); 
	}
}
