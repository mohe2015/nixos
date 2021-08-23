sudo systemd-analyze security
sudo systemd-analyze security apache2.service # pretty bad



TODO FIREWALL PREVENT OUTGOING CONNECTIONS



security scans (preferably from a livecd):

https://wiki.ubuntuusers.de/ClamAV/

https://packages.debian.org/de/sid/lynis

https://wiki.ubuntuusers.de/chkrootkit/

https://wiki.ubuntuusers.de/rkhunter/



sudo netstat --wide -altpe



# hetzner.cloud
# nürnberg, ubuntu 20.04, cpx11, ssh key, backups

ssh root@78.47.174.150

sudo apt update
sudo apt upgrade
sudo reboot

 
# create nonroot user
sudo adduser moritz # use a super secure password
sudo usermod -aG sudo moritz
sudo cp -r .ssh /home/moritz/ # authorized_keys
sudo chown -R moritz:moritz /home/moritz/.ssh

exit
ssh moritz@116.203.70.203 -p 2222



# https://wiki.debian.org/SSH
sudo nano /etc/ssh/sshd_config

Port 2222
PermitRootLogin prohibit-password
PasswordAuthentication no
AllowUsers moritz root

sudo service ssh restart



# firewall
# https://wiki.debian.org/DebianFirewall
# https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222
sudo ufw status verbose
sudo ufw enable

# https://wiki.debian.org/UnattendedUpgrades
sudo apt-get install unattended-upgrades apt-listchanges
sudo dpkg-reconfigure -plow unattended-upgrades

# fail2ban


# https://wiki.debian.org/SystemAdministration
## https://wiki.debian.org/SystemConfiguration
## https://wiki.debian.org/ConfigurationHandling
# https://debian-handbook.info/
# https://wiki.debian.org/SystemMonitoring

# https://wiki.debian.org/SecurityManagement
# https://www.debian.org/doc/user-manuals#securing # PROBABLY VERY GOOD, no its not

# subscribe to https://lists.debian.org/debian-security-announce/

# https://wiki.debian.org/ServiceSandboxing

# TODO https://wiki.debian.org/BackupAndRecovery

# TODO use AppArmor or SELinux, I assume AppArmor is easier to use

# TODO /etc/security/limits.conf

# TODO logging of all actions?

# TODO automatic log analysis like logcheck

# hardened kernel?

# filesystem quotas to prevent out of disk space?

# https://www.debian.org/doc/manuals/securing-debian-manual/automatic-harden.en.html

# https://wiki.debian.org/Hardening

# train for an attack: power off, recovery system, investigate, reinstall



sudo apt install apache2
sudo ufw allow www

sudo apt install php-fpm
sudo a2enmod proxy_fcgi setenvif headers
sudo a2enconf php7.3-fpm
sudo systemctl restart apache2


# https://wiki.debian.org/MySql
sudo apt install mariadb-server
sudo mysql_secure_installation



# TODO hardening apache, php, mariadb, 



# https://wordpress.org/support/article/hardening-wordpress/

cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo mv wordpress/ /var/www/aes-freundeskreis.de
# https://wordpress.org/support/article/how-to-install-wordpress/

sudo mysql
CREATE USER 'wordpress.aes-freundeskreis.de'@'localhost' IDENTIFIED VIA unix_socket;
CREATE DATABASE `wordpress.aes-freundeskreis.de`;
GRANT ALL PRIVILEGES ON `wordpress.aes-freundeskreis.de` . * TO `wordpress.aes-freundeskreis.de`@`localhost`;
FLUSH PRIVILEGES;




# https://certbot.eff.org/lets-encrypt/debianbuster-apache
sudo apt install certbot python-certbot-apache

sudo certbot run -a manual -i apache -d *.selfmade4u.de




# google link:www.yoursite.com









sudo nano /etc/php/7.3/fpm/php.ini
opcache.validate_permission=1
opcache.validate_root=1
# http://git.php.net/?p=php-src.git;a=blobdiff;f=ext/opcache/README;h=d5513c51cea1559ae6016d825c58e31178517fea;hp=693a7b4e3cc0a2a58e74130d0c0a8f37f6fdbbe2;hb=ecba563f2fa1e027ea91b9ee0d50611273852995;hpb=e922d89f667a228e440ef089ba4a81a7eb817816





