options validvarname=any;
libname TD6 '/home/u63629352/TD6/';
FILENAME REFFILE '/home/u63629352/TD6/Hospi_2017.xlsx';

/*1) importation de toute les feuilles de hospi 2017*/

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2017_indicateur
			DBMS=XLSX
			replace;
			SHEET="Indicateur";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2017_etablissement
			DBMS=XLSX
			replace;
			SHEET="Etablissement";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2017_litetplace
			DBMS=XLSX
			replace;
			SHEET="Lits et Places";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2017_activiteglobale
			DBMS=XLSX
			replace;
			SHEET="Activité Globale";
RUN;

/*importation de toute les feuilles de hospi 2018*/

FILENAME REFFILE '/home/u63629352/TD6/Hospi_2018.xlsx';


PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2018_indicateur
			DBMS=XLSX
			replace;
			SHEET="Indicateur";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2018_etablissement
			DBMS=XLSX
			replace;
			SHEET="Etablissement";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2018_litetplace
			DBMS=XLSX
			replace;
			SHEET="Lits et Places";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2018_activiteglobale
			DBMS=XLSX
			replace;
			SHEET="Activité Globale";
RUN;



/*importation de toute les feuilles de hospi 2019*/

FILENAME REFFILE '/home/u63629352/TD6/Hospi_2019.xlsx';


PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2019_indicateur
			DBMS=XLSX
			replace;
			SHEET="Indicateur";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2019_etablissement
			DBMS=XLSX
			replace;
			SHEET="Etablissement";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2019_litetplace
			DBMS=XLSX
			replace;
			SHEET="Lits et Places";
RUN;

PROC IMPORT DATAFILE=REFFILE
			OUT=TD6.hospi_2019_activiteglobale
			DBMS=XLSX
			replace;
			SHEET="Activité Globale";
RUN;


/*TRANSFORMATION DES DONNEES "activité globale" en numerique*/

data test2017;
	 set TD6.hospi_2017_activiteglobale;
	 array tab(*) A7--RH10;
	 array X(74);
	 do i = 1 to dim(tab);
	 	x(i) = input(tab(i), ? comma10.1) + 0;
	 end;
run;

data test2018;
	 set TD6.hospi_2018_activiteglobale;
	 array tab(*) A7--RH10;
	 array X(74);
	 do i = 1 to dim(tab);
	 	x(i) = input(tab(i), ? comma10.1) + 0;
	 end;
run;

data test2019;
	 set TD6.hospi_2019_activiteglobale;
	 array tab(*) A7--RH10;
	 array X(74);
	 do i = 1 to dim(tab);
	 	x(i) = input(tab(i), ? comma10.1) + 0;
	 end;
run;



/*2) Décrivez les données (analyse, problème de qualité, outliers, …)*/

/*****************Traitement des données**************************/

/* ETUDES DESCRIPTIVES DES DONNEES */

/* activité globale 2017 */
PROC MEANS DATA=test2017;RUN;

/* activité globale 2018 */
PROC MEANS DATA=test2018;RUN;

/* activité globale 2019 */
PROC MEANS DATA=test2019;RUN;


/******* Analyse des qualitées des données*********/

/* DETECTION DES VALEURS ABERANTE */

/* activité globale 2017 */
PROC UNIVARIATE DATA=test2017;
  VAR _NUMERIC_;
  OUTPUT OUT=Outliers;
RUN;

/* activité globale 2018 */
PROC UNIVARIATE DATA=test2018;
  VAR _numeric_;
  OUTPUT OUT=Outliers;
RUN;

/* activité globale 2019 */
PROC UNIVARIATE DATA=test2019;
  VAR _numeric_;
  OUTPUT OUT=Outliers;
RUN;

   

/* IDENTIFICATION DES VALEURS MANQUANTES */

/* activité globale 2017 */
PROC MEANS DATA=test2017 NMISS N MAX MIN;
RUN;

/* activité globale 2018 */
PROC MEANS DATA=test2018 NMISS N MAX MIN;
RUN;

/* activité globale 2019 */
PROC MEANS DATA=test2019 NMISS N MAX MIN;
RUN;

/*Nous avons plusieurs valeurs manquantes dans les activité globale de 2017 à 2019 donc pour ces types de donnée
,nous pouvons faire une imputation*/


/* IMPUTATION DES VALEURS MANQUANTES PAR LA MOYENNE */

