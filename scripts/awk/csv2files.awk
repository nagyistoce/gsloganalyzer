#!/opt/local/bin/gawk -f
##!/usr/bin/awk -f
##
## csv2files.awk
## csv2files split a csv file into several files based on a column
##
## Usage:
## csv2files.awk <id field> 
## Example: 
##    Split a file based on field 2
##    cat example.csv | csv2files.awk 2 
## 
## TODO: Add more
BEGIN {
	FS=","
}
{
if ($2~/[0-9]+/) { 
gsub(/ /,"",$2);
x=$2;
for (y=1; y<NF;y++) {
		printf "%s,",$y >>("part-"x".csv");
		}
	printf "%s\n",$NF >>("part-"x".csv");
	}
}