sudo nano /etc/php/7.3/fpm/pool.d/wordpress.aes-freundeskreis.de.conf
[wordpress.aes-freundeskreis.de]
user = wordpress.aes-freundeskreis.de
group = wordpress.aes-freundeskreis.de
listen = /run/php/php7.3-fpm-wordpress.aes-freundeskreis.de.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 20
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3


sudo useradd --system wordpress.aes-freundeskreis.de


sudo cp /etc/apache2/conf-available/php7.3-fpm.conf /etc/apache2/conf-available/php7.3-fpm-wordpress.aes-freundeskreis.de.conf
sudo nano /etc/apache2/conf-available/php7.3-fpm-wordpress.aes-freundeskreis.de.conf
# edit unix socket path



sudo systemctl restart php7.3-fpm



sudo a2disconf php7.3-fpm


sudo nano /etc/apache2/sites-available/wordpress.aes-freundeskreis.de.conf

<VirtualHost *:80>
    ServerAdmin Moritz.Hedtke@t-online.de
    ServerName beta.aes-freundeskreis.de
    # ServerAlias aes-freundeskreis.de beta.aes-freundeskreis.de
    DocumentRoot /var/www/wordpress.aes-freundeskreis.de
    DirectoryIndex index.php index.html
    ErrorLog /var/log/apache2/wp-error.log
    TransferLog /var/log/apache2/wp-access.log
    Include conf-available/php7.3-fpm-wordpress.aes-freundeskreis.de.conf
    
    <Directory /var/www/wordpress.aes-freundeskreis.de>
        AllowOverride All
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>

sudo a2ensite wordpress.aes-freundeskreis.de.conf

sudo apache2ctl configtest

sudo ufw allow WWW
sudo ufw allow "WWW Secure"
sudo ufw status

sudo certbot run -a manual -i apache -d *.aes-freundeskreis.de



sudo apt install php-mysql php-curl php-xml php-mbstring php-imagick php-zip php-gd php-bcmath
# wordpress config
# database name: wordpress.aes-freundeskreis.de
# username: wordpress.aes-freundeskreis.de
# host: localhost:/run/mysqld/mysqld.sock
# table prefix: wpaesfk_

# custom table prefix for security through obscurity
# custom admin username for security through obscurity



sudo nano /var/www/wordpress.aes-freundeskreis.de/wp-config.php

define('FS_METHOD', 'direct');
define('DISALLOW_FILE_EDIT', true);






find /var/www/wordpress.aes-freundeskreis.de -type d -exec chmod 755 {} \;
find /var/www/wordpress.aes-freundeskreis.de -type f -exec chmod 644 {} \;

sudo chown -R wordpress.aes-freundeskreis.de:wordpress.aes-freundeskreis.de /var/www/wordpress.aes-freundeskreis.de

# install gutenberg and site health


# https://wordpress.org/support/article/htaccess/
# https://wordpress.org/support/article/hosting-wordpress/
# https://wordpress.org/support/article/hardening-wordpress/

# https://htaccess.madewithlove.be/
# Block the include-only files.

sudo nano /var/www/wordpress.aes-freundeskreis.de/.htaccess

RewriteEngine On
RewriteBase /
RewriteRule ^wp-admin/includes/ - [F,L]
RewriteRule !^wp-includes/ - [S=3]
RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
RewriteRule ^wp-includes/theme-compat/ - [F,L]


# Zugriff verweigern
<FilesMatch "(\.htaccess|\.htpasswd)">
  Order deny,allow
  Deny from all
</FilesMatch>
# Konfigurationsdatei schützen
<files wp-config.php>
Order allow,deny
Deny from all
</files>
# Schnittstelle abstellen
<Files xmlrpc.php>
 Order Deny,Allow
 Deny from all
</Files>

