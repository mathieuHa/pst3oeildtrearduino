#!/usr/bin/env bash
#------------------------------------#
#### Mise à jour de la raspberry #####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Mise à jour de la Raspberry -- Changement du mot de passe"
echo "----------------------------------------------------------"

setxkbmap fr # clavier en français
sudo passwd ## changement du mot de passe de la raspberry default=raspberry ON NE MET PAS ROOT
sudo apt-get update
sudo apt-get -y upgrade

#------------------------------------#
#### Installation de VNC SSH VNC CAMERA ENABLED #####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation de VNC SSH VNC CAMERA ENABLED"
echo "----------------------------------------------------------"

# CREATION D'UN COMPTE VNC GRATUIT AJOUT DE LA RASP

sudo apt-get install -y realvnc-vnc-server realvnc-vnc-viewer
sudo raspi-config

# Dans advanced option on met VNC SSH et CAMERA a activé = yes#
# mettre clavier et langue a français
# resolution DMT mode 82
# GPU 128
sudo reboot
sudo systemctl enable vncserver-x11-serviced.service
sudo reboot


#------------------------------------#
#### Installation du serveur Web et autre tools ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation du serveur web, php, mysql et phpmyadmin"
echo "----------------------------------------------------------"

sudo apt-get install -y apache2
sudo chown -R pi:www-data /var/www/html/
sudo chmod -R 770 /var/www/html/

sudo apt-get install -y php5
sudo apt-get install -y mysql-server php5-mysql
sudo apt-get install -y phpmyadmin

sudo reboot

#------------------------------------#
#### Installation DE RPI_CAMERA_WEB_INTERFACE ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation de RPi_Cam_Web_Interface dans /var/www/html/camera"
echo "----------------------------------------------------------"

cd
mkdir oeildtre
cd oeildtre

git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git
cd RPi_Cam_Web_Interface
sudo chmod u+x *.sh
sudo ./install.sh
ou autre installer vérifer que ça marche

/etc/apache2/sites-available modifier /var/www/html dans raspicam.conf

# Il faut absolument l'installer dans /var/www/html/camera et non dans /var/www/html/camera
# La suppression de ce soft supprimera tout ce qui se trouve dans /var/www/html

#------------------------------------#
#### Installation du Stream Video ####
#------------------------------------#

echo "----------------------------------------------------------"
echo " Installation du Stream Video"
echo "----------------------------------------------------------"


cd
cd oeildtre
sudo apt-get -y install libjpeg8-dev imagemagick libv4l-dev
sudo ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h
wget http://sourceforge.net/code-snapshots/svn/m/mj/mjpg-streamer/code/mjpg-streamer-code-182.zip
unzip mjpg-streamer-code-182.zip
cd mjpg-streamer-code-182/mjpg-streamer
make mjpg_streamer input_file.so output_http.so
sudo cp mjpg_streamer /usr/local/bin
sudo cp output_http.so input_file.so /usr/local/lib/

cd ../../
rm -rf mjpg-streamer-182

/usr/local/bin/mjpg_streamer -i "/usr/local/lib/input_file.so -f /run/shm/mjpeg -n cam.jpg" -o "/usr/local/lib/output_http.so -p 8090 -w /var/www/html"


#------------------------------------#
#### Installation d'outils PHP utile à Symfony ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation de composer"
echo "----------------------------------------------------------"

# Composer : gestionnaire de dépendances #

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php')
===
'669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410')
{ echo 'Installer verified'; }
else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer # install composer globally


#------------------------------------#
#### Installation de l'API ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation de l'API"
echo "----------------------------------------------------------"

cd /var/www/html
git clone https://github.com/mathieuHa/pst3oeildtre.git
cd pst3oeildtre
composer install # installation des librairies utilisé par symfony pour l'API
# Some parameters are missing. Please provide them.
# database_host (127.0.0.1):
# database_port (null):
# database_name (symfony): oeildtre
# database_user (root):
# database_password (null): ******
# mailer_transport (smtp):
# mailer_host (127.0.0.1):
# mailer_user (null): mathieu.hanotaux@gmail.com
# mailer_password (null): ******
# secret (ThisTokenIsNotSoSecretChangeIt):

echo "Création de la base de données"

php bin/console doctrine:database:create
# Created database `oeildtre` for connection named default

echo "Ecriture du schema dans la base de données"

php bin/console doctrine:schema:update --force --dump-sql
# Updating database schema...
# Database schema updated successfully! "9" queries were executed

