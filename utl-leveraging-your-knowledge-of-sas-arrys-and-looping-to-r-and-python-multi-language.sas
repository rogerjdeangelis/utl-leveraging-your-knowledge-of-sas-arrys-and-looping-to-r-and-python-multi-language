%let pgm=utl-leveraging-your-knowledge-of-sas-arrys-and-looping-to-r-and-python-multi-language;

Identify which date ranges in a master contain the dates in a transaction table

github
https://tinyurl.com/4mduuspc
https://github.com/rogerjdeangelis/utl-leveraging-your-knowledge-of-sas-arrys-and-looping-to-r-and-python-multi-language

array macros on end of this message

          SOLUTIONS

            NO SQL
              1 sas loop
              2 r loop
              3 python loop

            SQL
              4 sas sql
              5 r sql
              6 p7ython sql

              7 macro s on end
                creating in memory sas numeric and character arrays.
                (loading a sas dataset into a sas in memory array)
                (usefull for prototyping for r and python)
                macros
                   utl_chrary
                   utl_numary
                https://tinyurl.com/yna6bwaf
                https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

Related repos

https://tinyurl.com/y963wwh7
https://github.com/rogerjdeangelis/utl-convert-the-numeric-values-in-sas-dataset-to-an-in-memory-two-dimensional-array-multi-language
https://github.com/rogerjdeangelis/utl-converting-your-sas-datastep-programs-to-r
https://github.com/rogerjdeangelis/utl-leveraging-your-knowledge-of-regular-expressions-to-wps-r-python-multi-language
https://github.com/rogerjdeangelis/utl-converting-common-wps-coding-to-r-and-python
https://tinyurl.com/2f5579tt
https://github.com/rogerjdeangelis/utl-classic-r-alternatives-for-the-apply-family-of-functions-on-dataframes-for-sas-programmers
https://github.com/rogerjdeangelis/utl_convert-sas-merge-to-r-code

Related to this problem
https://stackoverflow.com/questions/46525786/how-to-join-two-dataframes-for-which-column-values-are-within-a-certain-range
https://stackoverflow.com/questions/79024010/pandas-return-corresponding-column-based-on-date-being-between-two-values
https://tinyurl.com/bde3n888
https://stackoverflow.com/questions/78959147/identify-the-columns-with-value-and-fill-the-blanks-with-0-only-for-a-defined-ra


/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                    |                                           |                                       */
/* INPUTS (all columns are character) |              PROCESS                      |            OUTPUT                     */
/* ================================== |              =======                      |            ======                     */
/*                                    |                                           |                                       */
/*                                    |                                           |                                       */
/* SD1.TRANS total obs=4              |  Iterate through four dates in trans      |    DATE    CODE STARTDATE   ENDDATE   */
/*                                    |  and test if trans date is between        |                                       */
/*     DATE                           |  startdate and end date                   | 2024-07-03  a   2024-07-01 2024-08-03 */
/*                                    |                                           | 2024-08-04                            */
/*  2024-07-03                        |   TRANS                                   | 2024-08-10  b   2024-08-06 2024-08-10 */
/*  2024-08-04                        |     DATE   CODE  STARTDATE    ENDDATE     | 2024-08-11  c   2024-08-11 2024-08-31 */
/*  2024-08-10                        |                                           |                                       */
/*  2024-08-11                        |  2024-07-03   a  2024-07-01  2024-08-03   |                                       */
/*                                    |                                           |                                       */
/*                                    |  2024-08-04                               |                                       */
/* SD1.MASTER total obs=3             |                                           |                                       */
/*                                    |  2024-08-10   b  2024-08-06  2024-08-10   |                                       */
/*  CODE    STARTDATE      ENDDATE    |  2024-08-11   c  2024-08-11  2024-08-31   |                                       */
/*                                    |                                           |                                       */
/*   a      2024-07-01    2024-08-03  |                                           |                                       */
/*   b      2024-08-06    2024-08-10  |                                           |                                       */
/*   c      2024-08-11    2024-08-31  |                                           |                                       */
/*                                    |                                           |                                       */
/*                                    |                                           |                                       */
/**************************************************************************************************************************/