Header set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header set Referrer-Policy "same-origin"
Header set X-XSS-Protection "1; mode=block"
Header set x-frame-options "SAMEORIGIN"
Header set X-Content-Type-Options "nosniff"
Header set Permissions-Policy "geolocation=()"
Header set Content-Security-Policy "default-src 'none'; connect-src 'self'; font-src 'self' data: https://fonts.gstatic.com; form-action 'self'; frame-src 'self' https://selfmade4u.de; img-src 'self' data: https://secure.gravatar.com; media-src data:; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com/; base-uri 'none'"


#<Files wp-login.php>
#  AuthName "Protected Admin-Area"
#  AuthType Basic
#  AuthUserFile /der/genaue/pfad/zu/wp/.htpasswd
#  Require valid-user
#</Files>

# needed if some plugins dont work
#<Files admin-ajax.php>
#Order allow,deny
#Allow from all
#Satisfy any
#</Files>

#htpasswd -c /tmp/test testuser




sudo nano wp-content/uploads
<FilesMatch ".+\.ph(ar|p|tml|ps)$">
deny from all
</FilesMatch>












# TODO FIXME backups and recovery strategy




















sudo apt-get install libapache2-mod-security2
sudo a2enmod security2
sudo systemctl force-reload apache2

# https://coreruleset.org/installation/
curl -OL https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
sudo mv coreruleset-3.3.0/ /etc/apache2/coreruleset
cd /etc/apache2/coreruleset
mv crs-setup.conf.example crs-setup.conf


sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/apache2/conf-available/modsecurity.conf 
sudo cp /etc/modsecurity/unicode.mapping /etc/apache2/conf-enabled

