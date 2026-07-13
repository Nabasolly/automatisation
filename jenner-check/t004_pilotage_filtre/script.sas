/* Mock the Excel pilotage table that SAE_Programme_Principal imports.
   PROC IMPORT reads an off-machine .xlsx; here we build the same table
   inline so the macro-driven filter below runs against real rows.
   (Kept in this file so the script is self-contained and can be posted
   on its own to /v1/quick.) */
data Pilotage;
    length Critere_retour_initial $8 frequence $8 perimetre $8 Fichier $20 NomPrgmSAS $20 Repertoire $20 Cible $20;
    input Critere_retour_initial $ frequence $ perimetre $ Fichier $ NomPrgmSAS $ Repertoire $ Cible $;
    datalines;
GO Hebdo EDD Sae_Somme Somme . res_somme
GO Mensuel EDD Sae_Moyenne Moyenne . res_moy
STOP Hebdo EDD Sae_MontantNul MontantNUL . res_mnt
GO Hebdo RH Sae_Somme Somme . res_rh
GO Hebdo EDD Sae_Moyenne Moyenne . res_age
;
run;

/* SAE_Programme_Principal (1).sas: the macro-language WHERE builder.
   Given a space-separated &Frequence and &Perimetre, it expands at compile
   time to an OR-chain of UPCASE() equality tests and excludes STOP rows.
   The WHERE clause below is taken verbatim from the PROC IMPORT in the
   orchestrator; here it drives a DATA step over the mock pilotage table. */
%macro Filtre(Frequence=, Perimetre=);
  data SAE_25;
    set Pilotage(WHERE = (UPCASE('Critere_retour_initial'n) NE 'STOP'
                       AND (%DO i = 1 %TO %SYSFUNC(COUNTW(&Frequence., %STR( ))) ;
                               UPCASE(frequence) = "%UPCASE(%SCAN(&Frequence., &i., %STR( )))"
                               %IF &i. < %SYSFUNC(COUNTW(&Frequence., %STR( ))) %THEN OR ;
                            %END ;)
                       AND (%DO i = 1 %TO %SYSFUNC(COUNTW(&Perimetre., %STR( ))) ;
                              UPCASE(perimetre) = "%UPCASE(%SCAN(&Perimetre., &i., %STR( )))"
                              %IF &i. < %SYSFUNC(COUNTW(&Perimetre., %STR( ))) %THEN OR ;
                           %END ; )));
  run;
%mend Filtre;

/* Call with two frequencies and two perimeters -> the macro builds a
   4-way OR filter and drops STOP + non-matching rows */
%Filtre(Frequence=Hebdo Mensuel, Perimetre=EDD RH);

proc print data=SAE_25 noobs;
    var Critere_retour_initial frequence perimetre Fichier NomPrgmSAS;
    title "Table de pilotage filtree par la macro (Frequence=Hebdo Mensuel, Perimetre=EDD RH)";
run;