/*                             _
 _ __   ___  _ __    ___  __ _| |
| `_ \ / _ \| `_ \  / __|/ _` | |
| | | | (_) | | | | \__ \ (_| | |
|_| |_|\___/|_| |_| |___/\__, |_|
  ___ ___  _ __ ___  _ __ __|_| ___  _ __     ___ ___   __| | ___
 / __/ _ \| `_ ` _ \| `_ ` _ \ / _ \| `_ \   / __/ _ \ / _` |/ _ \
| (_| (_) | | | | | | | | | | | (_) | | | | | (_| (_) | (_| |  __/
 \___\___/|_| |_| |_|_| |_| |_|\___/|_| |_|  \___\___/ \__,_|\___|

*/

/***************************************************************************************************************************************************************/
/*                                                                                                                                                             */
/*  DEMONSTRATE SIMILAR LOOPING CODE FULL CODE IN SAS R AND PYTHON                                                                                                                   */
/*  ================================================================                                                                                           */
/*                                                                                                                                                             */
/*  I realize there are simplere ways in R, SAS and Python, but I wanted the code to look very similar.                                                        */                                             */
/*                                                                                                                                                             */
/*------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/*                                                     |                                                     |                                                 */
/*          SAS                                        |                R                                    |             PYTHON                              */
/*          ===                                        |                ==                                   |             =======                             */
/*                                                     |                                                     |                                                 */
/* do row_trans=1 to dim1(trans);                      | for ( row_trans in seq(1, nrow(trans),1) ) {        | for row_trans in range(len(trans)):             */
/*                                                     |                                                     |                                                 */
/*   test=0;                                           |   test=0L;                                          |   test=0;                                       */
/*   do row_master = 1 to dim1(master);                |   for ( row_master in seq(1,nrow(master),1) ) {     |                                                 */
/*                                                     |                                                     |   for row_master in range(len(master)):         */
/*    if (trans[row_trans,1]>=master[row_master,2])    |   if ((trans[row_trans,1]>=master[row_master,2])    |      #JUST TO SHORTEN THE CODE BELOW            */
/*      and (trans[row_trans,1]<=master[row_master,3]) |     & (trans[row_trans,1] <= master[row_master,3]) )|      date      =  trans.iloc[row_trans,0]       */
/*      then do;                                       |     {                                               |      code      = master.iloc[row_master,0]      */
/*        date      = trans[row_trans,1];              |     trans[row_trans,2] <- master[row_master,1]      |      startdate = master.iloc[row_master,1]      */
/*        code      = master[row_master,1];            |     trans[row_trans,3] <- master[row_master,2]      |      enddate   = master.iloc[row_master,2]      */
/*        startdate = master[row_master,2];            |     trans[row_trans,4] <- master[row_master,3]      |                                                 */
/*        enddate   = master[row_master,3];            |                                                     |      if (startdate<=date) and (enddate>=date):  */
/*        output;                                      |     } else {                                        |         trans.iloc[row_trans,1] = code          */
/*    end;                                             |         test = test + 1L                            |         trans.iloc[row_trans,2] = startdate     */
/*    else do;                                         |     }                                               |         trans.iloc[row_trans,3] = enddate       */
/*        test=test+1;                                 |   }                                                 |         break                                   */
/*    end;                                             |                                                     |      else:                                      */
/*   end;                                              |   if (test == nrow(master)) {                       |         test=test+1;                            */
/*                                                     |     trans[row_trans,2] <- NA                        |                                                 */
/*   if test=dim1(master) then do;                     |     trans[row_trans,3] <- NA                        |   if (test == len(master)):                     */
/*     date      = trans[row_trans,1];                 |       trans[row_trans,4] <- NA                      |         trans.iloc[row_trans,1] = np.nan        */
/*     code      = "";                                 |     }                                               |         trans.iloc[row_trans,2] = np.nan        */
/*     startdate = "";                                 |   }                                                 |         trans.iloc[row_trans,3] = np.nan        */
/*     enddate   = "";                                 |                                                     |                                                 */
/*     output;                                         |                                                     |                                                 */
/*   end;                                              |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/* end;                                                |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*     DATE       CODE    STARTDATE      ENDDATE       |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*  2024-07-03     a      2024-07-01    2024-08-03     |                                                     |                                                 */
/*  2024-08-04                                         |                                                     |                                                 */
/*  2024-08-10     b      2024-08-06    2024-08-10     |                                                     |                                                 */
/*  2024-08-11     c      2024-08-11    2024-08-31     |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*                                                     |                                                     |                                                 */
/*************************************************************************************************************|*************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";

data sd1.master;
   input code$ startdate $11. enddate $11.;
cards4;
a 2024-07-01 2024-08-03
b 2024-08-06 2024-08-10
c 2024-08-11 2024-08-31
;;;;
run;quit;

data sd1.trans;
  input date $11.;
cards4;
2024-07-03
2024-08-04
2024-08-10
2024-08-11
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.TRANS total obs=4                                                                                                  */
/*                                                                                                                        */
/*     DATE                                                                                                               */
/*                                                                                                                        */
/*  2024-07-03                                                                                                            */
/*  2024-08-04                                                                                                            */
/*  2024-08-10                                                                                                            */
/*  2024-08-11                                                                                                            */
/*                                                                                                                        */
/*                                                                                                                        */
/* SD1.MASTER total obs=3                                                                                                 */
/*                                                                                                                        */
/*  CODE    STARTDATE      ENDDATE                                                                                        */
/*                                                                                                                        */
/*   a      2024-07-01    2024-08-03                                                                                      */
/*   b      2024-08-06    2024-08-10                                                                                      */
/*   c      2024-08-11    2024-08-31                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                   _
/ |  ___  __ _ ___  | | ___   ___  _ __
| | / __|/ _` / __| | |/ _ \ / _ \| `_ \
| | \__ \ (_| \__ \ | | (_) | (_) | |_) |
|_| |___/\__,_|___/ |_|\___/ \___/| .__/
                                  |_|
*/

