#!/usr/bin/awk -f
# TODO: *Much* more work
BEGIN {
	split(range,r,"-");
	startPos=r[1];
	endPos=r[2];
}
 {   
for (x = 1; x <= NF; x++) {
	      printf("%s",$x);
              if (x < startPos || x > endPos || x==NF) {
			printf(" ");
                  	continue;
		}
              printf(",");
          }
printf("\n");
}