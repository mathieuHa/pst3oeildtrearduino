#------------------------------------#
#### Mise à jour de la raspberry #####
#------------------------------------#

sudo passwd ## changement du mot de passe de la raspberry default=raspberry
sudo apt-get update
sudo apt-get upgrade

#------------------------------------#
#### Installation du serveur Web et autre tools ####
#------------------------------------#

sudo apt-get install apache2
sudo chown -R pi:www-data /var/www/html/
sudo chmod -R 770 /var/www/html/

sudo apt-get install php
sudo apt-get install mysql-server php5-mysql
sudo apt-get install phpmyadmin

#------------------------------------#
#### Installation DE RPI_CAMERA_WEB_INTERFACE ####
#------------------------------------#

git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git
cd RPi_Cam_Web_Interface
chmod u+x *.sh
./install.sh

# Il faut absolument l'installer dans /var/www/html/camera et non dans /var/www/html/camera
# La suppression de ce soft supprimera tout ce qui se trouve dans /var/www/html

#------------------------------------#
#### Installation d'outils PHP utile à Symfony ####
#------------------------------------#

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

php bin/console doctrine:database:create
# Created database `oeildtre` for connection named default

php bin/console doctrine:schema:update --force --dump-sql
# Updating database schema...
# Database schema updated successfully! "9" queries were executed

# Now that the database is created we can finish the composer installation
composer install
# [OK] Cache for the "dev" environment (debug=true) was successfully cleared.
# [OK] All assets were successfully installed.      

# Chargement des données tests dans la base de donnée
php bin/console doctrine:fixtures:load
Careful, database will be purged. Do you want to continue y/N ?y
# > purging database
# > loading DTRE\OeilBundle\DataFixtures\ORM\LoadDataData

# ajout des permissions pour le cache de symfony #
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var

#------------------------------------#
#### Installation du site web ####
#------------------------------------#

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

php bin/console doctrine:database:create
# Created database `oeildtre` for connection named default

php bin/console doctrine:schema:update --force --dump-sql
# Updating database schema...
# Database schema updated successfully! "5" queries were executed

# Now that the database is created we can finish the composer installation
composer install
# [OK] Cache for the "dev" environment (debug=true) was successfully cleared.
# [OK] All assets were successfully installed. 

# ajout des permissions pour le cache de symfony #
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var

sudo apt-get install npm # gestionnaire de paquet nodejs
sudo npm install bower -g # gestionnaire de librairies javascripts / gestion des assets

bower install

php bin/console cache:clear

# gestion de l'arduino #

cd
mkdir oeildtre
cd oeildtre/

git clone https://github.com/mathieuHa/pst3oeildtrearduino.git
cd pst3oeildtrearduino

npm install serialport --build-from-source
npm install fs -g 
npm install http -g
npm install socket.io -g

# lancement #

cd 
cd oeildtre/
node app.js
node servo.js