sudo nano /etc/apache2/conf-available/coreruleset.conf
Include coreruleset/crs-setup.conf
Include coreruleset/rules/*.conf

sudo a2enconf modsecurity coreruleset
sudo systemctl restart apache2


sudo nano /etc/apache2/conf-available/modsecurity.conf
SecRuleEngine On # actually enable blocking

# https://owasp.org/www-project-modsecurity-core-rule-set/
# https://github.com/SpiderLabs/ModSecurity/wiki#Installation_for_Apache


# https://www.netnea.com/cms/apache-tutorial-5_extending-access-log/
# https://www.netnea.com/cms/apache-tutorial-8_handling-false-positives-modsecurity-core-rule-set/












https://www.digitalocean.com/community/tutorials/how-to-install-phpmyadmin-from-source-debian-10
cd /tmp
# 5.0 doesn't work with php 7.3 because of a known bug in php
curl -OL https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.xz
curl -OL https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.xz.asc
gpg --keyserver keyserver.ubuntu.com --recv-keys 3D06A59ECE730EB71B511C17CE752F178259BD92
gpg --verify phpMyAdmin-4.9.5-english.tar.xz.asc
tar xf phpMyAdmin-4.9.5-english.tar.xz
sudo mv phpMyAdmin-4.9.5-english /var/www/phpmyadmin






sudo nano /etc/php/7.3/fpm/pool.d/db.selfmade4u.de.conf
[db.selfmade4u.de]
user = db.selfmade4u.de
group = db.selfmade4u.de
listen = /run/php/php7.3-fpm-db.selfmade4u.de.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 20
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3


sudo useradd --system db.selfmade4u.de


sudo cp /etc/apache2/conf-available/php7.3-fpm.conf /etc/apache2/conf-available/php7.3-fpm-db.selfmade4u.de.conf
sudo nano /etc/apache2/conf-available/php7.3-fpm-db.selfmade4u.de.conf
# edit unix socket path



sudo systemctl restart php7.3-fpm





sudo nano /etc/apache2/sites-available/db.selfmade4u.de.conf
<VirtualHost *:80>
    ServerAdmin Moritz.Hedtke@t-online.de
    ServerName db.selfmade4u.de
    # ServerAlias www.db.selfmade4u.de db.selfmade4u.de
    DocumentRoot /var/www/phpmyadmin
    DirectoryIndex index.php
    ErrorLog /var/log/apache2/db.selfmade4u.de-error.log
    TransferLog /var/log/apache2/db.selfmade4u.de-access.log
    Include conf-available/php7.3-fpm-db.selfmade4u.de.conf
        
    <Directory /var/www/phpmyadmin>
        Options FollowSymLinks

        AuthType Basic
        AuthName "Restricted Files"
        AuthUserFile /var/www/.htpasswd-phpmyadmin
        Require valid-user
    </Directory>
</VirtualHost>

sudo htpasswd -c /var/www/.htpasswd-phpmyadmin moritz


sudo a2ensite db.selfmade4u.de.conf


sudo certbot run -a manual -i apache -d *.selfmade4u.de


sudo systemctl restart apache2



sudo mysql
CREATE USER 'db.selfmade4u.de'@'localhost' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON * . * TO `db.selfmade4u.de`@`localhost`;
FLUSH PRIVILEGES;







sudo nano /etc/php/7.3/fpm/php.ini
upload_max_filesize = 1024M
post_max_size = 1024M



sudo systemctl restart php7.3-fpm.service






# do a database backup




scp -r moritz@selfmade4u.de:/var/www/wordpress/wp-content/ selfmade4u.de-wp-content




aes-freundeskreis.de id=5

# WARNING: phpmyadmin has a bug when you select a subset of tables and then do a quick export it will keep that subset - possible loss of data


# check used plugins and themes and install them on new site (no need to activate)




# phpmyadmin export all wp_5_
# export wp_users and wp_usermeta separately



# import
# select all tables, replace table prefix
from: wp_5
to: wpaesfk

# import users and replace table prefix





curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress.aes-freundeskreis.de/
sudo -u wordpress.aes-freundeskreis.de wp search-replace wp_1_ deleteme_
sudo -u wordpress.aes-freundeskreis.de wp search-replace wp_2_ deleteme_
sudo -u wordpress.aes-freundeskreis.de wp search-replace wp_3_ deleteme_
sudo -u wordpress.aes-freundeskreis.de wp search-replace wp_4_ deleteme_

sudo -u wordpress.aes-freundeskreis.de wp db search wp_5_
sudo -u wordpress.aes-freundeskreis.de wp search-replace wp_5_ wpaesfk_

# wp_page_for_privacy_policy seems fine
sudo -u wordpress.aes-freundeskreis.de wp db query 'SELECT option_name FROM wpaesfk_options WHERE option_name like "wp_%"'
# sudo -u wordpress.aes-freundeskreis.de wp db query 'UPDATE wpaesfk_options SET option_name = "wpaesfk_user_roles" where option_name = "wp_user_roles";'

# TODO wp_dashboard_quick_press_last_post_id ? wp_user-settings ? wp_user-settings-time ? wp_media_library_mode ?
sudo -u wordpress.aes-freundeskreis.de wp db query 'SELECT meta_key FROM wpaesfk_usermeta WHERE meta_key like "wp_%"'
sudo -u wordpress.aes-freundeskreis.de wp db query 'UPDATE wpaesfk_usermeta SET meta_key = "wpaesfk_capabilities" where meta_key = "wp_capabilities";'
sudo -u wordpress.aes-freundeskreis.de wp db query 'UPDATE wpaesfk_usermeta SET meta_key = "wpaesfk_user_level" where meta_key = "wp_user_level";'
sudo -u wordpress.aes-freundeskreis.de wp db query 'UPDATE wpaesfk_usermeta SET meta_key = "wpaesfk_autosave_draft_ids" where meta_key = "wp_autosave_draft_ids";'

wp_options and wp_usermeta needs to change these prefixes but for some reason this does not work for all keys



# go into wpaesfk_options
# change siteurl and home to new place

sudo -u wordpress.aes-freundeskreis.de wp db search 'aes-freundeskreis.de'
sudo -u wordpress.aes-freundeskreis.de wp search-replace 'aes-freundeskreis.de' 'beta.aes-freundeskreis.de'



sudo -u wordpress.aes-freundeskreis.de wp db search '/wp-content/uploads/sites/5/'
sudo -u wordpress.aes-freundeskreis.de wp search-replace '/wp-content/uploads/sites/5/' '/wp-content/uploads/'


sudo -u wordpress.aes-freundeskreis.de wp db search 'wp-content/uploads'


scp -P 2222 -r selfmade4u.de-wp-content/uploads/sites/5/ moritz@116.203.70.203:/tmp/wordpress-5

sudo -u wordpress.aes-freundeskreis.de cp -r /tmp/wordpress-5/* /var/www/wordpress.aes-freundeskreis.de/wp-content/uploads/


# manually enable plugins in wp-admin

# enable auto updates










# TODO backups

rsync --rsh=ssh 













# albertforfuture.de

cd /tmp
sudo apt install git
git clone https://github.com/mohe2015/albertforfuture.de
sudo mv albertforfuture.de /var/www/
cd /var/www/albertforfuture.de/











sudo curl -L -O https://github.com/gohugoio/hugo/releases/download/v0.76.3/hugo_extended_0.76.3_Linux-64bit.deb
sudo dpkg -i hugo_extended_0.76.3_Linux-64bit.deb
#sudo apt install sqlite3
sudo apt install npm
npm install
BASE_URL=https://beta.albertforfuture.de/ npm run build



sudo nano /etc/apache2/sites-available/albertforfuture.de.conf

<VirtualHost *:80>
    ServerAdmin Moritz.Hedtke@t-online.de
    ServerName beta.albertforfuture.de
    # ServerAlias albertforfuture beta.albertforfuture
    DocumentRoot /var/www/albertforfuture.de/public_fix_mtime
    DirectoryIndex index.html
    ErrorLog /var/log/apache2/albertforfuture.de-error.log
    TransferLog /var/log/apache2/albertforfuture.de-access.log
    
    <Directory /var/www/albertforfuture.de/public_fix_mtime>
        Require all granted
    </Directory>
</VirtualHost>

sudo a2ensite albertforfuture.de.conf

sudo certbot run -a manual -i apache -d *.albertforfuture.de






node send-push.mjs '{"text": "Der Artikel thisistawesome ist online!", "url": "/thisisawesome/"}'






# alberts-blatt.de wpab_ id=4




# DO THE SAME WITH WORDPRESS sv.selfmade4u.de, 



TODO FIXME CHECK THAT I DIDNT FUCK UP SEARCH INDEXING




cd /var/www/wordpress.aes-freundeskreis.de/
sudo -u wordpress.aes-freundeskreis.de wp search-replace 'beta.aes-freundeskreis.de' 'aes-freundeskreis.de'
# change apache config (keep in mind to change both .conf and -le-ssl.conf)
sudo nano /etc/apache2/sites-enabled/wordpress.aes-freundeskreis.de.conf
sudo certbot run -a apache -i apache -d aes-freundeskreis.de -d *.aes-freundeskreis.de
sudo systemctl restart apache2.service


cd /var/www/wordpress.sv.selfmade4u.de
sudo -u wordpress.sv.selfmade4u.de wp search-replace 'beta.sv.selfmade4u.de' 'sv.selfmade4u.de'
# change apache config (keep in mind to change both .conf and -le-ssl.conf)
sudo nano /etc/apache2/sites-enabled/wordpress.sv.selfmade4u.de.conf
sudo certbot run -a apache -i apache -d *.selfmade4u.de
sudo systemctl restart apache2.service


cd /var/www/alberts-blatt.de
sudo -u wordpress.alberts-blatt.de wp search-replace 'beta.alberts-blatt.de' 'alberts-blatt.de'
# change apache config (keep in mind to change both .conf and -le-ssl.conf)
sudo nano /etc/apache2/sites-enabled/wordpress.alberts-blatt.de.conf
sudo certbot run -a apache -i apache -d alberts-blatt.de -d *.alberts-blatt.de
sudo systemctl restart apache2.service



BASE_URL=https://albertforfuture.de/ npm run build
# change apache config (keep in mind to change both .conf and -le-ssl.conf)
sudo nano /etc/apache2/sites-enabled/albertforfuture.de.conf
sudo certbot run -a apache -i apache -d albertforfuture.de -d *.albertforfuture.de
sudo systemctl restart apache2.service

# update dns



sudo nano /etc/apache2/conf-available/modsecurity.conf
SecRuleEngine On # actually enable blocking










sudo cp -r /var/www/ /home/moritz/www
scp -r -P 2222 moritz@116.203.70.203:~/www debian_www

# database backup from phpmyadmin















cd /var/www/wordpress.sv.selfmade4u.de/

# Elementor -> Settings -> Advanced to regenerate cached css files


sudo usermod -a -G sudo www-data


rsync -e 'ssh -p 2222' --archive --progress root@selfmade4u.de:/var/www/ www
rsync -e 'ssh -p 2222' --archive --progress root@selfmade4u.de:/etc/apache2/ etc-apache
rsync -e 'ssh -p 2222' --archive --progress root@selfmade4u.de:/etc/php/ etc-php





















cd /tmp
curl -O https://download.nextcloud.com/server/releases/nextcloud-20.0.0.tar.bz2
curl -O https://download.nextcloud.com/server/releases/nextcloud-20.0.0.tar.bz2.asc
curl -O https://nextcloud.com/nextcloud.asc
gpg --import nextcloud.asc
gpg --verify nextcloud-20.0.0.tar.bz2.asc
tar xf nextcloud-20.0.0.tar.bz2
sudo mv nextcloud /var/www/cloud.selfmade4u.de




sudo nano /etc/php/7.3/fpm/pool.d/cloud.selfmade4u.de.conf
[cloud.selfmade4u.de]
user = cloud.selfmade4u.de
group = cloud.selfmade4u.de
listen = /run/php/php7.3-fpm-cloud.selfmade4u.de.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 20
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3


sudo useradd --system cloud.selfmade4u.de


sudo cp /etc/apache2/conf-available/php7.3-fpm.conf /etc/apache2/conf-available/php7.3-fpm-cloud.selfmade4u.de.conf
sudo nano /etc/apache2/conf-available/php7.3-fpm-cloud.selfmade4u.de.conf
# edit unix socket path



sudo systemctl restart php7.3-fpm

# nextcloud doesnt support dots in database name
sudo mysql
CREATE USER 'cloud.selfmade4u.de'@'localhost' IDENTIFIED VIA unix_socket;
CREATE DATABASE `cloudselfmade4ude`;
GRANT ALL PRIVILEGES ON `cloudselfmade4ude` . * TO `cloud.selfmade4u.de`@`localhost`;
FLUSH PRIVILEGES;


sudo nano /etc/apache2/sites-available/cloud.selfmade4u.de.conf
<VirtualHost *:80>
    ServerAdmin Moritz.Hedtke@t-online.de
    ServerName cloud.selfmade4u.de
    DocumentRoot /var/www/cloud.selfmade4u.de
    DirectoryIndex index.php
    ErrorLog /var/log/apache2/cloud.selfmade4u.de-error.log
    TransferLog /var/log/apache2/cloud.selfmade4u.de-access.log
    Include conf-available/php7.3-fpm-cloud.selfmade4u.de.conf
        
    <Directory /var/www/cloud.selfmade4u.de>
        Require all granted
        AllowOverride All
        Options FollowSymLinks MultiViews

        <IfModule mod_dav.c>
        Dav off
        </IfModule>
    </Directory>
</VirtualHost>


sudo a2ensite cloud.selfmade4u.de

sudo certbot run -a manual -i apache -d *.selfmade4u.de

sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
sudo a2enmod setenvif

sudo chown -R cloud.selfmade4u.de:www-data /var/www/cloud.selfmade4u.de

sudo apt install php-intl php-gmp php-apcu

sudo nano /etc/php/7.3/fpm/php.ini
memory_limit = 512M



# dont use admin as username

database user: cloud.selfmade4u.de
database name: cloudselfmade4ude
url: localhost


    Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"

TODO https://docs.nextcloud.com/server/20/admin_manual/installation/harden_server.html



sudo nano config/config.php
'memcache.local' => '\OC\Memcache\APCu',
'htaccess.RewriteBase' => '/',

sudo -u cloud.selfmade4u.de php /var/www/cloud.selfmade4u.de/occ maintenance:update:htaccess








pm = dynamic
pm.max_children = 120
pm.start_servers = 12
pm.min_spare_servers = 6
pm.max_spare_servers = 18





/etc/mysql/conf.d/mysql.cnf

[mysqld]
innodb_buffer_pool_size=1G
innodb_io_capacity=4000






;env[HOSTNAME] = $HOSTNAME
;env[PATH] = /usr/local/bin:/usr/bin:/bin
;env[TMP] = /tmp
;env[TMPDIR] = /tmp
;env[TEMP] = /tmp








sudo nano /etc/apache2/coreruleset/crs-setup.conf
# It is recommended if you run multiple web applications on your site to limit
# the effects of the exclusion to only the path where the excluded webapp
# resides using a rule similar to the following example:
# SecRule REQUEST_URI "@beginsWith /wordpress/" setvar:tx.crs_exclusions_wordpress=1

#
# Modify and uncomment this rule to select which application:
#
SecAction \
 "id:900130,\
  phase:1,\
  nolog,\
  pass,\
  t:none,\
  setvar:tx.crs_exclusions_nextcloud=1,\
  setvar:tx.crs_exclusions_wordpress=1




sudo nano /etc/apache2/coreruleset/crs-setup.conf




sudo nano /etc/apache2/conf-enabled/modsecurity.conf 
# disable as nextcloud doesnt work at all properly


sudo a2enmod http2







sudo crontab -u cloud.selfmade4u.de -e

*/5  *  *  *  * php -f /var/www/cloud.selfmade4u.de/cron.php