proc datasets lib=work nolist nodetails;
 delete want;
run;quit;

%symdel _array rowcol/ nowarn;
data want;
 array master %utl_chrary(sd1.master);
 array trans %utl_chrary(sd1.trans);

 do row_trans=1 to dim1(trans);

   test=0;
   do row_master = 1 to dim1(master);

      if (trans[row_trans,1]>=master[row_master,2])
        and (trans[row_trans,1]<=master[row_master,3])
        then do;
          date      = trans[row_trans,1];
          code      = master[row_master,1];
          startdate = master[row_master,2];
          enddate   = master[row_master,3];
          output;
      end;
      else do;
          test=test+1;
      end;
   end;

   if test=dim1(master) then do;
     date      = trans[row_trans,1];
     code      = "";
     startdate = "";
     enddate   = "";
     output;
   end;

 end;

 keep date code startdate enddate;
;run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Obs       DATE       CODE    STARTDATE      ENDDATE                                                                   */
/*                                                                                                                        */
/*   1     2024-07-03     a      2024-07-01    2024-08-03                                                                 */
/*   2     2024-08-04                                                                                                     */
/*   3     2024-08-10     b      2024-08-06    2024-08-10                                                                 */
/*   4     2024-08-11     c      2024-08-11    2024-08-31                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___           _
|___ \   _ __  | | ___   ___  _ __
  __) | | `__| | |/ _ \ / _ \| `_ \
 / __/  | |    | | (_) | (_) | |_) |
|_____| |_|    |_|\___/ \___/| .__/
                             |_|
*/
proc datasets lib=sd1 nolist nodetails;
 delete rwant;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