/* activité globale 2017 */
DATA test2017_I;
  SET test2017;
  ARRAY X _NUMERIC_;
  DO i = 1 TO DIM(X);
    IF X[i] = . THEN X[i] = mean(of X[*]);
  END;
  DROP i;
RUN;

PROC MEANS DATA=test2017_I NMISS N MAX MIN;
RUN;

/* activité globale 2018 */
DATA test2018_I;
  SET test2018;
  ARRAY X _NUMERIC_;
  DO i = 1 TO DIM(X);
    IF X[i] = . THEN X[i] = mean(of X[*]);
  END;
  DROP i;
RUN;

PROC MEANS DATA=test2018_I NMISS N MAX MIN;
RUN;

/* activité globale 2019 */
DATA test2019_I;
  SET test2019;
  ARRAY X _NUMERIC_;
  DO i = 1 TO DIM(X);
    IF X[i] = . THEN X[i] = mean(of X[*]);
  END;
  DROP i;
RUN;

PROC MEANS DATA=test2019_I NMISS N MAX MIN;
RUN;


/* IDENTIFICATION ET SUPRESSION DES DOUBLONS */

/* activité globale 2017 */
proc sort data=test2017_I out=test2017_D nodupkey dupout=Doublons2017;
  by _all_; 
run;

proc print data=Doublons2017;
run;


/* activité globale 2018 */
proc sort data=test2018_I out=test2018_D nodupkey dupout=Doublons2018;
  by _all_; 
run;

proc print data=Doublons2018;
run;


/* activité globale 2019 */
proc sort data=test2019_I out=test2019_D nodupkey dupout=Doublons2019;
  by _all_; 
run;
proc print data=Doublons2019;
run;


/*pas de doublons dans nos données*/



/*ANALYSE DES DONNEES ET REPONSE AUX QUESTIONS*/

/*3) En 2019, existe-il des établissements nouveaux ou non présents par rapport à 2018 et / ou 2017 ? */

/* Charger les données des etablissements de 2017, 2018, 2019*/   
data etablissements_2017;
    set TD6.hospi_2017_etablissement;
    annee = 2017;
run;

data etablissements_2018;
    set TD6.hospi_2018_etablissement;
    annee = 2018;
run;

data etablissements_2019;
    set TD6.hospi_2019_etablissement;
    annee = 2019;
run;

/* Fusionner les données pour 2019, 2018 et 2017 */
data etablissements_combine;
    set etablissements_2017 etablissements_2018 etablissements_2019;
run;

/* Trier les données par identifiant d'établissement */
proc sort data=etablissements_combine;
    by finess;
run;

proc transpose data=etablissements_combine out=question3;
	var annee;
	by finess;
run;

data question3b;
	set question3;
	where col1 is null or col2 is null or col3 is null;
run;

/* non, il n'exite pas des établissements nouveaux ou non présents*/

/*4) Est-ce que certains établissements ont changé de taille (taille_MCO , taille_M, Taille_C et taille_O) 
sur la période 2017-2019 ? Est-ce que des établissements ont changé d’activité ? */

proc sql;
    create table question4a as
    select h17.finess, 
           h17.taille_MCO as TailleMCO_2017, h18.taille_MCO as TailleMCO_2018, h19.taille_MCO as TailleMCO_2019,
           h17.taille_M as TailleM_2017, h18.taille_M as TailleM_2018, h19.taille_M as TailleM_2019,
           h17.taille_C as TailleC_2017, h18.taille_C as TailleC_2018, h19.taille_C as TailleC_2019,
           h17.taille_O as TailleO_2017, h18.taille_O as TailleO_2018, h19.taille_O as TailleO_2019
    from TD6.hospi_2017_etablissement as h17
    left join TD6.hospi_2018_etablissement as h18 on h17.finess = h18.finess
    left join TD6.hospi_2019_etablissement as h19 on h17.finess = h19.finess;
quit;

proc print data= question4a;
run;
/* Les établissements n'ont pas changé de tailles */