sudo crontab -u cloud.selfmade4u.de -l


















sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0C54D189F4BA284D

sudo echo 'deb https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-debian10 ./' | sudo tee /etc/apt/sources.list.d/collabora-online.list

sudo apt update && sudo apt install loolwsd code-brand



sudo nano /etc/loolwsd/loolwsd.xml
ssl.enable=false
ssl.termination=true


sudo systemctl restart loolwsd


sudo a2enmod proxy_wstunnel

sudo a2enmod proxy_http


https://www.collaboraoffice.com/code/apache-reverse-proxy/


sudo nano /etc/apache2/sites-available/office.selfmade4u.de.conf


<VirtualHost *:80>
  ServerName office.selfmade4u.de

  # Encoded slashes need to be allowed
  AllowEncodedSlashes NoDecode

  # Container uses a unique non-signed certificate
  SSLProxyEngine On
  SSLProxyVerify None
  SSLProxyCheckPeerCN Off
  SSLProxyCheckPeerName Off

  # keep the host
  ProxyPreserveHost On

  # static html, js, images, etc. served from loolwsd
  # loleaflet is the client part of Collabora Online
  ProxyPass           /loleaflet http://127.0.0.1:9980/loleaflet retry=0
  ProxyPassReverse    /loleaflet http://127.0.0.1:9980/loleaflet

  # WOPI discovery URL
  ProxyPass           /hosting/discovery http://127.0.0.1:9980/hosting/discovery retry=0
  ProxyPassReverse    /hosting/discovery http://127.0.0.1:9980/hosting/discovery

  # Capabilities
  ProxyPass           /hosting/capabilities http://127.0.0.1:9980/hosting/capabilities retry=0
  ProxyPassReverse    /hosting/capabilities http://127.0.0.1:9980/hosting/capabilities

  # Main websocket
  ProxyPassMatch "/lool/(.*)/ws$" ws://127.0.0.1:9980/lool/$1/ws nocanon

  # Admin Console websocket
  ProxyPass   /lool/adminws ws://127.0.0.1:9980/lool/adminws

  # Download as, Fullscreen presentation and Image upload operations
  ProxyPass           /lool http://127.0.0.1:9980/lool
  ProxyPassReverse    /lool http://127.0.0.1:9980/lool