source("c:/oto/fn_tosas9x.R")
trans<-read_sas("d:/sd1/trans.sas7bdat")
master<-read_sas("d:/sd1/master.sas7bdat")
trans <- cbind(trans, CODE = NA)
trans <- cbind(trans, STARTDATE = NA)
trans <- cbind(trans, ENDDATE = NA)
 for ( row_trans in seq(1, nrow(trans),1) ) {

   test=0L;
   for ( row_master in seq(1,nrow(master),1) ) {

     if ( (trans[row_trans,1] >= master[row_master,2])
       & (trans[row_trans,1] <= master[row_master,3]) ) {
       trans[row_trans,2] <- master[row_master,1]
       trans[row_trans,3] <- master[row_master,2]
       trans[row_trans,4] <- master[row_master,3]

     } else {
         test = test + 1L
     }
   }

   if (test == nrow(master)) {
       trans[row_trans,2] <- NA
       trans[row_trans,3] <- NA
       trans[row_trans,4] <- NA
   }
 }
trans;
fn_tosas9x(
      inp    = trans
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  R                                                                                                                     */
/*                                                                                                                        */
/*  > trans;                                                                                                              */
/*          DATE CODE  STARTDATE    ENDDATE                                                                               */
/*  1 2024-07-03    a 2024-07-01 2024-08-03                                                                               */
/*  2 2024-08-04 <NA>       <NA>       <NA>                                                                               */
/*  3 2024-08-10    b 2024-08-06 2024-08-10                                                                               */
/*  4 2024-08-11    c 2024-08-11 2024-08-31                                                                               */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*  SD1.WANT total obs=4                                                                                                  */
/*                                                                                                                        */
/*  ROWNAMES       DATE       CODE    STARTDATE      ENDDATE                                                              */
/*                                                                                                                        */
/*      1       2024-07-03     a      2024-07-01    2024-08-03                                                            */
/*      2       2024-08-04                                                                                                */
/*      3       2024-08-10     b      2024-08-06    2024-08-10                                                            */
/*      4       2024-08-11     c      2024-08-11    2024-08-31                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____               _   _                   _
|___ /   _ __  _   _| |_| |__   ___  _ __   | | ___   ___  _ __
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  | |/ _ \ / _ \| `_ \
 ___) | | |_) | |_| | |_| | | | (_) | | | | | | (_) | (_) | |_) |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |_|\___/ \___/| .__/
        |_|    |___/                                      |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read())
master,meta=ps.read_sas7bdat('d:/sd1/master.sas7bdat')
trans,meta=ps.read_sas7bdat('d:/sd1/trans.sas7bdat')
trans['CODE'] = np.nan
trans['STARTDATE'] =np.nan
trans['ENDDATE'  ] = np.nan

for row_trans in range(len(trans)):

    test=0;

    for row_master in range(len(master)):

       date      =  trans.iloc[row_trans,0]
       code      = master.iloc[row_master,0]
       startdate = master.iloc[row_master,1]
       enddate   = master.iloc[row_master,2]

       if (startdate <= date) and (enddate >= date):
          trans.iloc[row_trans,1] = code
          trans.iloc[row_trans,2] = startdate
          trans.iloc[row_trans,3] = enddate
          break
       else:
          test=test+1;

    if (test == len(master)):
          trans.iloc[row_trans,1] = np.nan
          trans.iloc[row_trans,2] = np.nan
          trans.iloc[row_trans,3] = np.nan
print(trans)
fn_tosas9x(trans,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* PYTHON                                                                                                                 */
/*                                                                                                                        */
/*          DATE CODE   STARTDATE     ENDDATE                                                                             */
/* 0  2024-07-03    a  2024-07-01  2024-08-03                                                                             */
/* 1  2024-08-04  NaN         NaN         NaN                                                                             */
/* 2  2024-08-10    b  2024-08-06  2024-08-10                                                                             */
/* 3  2024-08-11    c  2024-08-11  2024-08-31                                                                             */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/*     DATE       CODE    STARTDATE      ENDDATE                                                                          */
/*                                                                                                                        */
/*  2024-07-03     a      2024-07-01    2024-08-03                                                                        */
/*  2024-08-04                                                                                                            */
/*  2024-08-10     b      2024-08-06    2024-08-10                                                                        */
/*  2024-08-11     c      2024-08-11    2024-08-31                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                               _
| || |    ___  __ _ ___   ___  __ _| |
| || |_  / __|/ _` / __| / __|/ _` | |
|__   _| \__ \ (_| \__ \ \__ \ (_| | |
   |_|   |___/\__,_|___/ |___/\__, |_|
                                 |_|
*/

proc datasets lib=work nolist nodetails;
 delete want;
run;quit;

proc sql;
  create
     table want as
  select
     l.date
    ,case when missing(code) then 'nomatch' else code end as code
    ,r.startdate
    ,r.enddate
  from
     sd1.trans as l left join sd1.master as r
  on
     l.date ge r.startdate and date le r.enddate
  order
     by date
;quit;

proc print data=want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*  Obs       DATE       CODE       STARTDATE      ENDDATE                                                                */
/*                                                                                                                        */
/*   1     2024-07-03    a          2024-07-01    2024-08-03                                                              */
/*   2     2024-08-04    nomatch                                                                                          */
/*   3     2024-08-10    b          2024-08-06    2024-08-10                                                              */
/*   4     2024-08-11    c          2024-08-11    2024-08-31                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
| ___|   _ __   ___  __ _| |
|___ \  | `__| / __|/ _` | |
 ___) | | |    \__ \ (_| | |
|____/  |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete rwant;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
trans<-read_sas("d:/sd1/trans.sas7bdat")
master<-read_sas("d:/sd1/master.sas7bdat")
want<-sqldf('
  select
     l.date
    ,r.code
    ,r.startdate
    ,r.enddate
  from
     trans as l left join master as r
  on
     l.date between r.startdate and r.enddate
  order
     by l.date
  ')
want;
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

proc print data=want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/*                                                                                                                        */
/* > want;                                                                                                                */
/*         DATE CODE  STARTDATE    ENDDATE                                                                                */
/* 1 2024-07-03    a 2024-07-01 2024-08-03                                                                                */
/* 2 2024-08-04 <NA>       <NA>       <NA>                                                                                */
/* 3 2024-08-10    b 2024-08-06 2024-08-10                                                                                */
/* 4 2024-08-11    c 2024-08-11 2024-08-31                                                                                */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/*    DATE       CODE    STARTDATE      ENDDATE                                                                           */
/*                                                                                                                        */
/* 2024-07-03     a      2024-07-01    2024-08-03                                                                         */
/* 2024-08-04                                                                                                             */
/* 2024-08-10     b      2024-08-06    2024-08-10                                                                         */
/* 2024-08-11     c      2024-08-11    2024-08-31                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*__                 _   _                             _
 / /_    _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
| `_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
| (_) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
 \___/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
trans,meta = ps.read_sas7bdat('d:/sd1/trans.sas7bdat');
master,meta = ps.read_sas7bdat('d:/sd1/master.sas7bdat');
want=pdsql('''
  select
     l.date
    ,r.code
    ,r.startdate
    ,r.enddate
  from
     trans as l left join master as r
  on
     l.date between r.startdate and r.enddate
  order
     by l.date
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  PYTHON                                                                                                                */
/*                                                                                                                        */
/*           DATE  CODE   STARTDATE     ENDDATE                                                                           */
/*  0  2024-07-03     a  2024-07-01  2024-08-03                                                                           */
/*  1  2024-08-04  None        None        None                                                                           */
/*  2  2024-08-10     b  2024-08-06  2024-08-10                                                                           */
/*  3  2024-08-11     c  2024-08-11  2024-08-31                                                                           */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*     DATE       CODE    STARTDATE      ENDDATE                                                                          */
/*                                                                                                                        */
/*  2024-07-03     a      2024-07-01    2024-08-03                                                                        */
/*  2024-08-04                                                                                                            */
/*  2024-08-10     b      2024-08-06    2024-08-10                                                                        */
/*  2024-08-11     c      2024-08-11    2024-08-31                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

/*____
|___  |  _ __ ___   __ _  ___ _ __ ___     __ _ _ __ _ __ __ _ _   _ ___
   / /  | `_ ` _ \ / _` |/ __| `__/ _ \   / _` | `__| `__/ _` | | | / __|
  / /   | | | | | | (_| | (__| | | (_) | | (_| | |  | | | (_| | |_| \__ \
 /_/    |_| |_| |_|\__,_|\___|_|  \___/   \__,_|_|  |_|  \__,_|\__, |___/
                                                               |___/
*/


%macro utl_chrary(_inp,drop=)
   /des="load all character data into a in memory array or drop some vars and then load";
/*
 %let _inp=sd1.master;
 %let drop=;
*/
 %symdel _array rowcol / nowarn;
 %dosubl(%nrstr(
 %symdel _array rowcol/ nowarn;


 filename clp clipbrd lrecl=64000;
 data _null_;
 file clp;
 set &_inp(drop=_numeric_ &drop) nobs=rows end=dne;
 array cs[*] _character_;
 call symputx('rowcol',catx(',',rows,dim(cs)));
 length chr $200;
 do i=1 to dim(cs,1);
    chr=quote(strip(cs[i]));
    put  chr @@;
    putlog  chr @@;
 end;
 run;quit;
 %put &=rowcol;
 data _null_;
 length res $32756;
 infile clp;
 input;
 put _infile_;
 putlog _infile_;
 res=catx(" ","[&rowcol] $200 (", _infile_,')');
 putlog res;
 call symputx('_array',res);
 run;quit;
 ))
 &_array
%mend utl_chrary;


%macro utl_numary(_inp,drop=)
   /des="load all character data into a in memory array or drop some vars and then load";
/*
 %let _inp=sd1.have;
 %let drop=i j;
*/
 %symdel _array / nowarn;
 %dosubl(%nrstr(
 filename clp clipbrd lrecl=64000;
 data _null_;
 file clp;
 set &_inp(drop=_character_ &drop) nobs=rows;
 array ns _numeric_;
 call symputx('rowcol',catx(',',rows,dim(ns)));
 put (_numeric_) ($) @@;
 run;quit;
 %put &=rowcol;
 data _null_;
 length res $32756;
 infile clp;
 input;
 res=cats("[&rowcol] (",translate(_infile_,',',' '),')');
 call symputx('_array',res);
 run;quit;
 ))
 &_array
%mend utl_numary;


EXAMPLES

%put array chars %utl_chrary(sashelp.class);

 array chars [19,2] $200" Alfred" "M" "Alice" "F" "Barbara" "F" "Carol" "F" "Henry" "M" "James" "M" "Jane" "F" "Janet"
"F" "Jeffrey" "M" "John" "M" "Joyce" "F" "Judy" "F" "Louise" "F" "Mary" "F" "Philip" "M"
 "Robert" "M" "Ronald" "M" "Thomas" "M" "William" "M"

%put array nums %utl_numary(sashelp.class);

array nums  [19,3]
(14,69,112.5,13,56.5,84,13,65.3,98,14,62.8,102.5,14,63.5,102.5,12,57.3,83,12,59.8,84.5,15,62.5,
112.5,13,62.5,84,12,59,99.5,11,51.3,50.5,14,64.3,90,12,56.3,77,15,66.5,112,1
6,72,150,12,64.8,128,15,67,133,11,57.5,85,15,66.5,112)



/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
