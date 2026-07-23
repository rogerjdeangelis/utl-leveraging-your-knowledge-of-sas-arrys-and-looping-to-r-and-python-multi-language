/* ---------------------------------------------------------------------------
 * From: utl-leveraging-your-knowledge-of-sas-arrys-and-looping-to-r-and-python
 *       -multi-language.sas  --  Solution 1 "sas loop".
 *
 * The repo's headline demonstration: load the two datasets into in-memory
 * 2-D arrays, then walk every transaction date against every master range
 * with a nested DO loop, OUTPUTting a matched row (or a blank row when a
 * transaction matches nothing). This is the SAS side of the "make the SAS,
 * R and Python code look the same" exercise the file is built around.
 *
 * Two self-containment substitutions from upstream:
 *   - the SD1.TRANS / SD1.MASTER inputs (built here from the repo's own
 *     inline DATALINES) live in WORK instead of  libname sd1 "d:/sd1";
 *   - the %utl_chrary(sd1.master) array loader (a clipboard-based macro
 *     from the author's shared macro library) is replaced by an equivalent
 *     inline load into MASTER[3,3] / TRANS[4,1] temporary arrays, and the
 *     dim1(...) alias is written as dim(...,1) -- the two are documented
 *     equivalents.
 * The nested-loop matching algorithm itself is the author's, verbatim.
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

data want;
 length date code startdate enddate $200;

 /* in-memory 2-D character arrays -- inline stand-in for
    array master %utl_chrary(sd1.master);  and  %utl_chrary(sd1.trans); */
 array master[3,3] $200 _temporary_;
 array trans[4,1]  $200 _temporary_;

 if _n_=1 then do;
   do rm=1 to 3;
     set master(keep=code startdate enddate) point=rm;
     master[rm,1]=code; master[rm,2]=startdate; master[rm,3]=enddate;
   end;
   do rt=1 to 4;
     set trans(keep=date) point=rt;
     trans[rt,1]=date;
   end;
 end;

 do row_trans=1 to dim(trans,1);

   test=0;
   do row_master = 1 to dim(master,1);

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

   if test=dim(master,1) then do;
     date      = trans[row_trans,1];
     code      = "";
     startdate = "";
     enddate   = "";
     output;
   end;

 end;

 keep date code startdate enddate;
;run;quit;

proc print data=want;
run;quit;
