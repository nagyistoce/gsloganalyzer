#!/usr/local/plan9/bin/awk -f 
# Awk script to create a table in confluence format from a CSV file
# It assumes that line 1 is header line
BEGIN {
FS=","
}
{
    sep="|"
	if (NR==1) 	sep="||"          
    printf sep
    for(i = 1;i <= NF; i++) {
 			printf "%s%s",$i,sep 
	}
	printf "\n"
}