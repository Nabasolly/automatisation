/* cap input rows for the captured run */
options obs=100;

/* Mock the external "Data" libname the SAE project reads (Data.donnees).
   Columns match what Sae_Somme.sas reads: date_survenance, MNT_RESTANT_A_SOLDER. */
libname Data (work);
data Data.donnees;
    format date_survenance ddmmyy10.;
    input date_survenance :ddmmyy10. MNT_RESTANT_A_SOLDER;
    datalines;
01/09/2025 1250.50
03/09/2025 0
05/09/2025 780.00
08/09/2025 0
10/09/2025 3400.75
12/09/2025 150.25
15/09/2025 0
18/09/2025 920.00
22/09/2025 610.40
25/09/2025 0
;
run;

/* Period bounds the macro filters on (the orchestrator sets these via symputx) */
%let DateDebut = '01SEP2025'd;
%let DateFin   = '30SEP2025'd;
