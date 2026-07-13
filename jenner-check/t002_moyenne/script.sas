/* Sae_Moyenne.sas: age computation, verbatim */
data donnees_age;
    set Data.donnees;
	If not missing (DT_NAISSANCE) then do;
	Age = floor(yrdif(datepart(DT_NAISSANCE),ifn(missing(DT_DECES), today(), datepart(DT_DECES)),'AGE'));
   end;
run;

/* Sae_Moyenne.sas: %macro Moyenne, verbatim definition */
%macro Moyenne(nbsemaine= , Repertoire= ,Cible= );
    proc means data=donnees_age mean maxdec=2;
        where date_survenance between &DateDebut. and &DateFin.;
        var AGE;
        output out=Res_Periode (drop=_type_ _freq_)
               mean=moyenne;
    run;

    /* Export du résultat dans Excel */
    proc export data=Res_Periode
        outfile="&&Repertoire&i..\&&Cible&i...xlsx"
        dbms=xlsx replace;
    run;
%mend Moyenne;

/* Caller: exercise the mean logic against the mock table. The xlsx export
   in %Moyenne targets an off-machine path, so here we run the same PROC MEANS
   and PRINT the computed average age instead. */
proc means data=donnees_age mean maxdec=2;
    where date_survenance between &DateDebut. and &DateFin.;
    var AGE;
    output out=Res_Periode (drop=_type_ _freq_)
           mean=moyenne;
run;

proc print data=Res_Periode noobs;
    title "Moyenne des ages sur la periode";
run;
