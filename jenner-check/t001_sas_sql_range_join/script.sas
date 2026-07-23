/* ---------------------------------------------------------------------------
 * From: utl-leveraging-your-knowledge-of-sas-arrys-and-looping-to-r-and-python
 *       -multi-language.sas  --  Solution 4 "sas sql".
 *
 * Identify which master date range contains each transaction date, via a
 * PROC SQL left join with a BETWEEN-style range predicate in the ON clause.
 *
 * Only change from upstream: the SD1.TRANS / SD1.MASTER input datasets
 * (built here from the same inline DATALINES the repo uses) live in WORK
 * instead of the hard-coded  libname sd1 "d:/sd1";  so the step is
 * self-contained. The PROC SQL is the author's, verbatim.
 * ------------------------------------------------------------------------- */

data master;
   input code$ startdate $11. enddate $11.;
cards4;
a 2024-07-01 2024-08-03
b 2024-08-06 2024-08-10
c 2024-08-11 2024-08-31
;;;;
run;quit;

data trans;
  input date $11.;
cards4;
2024-07-03
2024-08-04
2024-08-10
2024-08-11
;;;;
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
     trans as l left join master as r
  on
     l.date ge r.startdate and date le r.enddate
  order
     by date
;quit;

proc print data=want;
run;quit;