</VirtualHost>


sudo a2ensite office.selfmade4u.de.conf

sudo certbot --apache















https://www.netdata.cloud/




sudo nano /etc/apache2/sites-enabled/000-default.conf 
ServerName selfmade4u.de


/etc/apache2/sites-available/000-default-le-ssl.conf



sudo certbot run -a manual -i apache -d selfmade4u.de -d *.selfmade4u.de -d *.sv.selfmade4u.de -d alberts-blatt.de -d *.alberts-blatt.de -d albertforfuture.de -d *.albertforfuture.de -d aes-freundeskreis.de -d *.aes-freundeskreis.de



# set hostname of server

sudo hostnamectl set-hostname selfmade4u.de
sudo nano /etc/hosts

# dns add A mail.selfmade4u.de
# dns add mx @ to "50 mail.selfmade4u.de."
# dns 


sudo certbot certonly -d mail.selfmade4u.de --apache


https://www.digitalocean.com/community/tutorials/how-to-set-up-a-postfix-e-mail-server-with-dovecot


sudo apt install postfix
# Internet site
# system mail name: selfmade4u.de
sudo systemctl stop postfix



sudo nano /etc/aliases
mailer-daemon: postmaster
postmaster: root
nobody: root
hostmaster: root
usenet: root
news: root
webmaster: root
www: root
ftp: root
abuse: root
root: moritz


