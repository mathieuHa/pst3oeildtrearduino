#!/bin/bash
#
## on se place dans le repertoire ou l'on veut sauvegarder les bases
#
cd /home/pi/oeildtre/pst3oeildtrearduino/backup

for i in oeildtre oeildtresite; do

## Sauvegarde des bases de donnees en fichiers .sql
mysqldump -uroot -pMOT_DE_PASSE ${i} > ${i}_`date +"%Y-%m-%d"`.sql

## Compression des exports en tar.bz2 (le meilleur taux de compression)
#tar jcf ${i}_`date +"%Y-%m-%d"`.sql.tar.bz2 ${i}_`date +"%Y-%m-%d"`.sql

## Suppression des exports non compresses
rm ${i}_`date +"%Y-%m-%d"`.sql

done