/* Déterminons les établissements qui ont changé d'activité : 1327 établissemnt ont changé d'activité*/
proc sql;
  create table question4b as
  select distinct a.*
  from TD6.hospi_2017_activiteglobale a
  inner join TD6.hospi_2018_activiteglobale b on a.finess = b.finess
  inner join TD6.hospi_2019_activiteglobale c on a.finess = c.finess
  where (
    a.A7 ne b.A7 or
    a.A8 ne b.A8 or
    a.A9 ne b.A9 or
    a.A10 ne b.A10 or
    a.A11 ne b.A11 or
    a.A12 ne b.A12 or
    a.A13 ne b.A13 or
    a.A14 ne b.A14 or
    a.A15 ne b.A15
  )
  or (
    b.A7 ne c.A7 or
    b.A8 ne c.A8 or
    b.A9 ne c.A9 or
    b.A10 ne c.A10 or
    b.A11 ne c.A11 or
    b.A12 ne c.A12 or
    b.A13 ne c.A13 or
    b.A14 ne c.A14 or
    b.A15 ne c.A15
  );
quit;





/*5) A l’aide du nombre de lits, essayez de déterminer quels sont les seuils qui ont été utilisés pour 
constituer les variables taille_M, taille_C et taille_O (variables catégorielles). Justifiez votre 
raisonnement.*/

/* Charger les données des lits de 2017, 2018, 2019*/   
proc sql;
    create table lit_2017 as
    select *, 2017 as annee
    from TD6.hospi_2017_litetplace
    where indicateur in ('CI_AC1', 'CI_AC6', 'CI_AC8');
quit;
proc sql;
    create table lit_2018 as
    select *, 2018 as annee
    from TD6.hospi_2018_litetplace
    where indicateur in ('CI_AC1', 'CI_AC6', 'CI_AC8');
quit;
proc sql;
    create table lit_2019 as
    select *, 2019 as annee
    from TD6.hospi_2019_litetplace
    where indicateur in ('CI_AC1', 'CI_AC6', 'CI_AC8');
quit;

/* Fusionner les données de lit pour 2019, 2018 et 2017 */
data lit_combine;
    set lit_2017 lit_2018 lit_2019;
run;

/* Trier les données par finess */
proc sort data=lit_combine;
    by finess;
run;

/*transformation la variable valeur en numerique */
data lit_combine;
  set lit_combine;
  Valeur_Num = input(Valeur, ?? comma10.);
run;

/*visualiser la distribution*/
proc univariate data=lit_combine;
  histogram Valeur_Num;
run;

/* Q1 = 17, Q2 = 38 (mediane), Q3 = 78 */

/*Pour taille_M*/
data lit_combine_categories;
  set lit_combine;
  seuil1 = 17;
  seuil2 = 78;
  /* Définir les catégories en fonction des seuils */
  if Valeur_Num < seuil1 then taille_M = 'Cat1';
  else if Valeur_Num < seuil2 then taille_M = 'Cat2';
  else taille_M = 'Cat3';
run;

/*Pour taille_C*/
data lit_combine_categories;
  set lit_combine;
  seuil1 = 17;
  seuil2 = 78;
  /* Définir les catégories en fonction des seuils */
  if Valeur_Num < seuil1 then taille_C = 'Cat1';
  else if Valeur_Num < seuil2 then taille_C = 'Cat2';
  else taille_C = 'Cat3';
run;

/*Pour taille_O*/
data lit_combine_categories;
  set lit_combine;
  seuil1 = 17;
  seuil2 = 78;
  /* Définir les catégories en fonction des seuils */
  if Valeur_Num < seuil1 then taille_O = 'Cat1';
  else if Valeur_Num < seuil2 then taille_O = 'Cat2';
  else taille_O = 'Cat3';
run;

proc print data=lit_combine_categories;
run;

/*Notre raisonnement est que nous avons utilisé la procédure PROC UNIVARIATE pour obtenir des statistiques détaillées,
 y compris les quantiles (Q1, Q2, Q3), en utilisant les seuils que nous avons identifié à 
 partir des statistiques descriptives, nous avons mis en place un code qui permet de les classées par catégorie*/


/*6) Indiquez dans un tableau croisé par catégorie d’établissement (cat) et par année, le nombre 
d’établissement, le nombre de lits en MCO en détaillant par Médecine / Chirurgie / Obstétrique.*/

/* Fusionner les données de lit pour 2019, 2018 et 2017 */
data etab_lit_combine;
    set etablissements_combine lit_combine;
    drop valeur;
run;

/* Trier les données par finess */
proc sort data=etab_lit_combine;
    by finess;
run;

