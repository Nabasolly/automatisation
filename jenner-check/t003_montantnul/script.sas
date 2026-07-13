/* Sae_MontantNul.sas: staging data step, verbatim */
data donnees_montant;
    set Data.donnees;
run;

/* Sae_MontantNul.sas: %macro MontantNUL, verbatim definition */
%macro MontantNUL(nbsemaine=,Repertoire=, Cible=);

    proc sql;
    create table MONTANTNUL as
        select
            count(case when MNT_RESTANT_A_SOLDER = 0 then 1 end) as Nb_Nuls,
            count(case when MNT_RESTANT_A_SOLDER ne 0 then 1 end) as Nb_NonNuls
        from Data.donnees
        where date_survenance between &DateDebut and &DateFin;
    quit;

PROC EXPORT DATA=MONTANTNUL
	outfile="&&Repertoire&i..\&&Cible&i...xlsx"
    DBMS=XLSX REPLACE;
RUN;


%mend MontantNUL;

/* Caller: exercise the count/case logic against the mock table. The xlsx
   export in %MontantNUL targets an off-machine path, so here we run the same
   PROC SQL and PRINT the null / non-null counts instead. */
proc sql;
create table MONTANTNUL as
    select
        count(case when MNT_RESTANT_A_SOLDER = 0 then 1 end) as Nb_Nuls,
        count(case when MNT_RESTANT_A_SOLDER ne 0 then 1 end) as Nb_NonNuls
    from Data.donnees
    where date_survenance between &DateDebut and &DateFin;
quit;

proc print data=MONTANTNUL noobs;
    title "Nombre de montants nuls / non nuls sur la periode";
run;
