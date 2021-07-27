 calibration_molonari_mini
 ==
% Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi
# Attention
Les noms des capteurs de pressions doivent tous commencer par un "p".
## Installation de librairies
Ces scripts nécessitent l'installation de Rstudio et des packages suivant:
* lubridate
* stringr
* data.table
* dplyr
* tidyverse

## Format et contenus des fichiers
* Il est important que les titres des colonnes des fichiers contiennent les mot : tension, temperature, dates. Si vous n'avez pas correctement configurer vos hobos vous devez modifier vos fichiers avant d'utiliser les scripts.
* Separateur de champs est la virgule
* le format des dates doit être JJ/MM/AAAA HH:MM:SS

## Répertoires
Il est nécessaire de modifier les paths pour scriptR dans tous les scripts. ex wd=paste0('/home/ariviere/Programmes/calibration_molonari_mini/scripts_R')


## Scripts
"scripts_R" est le dossier contenant tous les scripts pour les traitements et analyses.	


# Methodologie

Dans ce dossier on fait les analyses des donnees de calibration des capteurs de pression. Les capteurs de pression enregistrent des donnees de tension et de temperature, le but est d'obenir les coefficients de calibration pour transformer tension-temperature en pression differentielle en prenant en compte l'effet de la temperature sur les mesures.
Dans l'ordre d'analyse :

"data" est le dossier contenant les donnees enregistrees par les hobos lors des calibrations
Le dossier data\1_raw_data\nom_capteur doit etre suivi rigoureusement

## Donnees brutes
1_raw_data contient les donnees telles qu'elles ont ete mesurees

### CHAMBRE CLIMATIQUE
1) Creer un répertoire nommé pn°_capteur_annee_mois_jour_UT 

ex :pxxx_YYYY-mm-dd_calibUT
Les fichiers de la chambre climatique se nomme : pn°_capteur_annee_mois_jour_UT_n° ex: p520_2016-08_UT


2) Créer un fichier nommé: pn°_capteur_annee_mois_jour_UT 
			ex :  p520_2016-08-03_UT dans lequel les colonnes suivantes sont remplies : nom du fichier d'enregistrement	differentiel de charge [cm]


Les colonnes doivent se nommer #,dates,temperature,tension,,,

3) Conserver les fichiers hobo et les fichiers csv nommé ex p537_2019_03_12_calibUT_3 pour les trois différences de charge testées.


           * Le format des dates est important ex : 1,11/03/2019 10:06:31,202.749,0.07656
           * Attention les charges et la difference de charge doivent être en cm


4) Un fichier tableau de bords en csv doit être dans ce répetoire sous le noms ex : p537_2019-03-07_UT_tableauDeBord
			
        Ce fichier contient nom du fichier d'enregistrement	differentiel de charge [cm]

								*		nom du fichier d'enregistrement,differentiel de charge [cm]
								*		p537_2019_03_08_calibUT_1.csv,1.5
								*		p537_2019_03_11_calibUT_2.csv,-0.2
								*		p537_2019_03_12_calibUT_3.csv,-1.5
				*	Ne pas laisser les entêtes des fichiers (supprimer les deux premières lignes)

### CALIBRATION UH Rampe en bois
1) Creer un repertoire nommé pn°_capteur_annee_mois_jour_calibUH 


		* 	ex:  p520_2016-02-22_calibUH


* Le fichier 	excel pn°_capteur_annee_mois_jour_calibUH doit contenir 4 colonnes : hauteur droite(nappe), hauteur gauche (riviere), deltaH, tension mesurre (attention pas d'accent)


* Le fichier extrait de HOBOWARE doit se nommer ex : p537_2019_02_27_calibUH_enregistrement l'ordre est important n° de ligne, date, tension, temperature		
			
			
2) Les sous-dossiers correspondant a des noms de capteurs contiennent les donnees relatives a chaque capteur.


			* Chacun de ces sous-dossiers peuvent eventuellement contenir un dossier apoub, qui correspondent a des donnees qui ne sont pas exploitables pour les calibrations.
			

###  0_plot_raw.R : ce n'est pas un fichier d'analyse mais il permet de creer les figures des mesures utilisees pour la calibration	

Il est important de vérifier que les données sont correctes c'est à dire que :
* la droite UH est linéaire et qu'elle comporte des differences de charges négatives et positives. 
* Les différences de pression entra la  nappe et la rivières sont de quelques centimètres généralement. 
* Il est important de faire des mesures tous les centimètres entre -20 et +20 cm puis tous les 5 cm entres -20 et la saturation du capteur et entre +20 et la saturation du capteur.



## Formatage des données
"scripts_R" est le dossier contenant tous les scripts pour les analyses.	

	1) 1_rawToFormatted.R : cherche les donnees de calibration dans les differents fichiers et met tout sous forme formattee (date-tension-temperature-deltaH par fichier)


		* Ce dossier contient les donnees formattees : 4 colonnes (dates, tension, deltaH, temperature)
		* Ces donnees peuvent ensuite etre traitees a la main pour regler les eventuels problemes (filtrage des series en chambre, reglage de l'offset).

	2) 1bis_filterClimaticChamber.R 


		* filtre les données prises en chambre climatique. A partir des séries de la chambre climatique, ce script décompose les variations de température en périodes de variations linéaires et effectue un fit linéraire du signal de tension correspondant.
		* enregistre les coefficients des calibrations U-T dans calib/[capteur]/intermediate
        * sortie fichier filtré
	
	3) 1bis2_arrangeOffset.R : pour certains capteurs, arranger l'offset des series U-T de maniere a recaler avec la relation U-H
        * Le numero du capteur doit être indiqué dans l'entete du fichier ligne 8 ex: sensor = 'p3'
	4) 1ter_plotFormatted.R 
 * plot les séries correspondant aux données dans 2_formatted_data et enregistre dans plots/
	
	
	4) 2_formattedToProcessed.R : script qui prend les donnees dans 2_formatted_data, les rassemble dans un seul fichier enregistre dans 3_processed_data.
	* processedToCalib.R : script lisant les données processées et effectuant les calibrations. Il fait les calibrations 
			U-H enregistrees dans calib/[capteur]/intermediate
			UHT (finales) enregistrees dans calib/[capteur]
	* 2bis_plot_processed.R : plot les séries correspondant aux données dans 3_processed_data et enregistre dans plots/
	

## Traitement des données
* 3_processed_data contient un fichier par capteur avec toutes les donnees qui vont servir aux relations lineaires de la calibration.
	Le but de cette premiere etape est de mettre de cote les donnees qui ne seront pas exploitables pour les calibrations.

	

* "calib" contient les fichiers de resultat de la calibration. Ces fichiers suivent un format bien defini et sont ensuite lus par les scripts treat_molonari_mini_field pour transformer les mesures tension-temperature en pression differentielle.







##  Scripts supplémentaires servant à l'analyse

	* errorAnalysis.R : script qui fait l'etude des erreurs et qui met en evidence l'erreur faite si on neglige l'effet de la temperature
	* plotCoefsCalib.R : script qui trace les coefficients des pentes U-T en fonction des capteurs et des differentiels de pression.	
	* UvsT.R : script qui trace les series tension-temperature
	* plot_field_checkCalib.R : compare les séries de pression sur le terrain, avec et sans la compensation en température
	