data etab_lit_combine;
    set etab_lit_combine;
    /* Créer des variables distinctes pour CI_AC1, CI_AC6, CI_AC8 */
    if indicateur = 'CI_AC1' then CI_AC1 = Valeur_Num;
    else if indicateur = 'CI_AC6' then CI_AC6 = Valeur_Num;
    else if indicateur = 'CI_AC8' then CI_AC8 = Valeur_Num;
run;


/* Calculer le nombre d'établissements avec PROC SQL */
proc sql;
    create table etab_combine_count as
    select cat, annee, count(distinct finess) as nombre_etablissements,
           sum(CI_AC1) as CI_AC1,
           sum(CI_AC6) as CI_AC6,
           sum(CI_AC8) as CI_AC8
    from etab_lit_combine
    group by cat, annee;
quit;

proc tabulate data= td6.etab_combine_count;
    class cat annee;
    var nombre_etablissements CI_AC1 CI_AC6 CI_AC8;
    table cat,
          annee * (nombre_etablissements * f=comma10. 
                   CI_AC1 * sum * f=comma10. 
                   CI_AC6 * sum * f=comma10. 
                   CI_AC8 * sum * f=comma10.)
          / box='Tableau croisé par catégorie et année';
run;



/*7  Les deux premiers caractères du N° finess correspondent au département. Indiquez le nombre
d’établissement par catégorie (cat) par région */

/* Fusionner les tables etablissements_combine et lit_combine */
data question7;
  set etablissements_combine lit_combine;
run;

/* Trier les données par finess */
proc sort data=question7;
    by finess;
run;

data question7;
  set etab_lit_combine;
  region = substr(finess, 1, 2); /* Extraction des deux premiers caractères du N° FINESS pour obtenir la région */
run;

proc freq data=question7;
  tables cat * region / nocol norow nopercent;
run;




/*8   Indiquez dans un tableau le nombre d’accouchement, le nombre de lit d’obstétrique par catégorie
d’établissement (cat) et par niveau de maternité. Quels sont les 5 établissements avec la plus forte
activité d’obstétrique ? */

data activiteglobale_2017;
    set TD6.hospi_2017_activiteglobale;
    annee = 2017;
run;

data activiteglobale_2018;
    set TD6.hospi_2018_activiteglobale;
    annee = 2018;
run;

data activiteglobale_2019;
    set TD6.hospi_2019_activiteglobale;
    annee = 2019;
run;

/* Fusionner les données pour 2019, 2018 et 2017 */
data activiteglobale_combine;
    set activiteglobale_2017 activiteglobale_2018 activiteglobale_2019;
run;

/* Trier les données par finess */
proc sort data=activiteglobale_combine;
    by finess;
run;

/*Fusionner les tables nécessaires (Etablissement et Activité globale) */
data etab_actglob_lit_combine;
    set etab_lit_combine activiteglobale_combine;
run;


/* Tri des données par les variables BY */
proc sort data=etab_actglob_lit_combine;
    by finess;
run;

/* CI_A11_num: nombre d'accouchement;  CI_E6: niveau de maternité; CI_AC8 nombre de lits en obstétrique */
data etab_actglob_lit_combine;
    set etab_actglob_lit_combine;
    CI_A11N = input(CI_A11, ?? comma10.);
    CI_AC8N = input(CI_AC8, ?? comma10.);
    niveau_de_maternite = input(CI_E6, ?? comma10.);
    
run;

proc sql;
    create table tableau_accouchements as
    select cat, finess, niveau_de_maternite,
           sum(CI_A11N) as total_accouchements,
           sum(CI_AC8N) as total_lits_obstetricaux
    from etab_actglob_lit_combine
    group by cat, finess, niveau_de_maternite
    order by total_lits_obstetricaux desc;
quit;




/* Afficher les 5 établissements avec la plus forte activité obstétrique */
proc print data=tableau_accouchements(obs=5);
    var finess total_lits_obstetricaux;
    title 'Top 5 des établissements avec la plus forte activité obstétrique';
run;



/*9  Résumez les indicateurs de la question 8 par région. Indiquez également le nombre min et max
d’accouchement. */

/* Fusionner les tables*/
data region_accouchement_combine;
  set question7 tableau_accouchements;
run;

/* Résumé des indicateurs par région avec le nombre min et max d'accouchements */
proc sql;
    create table resume_indicateurs_region as
    select
        region,
        cat,
        sum(total_accouchements) as total_accouchements,
        min(total_accouchements) as min_accouchements,
        max(total_accouchements) as max_accouchements
    from region_accouchement_combine
    group by region, cat
    order by region, cat;