# run command
sudo newaliases


sudo nano /etc/postfix/master.cf

submission inet n       -       -       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth


sudo nano /etc/postfix/main.cf
# at the bottom
myhostname = mail.domain.com
myorigin = /etc/mailname
mydestination = mail.domain.com, domain.com, localhost, localhost.localdomain

smtpd_tls_cert_file=/etc/letsencrypt/live/mail.selfmade4u.de/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/mail.selfmade4u.de/privkey.pem
smtpd_tls_security_level=encrypt # illegal see RFC2487
smtpd_tls_protocols = >=TLSv1.2, <=TLSv1.3


sudo systemctl restart postfix


sudo apt install dovecot-core dovecot-imapd
sudo systemctl stop dovecot

https://doc.dovecot.org/configuration_manual/quick_configuration/
https://doc.dovecot.org/configuration_manual/howto/simple_virtual_install/
https://doc.dovecot.org/configuration_manual/protocols/lmtp_server/#lmtp-server



sudo nano /etc/dovecot/conf.d/10-master.conf
# umcomment postfix part
service auth {
 unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }
}


sudo nano /etc/dovecot/conf.d/10-ssl.conf
ssl_cert = </etc/letsencrypt/live/mail.selfmade4u.de/fullchain.pem
ssl_key = </etc/letsencrypt/live/mail.selfmade4u.de/privkey.pem