# Now that the database is created we can finish the composer installation
composer install
# [OK] Cache for the "dev" environment (debug=true) was successfully cleared.
# [OK] All assets were successfully installed.

echo "Chargement des fixtures/fake-data dans la base de données"

# Chargement des données tests dans la base de donnée
echo y | php bin/console doctrine:fixtures:load
#Careful, database will be purged. Do you want to continue y/N ?y
# > purging database
# > loading DTRE\OeilBundle\DataFixtures\ORM\LoadDataData

# ajout des permissions pour le cache de symfony #
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var

#------------------------------------#
#### Installation du site web ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation du site Web"
echo "----------------------------------------------------------"

cd /var/www/html
git clone https://github.com/mathieuHa/pst3oeildtresite.git
cd pst3oeildtresite
composer install # installation des librairies utilisé par symfony par le site web

# Some parameters are missing. Please provide them.
# database_host (127.0.0.1):
# database_port (null):
# database_name (symfony): oeildtresite
# database_user (root):
# database_password (null): ******
# mailer_transport (smtp):
# mailer_host (127.0.0.1):
# mailer_user (null): mathieu.hanotaux@gmail.com
# mailer_password (null): ******
# secret (ThisTokenIsNotSoSecretChangeIt):

echo "Création de la base de données"

php bin/console doctrine:database:create
# Created database `oeildtre` for connection named default

echo "Ecriture du schema dans la base de données"

php bin/console doctrine:schema:update --force --dump-sql
# Updating database schema...
# Database schema updated successfully! "5" queries were executed

# Now that the database is created we can finish the composer installation
composer install
# [OK] Cache for the "dev" environment (debug=true) was successfully cleared.
# [OK] All assets were successfully installed.

echo "Mise à jour des permissions pour le site web"

# ajout des permissions pour le cache de symfony #
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var

echo "----------------------------------------------------------"
echo "Installation de NPM bower"
echo "----------------------------------------------------------"


sudo apt-get install -y npm # gestionnaire de paquet nodejs
sudo npm install bower -g # gestionnaire de librairies javascripts / gestion des assets

bower install

php bin/console cache:clear

# gestion de l'arduino #

echo "----------------------------------------------------------"
echo "Installation de service nodejs nécessaires"
echo "----------------------------------------------------------"

cd
cd oeildtre/

git clone https://github.com/mathieuHa/pst3oeildtrearduino.git
cd pst3oeildtrearduino

npm install serialport --build-from-source
sudo npm install fs -g
sudo npm install http -g
sudo npm install socket.io

# lancement #

echo "----------------------------------------------------------"
echo "lancement de l'Application"
echo "----------------------------------------------------------"

echo "----------------------------------------------------------"
echo "Serveur NodeJS"
echo "----------------------------------------------------------"

cd /home/pi/oeildtre/pst3oeildtrearduino
node app.js
node servo.js


#------------------------------------#
#### Installation du crontab backup et relancement du serveur nodejs et stream ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation du crontab backup et relancement du serveur nodejs et stream"
echo "----------------------------------------------------------"

cd /home/pi/oeildtre/pst3oeildtrearduino
mkdir backup

sudo nano backup.sh
# Changer MOT_DE_PASSE par le mot de passe choisi pour la base de donnée
chmod +x backup.sh
chmod +x watchdogapp.sh
chmod +x watchdogservo.sh
chmod +x watchdogstream.sh

# ATTENTION Ajout en bas du fichier crontab des lignes suivantes sans les executer dans le terminal
0 0 * * * /bin/sh /home/pi/oeildtre/pst3oeildtrearduino/backup.sh
* * * * * /bin/sh /home/pi/oeildtre/pst3oeildtrearduino/watchdogapp.sh
* * * * * /bin/sh /home/pi/oeildtre/pst3oeildtrearduino/watchdogservo.sh
* * * * * /bin/sh /home/pi/oeildtre/pst3oeildtrearduino/watchdogstream.sh

#Pour cela lancer :
crontab -e
# Et copier coller les 4 lignes au dessus en bas du fichier

#Pour visualiser si cela a bien marché on tape :
crontab -l
# on devrait voir apparaitre les 4 lignes précédantes

#------------------------------------#
#### Installation de l'espace de stockage des images/videos ####
#------------------------------------#

echo "----------------------------------------------------------"
echo "Installation de l'espace de stockage des images/videos"
echo "----------------------------------------------------------"

cd /var/www/html/pst3oeildtre/web/media
ln -s /media/usb0/ data

