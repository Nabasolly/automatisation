/* cap input rows for the captured run */
options obs=100;

/* Mock the external "Data" libname (Data.donnees). Columns match what
   Sae_Moyenne.sas reads: date_survenance, DT_NAISSANCE, DT_DECES. */
libname Data (work);
data Data.donnees;
    format date_survenance ddmmyy10. DT_NAISSANCE DT_DECES datetime20.;
    input date_survenance :ddmmyy10. DT_NAISSANCE :datetime20. DT_DECES :datetime20.;
    datalines;
02/09/2025 15JUN1980:00:00:00 .
04/09/2025 20MAR1975:00:00:00 .
06/09/2025 01JAN1990:00:00:00 .
09/09/2025 12DEC1965:00:00:00 10JAN2025:00:00:00
11/09/2025 30JUL2000:00:00:00 .
14/09/2025 25FEB1958:00:00:00 .
17/09/2025 08AUG1988:00:00:00 .
21/09/2025 19OCT1972:00:00:00 .
;
run;

/* Period bounds the macro filters on (the orchestrator sets these via symputx) */
%let DateDebut = '01SEP2025'd;
%let DateFin   = '30SEP2025'd;
