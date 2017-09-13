
/* Convert string into word and asign sequence number. 
The clinical trial data need be submitted to FDA, define.xml file is required. 
In this define.xml file, the string in column KEYS need be asigned a sequence number. */

data have;
input domain $8. KEYS  $10-40;
cards;
ADQSSF36 PARCAT1 PARAMCD USUBJID AVISITN
ADQSOTH	 PARCAT1 PARAMCD USUBJID AVISITN
ADQSPAC	 PARCAT1 PARAMCD USUBJID AVISITN
;
run ;


/*Do while loop with output statement can be used to finish this task.*/
data want ;	
set have;	
     i = 1;	
     do while (scan (KEYS, i) ne ' ');	
	   word=scan(KEYS, i ) ;
       i + 1;	
       KEY = put((i - 1), 1.);	
       output ;
     end;	
	 drop i ;
 run;	