sudo systemctl restart dovecot



# TODO spf record
TXT @ "v=spf1 mx -all"


# add reverse dns
selfmade4u.de


https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy

sudo apt-get install opendkim opendkim-tools
sudo nano /etc/opendkim.conf




sudo nano /etc/postfix/main.cf
milter_protocol = 2
milter_default_action = accept
smtpd_milters = unix:/var/run/opendkim/opendkim.sock
non_smtpd_milters = unix:/var/run/opendkim/opendkim.sock




# TODO FIXME spamassasin or clamav, ...



check-auth@verifier.port25.com




sudo apt install mailutils


sudo ufw allow 25
sudo ufw allow 587
sudo ufw allow 143
sudo ufw allow 993


# dns imap.selfmade4u.de mail.selfmade4u.de
# dns smtp.selfmade4u.de mail.selfmade4u.de
# TODO FIXME mail autoconfiguration


# https://wiki.debian.org/Postfix


# TODO add AAAA records for everything

https://www.digitalocean.com/community/tutorials/how-to-configure-a-mail-server-using-postfix-dovecot-mysql-and-spamassassin



TODO
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy


TODO maybe https://doc.dovecot.org/configuration_manual/howto/postfix_and_dovecot_sasl/#howto-postfix-and-dovecot-sasl









sudo  apt-get install libsasl2-2 libsasl2-modules sasl2-bin


