quit;

/* Affichage du résultat */
proc print data=resume_indicateurs_region;
    title 'Résumé des indicateurs par région';
run;



/*10  A l’aide de variables présentes dans le fichier essayez de calculer un score de « qualité » pour les
accouchements (obstétrique) afin de classer les établissements. Justifiez le calcul de votre score et
proposez une interprétation de votre score.
A l’aide de votre score, indiquez quels sont les 5 meilleurs et 5 moins bons établissements.
*/

/*Fusionner les tables nécessaires (Etablissement et Activité globale) */
data etab_actglob_combine;
    set etablissements_combine activiteglobale_combine;
    drop A7--P9;
    drop P12--RH10;
    drop taille_changer activity_changed;
run;

/* Calcul du score de qualité pour les accouchements */
data score_qualite;
    set etab_actglob_combine;
    
	P10N = input(P10, ?? comma10.2);
    P11N = input(P11, ?? comma10.2);
    Taux_de_cesariennes = P10N ; 
    Taux_de_péridurale  = P11N ; 

    /* Calcul du score de qualité */
    score_qualite = (Taux_de_cesariennes + Taux_de_péridurale) / 2;
run;

/*Pour calculer le score de qualité, nous avons utilisé le taux de cesarienne et le taux de péridurale et 
nous avons diviser par 2 pour chaque etablissement*/

/* Triez les établissements en fonction du score de qualité */
proc sort data=score_qualite;
  by descending score_qualite;
run;

/* Affichez les 5 meilleurs établissements */
proc print data=score_qualite(obs=5);
  var finess score_qualite;
  title 'Les 5 meilleurs bons établissements';
run;

/* Triez les établissements en fonction du score de qualité */
proc sort data=score_qualite;
  by score_qualite;
run; 

/* Affichez les 5 moins bons établissements */
proc print data=score_qualite(obs=5);
  var finess score_qualite;
  where score_qualite > 0;
  title 'Les 5 moins bons établissements';
run;


/*11   Etudiez la stabilité de votre score sur les années 2017, 2018 et 2019. Par exemple, constatez-vous
que les établissements qui ont un score qui n’est pas stable s’accompagne de changement dans les
activités et les structures ? De même, une stabilité dans le score doit se traduire par une stabilité dans
les activités et les structures. Donnez des exemples concrets*/

/*Fusionner les tables nécessaires (Etablissement et Activité globale) */
data scrqua_actglob_combine;
    set score_qualite activiteglobale_combine;
run;

/* Tri des données par la variable finess */
proc sort data=scrqua_actglob_combine;
  by finess annee;
run;

/*calcul du changement de score d'une année à l'autre */
data scores_stabilite;
  set scrqua_actglob_combine;
  by finess annee;
  retain score_precedent;
  score_precedent = score_qualite; 
  if first.finess then score_precedent = .;
  else score_change = score_qualite - score_precedent;
  /* Si le score_change est différent de 0, cela indique un changement dans le score d'une année à l'autre */
  score_stable = (score_change = 0); 
run;


/* Affichage des statistiques descriptives */
proc means data=scores_stabilite n mean std min max;
  class score_stable;
  var score_qualite;
  run;
  
  
/*12 Calculez votre score par région et par année. Précisez comment vous passez d’un score calculé
par établissement à un score calculé par région / année. Existe-il des différences entre les régions ?
Quelles sont les limites de votre score ? Indiquez comment pourriez-vous l’améliorer ? */

data region;
  set scores_stabilite;
  region = substr(finess, 1, 2); /* Extraction des deux premiers caractères du N° FINESS pour obtenir la région */
run;


/*Fusionner les tables nécessaires (Etablissement et Activité globale) */
data scrqua_reg_combine;
    set score_qualite region;
run;

/* Utilisation de proc SQL pour calculer le score par région et par année */
proc sql;
  create table score_qualite_region_annee as
  select region, annee, mean(score_qualite) as score_qualite_region
  from scrqua_reg_combine
  group by region, annee;
quit;

/*oui il ya des differnce entre les regions*/

/* Les scores dépendent des données disponibles. 
comme certaines données manquent ou sont incorrectes, le score est biaisé.*/

/*Pour améliorer ces scores, Documenter clairement la méthodologie de calcul du score, 
y compris les variables utilisées et les pondérations appliquées, permet une meilleure compréhension et interprétation.*/











