#!/usr/bin/env awk -f
# Awk script to summarize a CSV file to hits per minute
# Currently assumes that $1 is the app server name and
# $3 is the timestamp
BEGIN { 
	FS="," 
	}
{ 
	app[$1","substr($3,1,5)]++;
}
END {
	for (x in app) {
		print x","app[x]
	}
}
