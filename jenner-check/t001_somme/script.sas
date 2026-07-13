/* Sae_Somme.sas: %macro Somme, verbatim definition */
%macro Somme(nbsemaine= , Repertoire= ,Cible= );

    /* Calcul de la somme sur la période */
    proc means data=Data.donnees noprint sum maxdec=2;
        where date_survenance between &DateDebut and &DateFin;
        var MNT_RESTANT_A_SOLDER;
        output out=Res_Periode (drop=_type_ _freq_)
               sum=Somme_MNT_RESTANT_A_SOLDER;
    run;

    /* Export du résultat dans Excel */
    proc export data=Res_Periode
        OUTFILE="&&Repertoire&i..\&&Cible&i...xlsx"
        dbms=xlsx replace;
    run;

%mend Somme;

/* Caller: exercise the sum logic against the mock table. The xlsx export
   in %Somme targets an off-machine path, so here we run the same PROC MEANS
   and PRINT the computed total instead. */
proc means data=Data.donnees noprint sum maxdec=2;
    where date_survenance between &DateDebut and &DateFin;
    var MNT_RESTANT_A_SOLDER;
    output out=Res_Periode (drop=_type_ _freq_)
           sum=Somme_MNT_RESTANT_A_SOLDER;
run;

proc print data=Res_Periode noobs;
    title "Somme MNT_RESTANT_A_SOLDER sur la periode";
run;
