/* Clinical trial need lots of import process, especially import multiple sheets Excel files. 
suppose all sheets have same data sturcture, we need read all of them and append it together. */

/* GET TOC for sheet name ;*/
   proc import out= TOC
       datafile = "C:\Product\&study.\programs\CDISC\ADaM specifications_UX023_CL303.xlsx"
       dbms = xlsx replace ;
       sheet = "TOC";
       getnames = yes;
       guessingrows=32767; 
   run;

/* Write sheet name into macro variables using data _null_ step and call symputx routine. */
data _null_ ;
       set toc end = lr ;
       length list $31767 ;
       retain list ;
       list = catx(' ', list, Dataset) ;
       lr:  call symputx('list', list, 'g') ;
	        call symputx('nwords', _n_) ;
run ;

/* macro for read one sheet in an Excel file. */
%macro readsheet(sheet=);
/* import excel file. */
proc import out= &sheet. 
    datafile = "C:\Product\&study.\programs\CDISC\ADaM specifications_UX023_CL303.xlsx"
     dbms = xlsx replace ;
     sheet = "&sheet.";
     getnames = Y;
     guessingrows=32767; 
run;

/* add domain and seq columns which is not necessary. */
data &sheet. ;
    set &sheet. ;
    domain= "&sheet.";
	seq = _n_ ;
run ;

/* append all sheet together, validating to void double append before appending. */
data final ;
   set %if not %sysfunc(exist(final)) %then %do;  &sheet; %end ;
   %else %do; final &sheet; %end ;
run ;

%mend ;


/* Writing another macro using readsheet macro above as sub-macro. Runing all import and append step once. */
%macro loop(vlist=);
    %let nwords=%sysfunc(countw(&vlist));
    %do i=1 %to &nwords;
        %readsheet(sheet=%scan(&list, &i))   ;
    %end;
%mend;

/* Using the macro. */
%loop(vlist=&list);


