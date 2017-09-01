/* Summary table. 
Arthor: Guangping Zhang
Publish Date: 20Aug 2017
Location: Boston, MA

Summary table were widely used, such as clinical trial field ADAE table. This kind od table 
need calculate 1) counts of elements in column a group by a(subtotal), column b group by a and b;
               2) counts of elements in column b group by b(subtotal), column a/b without group by (total)
In the sample code we will need calculate 4 times to get the number mentioned above. 
The two version is almost same, except union replace multiple tables creation. */
data have;
input a $ b $ ;
cards;
a	x1
a	x2
a	x3
a	x1
a	x2
a	x3
a	x1
b	x1
b	x2
b	x3
b	x1
b	x2
b	x3
b	x1
b	x2
b	x3
b	x1
b	x2
;
run ;


proc sql;
    /* Part1: get count (by a, b)with subtotal(by a). */
    create table L1 as
    select a, b, count(b)  as c1  /*get count group by columns a, b. */
    from have 
    group by a, b;

    create table L2 as
    select a, 'subtotal' as b, count(a) as c1    /* get count by columns a(subtotal) with same name: c1. */
    from have 
    group by a ;

    /*part 2: get count (by b) with total */
    create table S1 as
    select 'soc' as a, b, count(b) as c1   /*get count group by b(subtotal) with same name: c1. */
    from have 
    group by b ;

	create table S2 as
	select 'soc' as a, 'subtotal' as b, count(b) as c1  /*get total count with same name: c1. */
    from have ;

quit;

data f;
    set L1 L2 S1 S2;
run ;

proc sort data=f ;by  descending a; run ;

proc transpose data = f out=w(drop= _name_) ;
    by descending a; 
    id b;
    var c1 ;
run ;

data final ;
    length soc $6;
    set w ;
    if a ^='soc' then soc = '     '||a ;
    else soc = a ;
    drop a ;
run ;



/* V2 */
proc sql;
    /* Part1: get count (by a, b)with subtotal(by a). */
    create table f as
    select a, b, count(b)  as c1  /*get count group by columns a, b. */
    from have 
    group by a, b
union
    select a, 'subtotal' as b, count(a) as c1    /* get count by columns a(subtotal) with same name: c1. */
    from have 
    group by a 
union
    /*part 2: get count (by b) with total */
    select 'soc' as a, b, count(b) as c1   /*get count group by b(subtotal) with same name: c1. */
    from have 
    group by b 
union
	select 'soc' as a, 'subtotal' as b, count(b) as c1  /*get total count with same name: c1. */
    from have ;
quit;


proc sort data=f ;by  descending a; run ;

proc transpose data = f out=w(drop= _name_) ;
    by descending a; 
    id b;
    var c1 ;
run ;

data final ;
    length soc $6;
	retain x1 x2 x3 subtotal ;
    set w ;
    if a ^='soc' then soc = '     '||a ;
    else soc = a ;
    drop a ;
run ;
*/
