# Partie 3 : Configuration et mise en place de NextCloud

## 1. Base de données

🌞 **Préparation de la base pour NextCloud**

```sql
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.006 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';
Query OK, 0 rows affected (0.007 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)
```

🌞 **Exploration de la base de données**
```bash
[gwuill@web ~]$ sudo dnf install mysql
Last metadata expiration check: 0:46:13 ago on Mon 12 Dec 2022 04:24:44 PM CET.
Package mysql-8.0.30-3.el9_0.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```
```bash
[gwuill@web ~]$ mysql -u nextcloud -h 10.105.1.12 -p
```
```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)

mysql> use nextcloud
Database changed

mysql> show tables;
Empty set (0.00 sec)
```
🌞 **Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données**

```sql
MariaDB [(none)]> SELECT user FROM mysql.user;
+-------------+
| User        |
+-------------+
| nextcloud   |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
4 rows in set (0.001 sec)
```

## 2. Serveur Web et NextCloud

⚠️⚠️⚠️ **N'OUBLIEZ PAS de réinitialiser votre conf Apache avant de continuer. En particulier, remettez le port et le user par défaut.**

🌞 **Install de PHP**

```bash
[gwuill@web ~]$ sudo dnf config-manager --set-enabled crb
[gwuill@web ~]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
[gwuill@web ~]$ dnf module list php
[gwuill@web ~]$ sudo dnf module enable php:remi-8.1 -y
[gwuill@web ~]$ sudo dnf install -y php81-php
```

🌞 **Install de tous les modules PHP nécessaires pour NextCloud**

```bash
# EDIT très récent : Rocky9 a été mis à jour et y'a un paquet nécessaire pour NextCloud qui n'est pu dispo :(
# on peut le récup à la main !
$ [gwuill@web ~]$ curl -SLO https://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/libhwy1-1.0.2-2.1.x86_64.rpm
$ [gwuill@web ~]$ sudo rpm -ivh libhwy1-1.0.2-2.1.x86_64.rpm

[gwuill@web ~]$ sudo dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
Complete!
```

🌞 **Récupérer NextCloud**

```bash
[gwuill@web ~]$ sudo mkdir /var/www/tp5_nextcloud/
```
```bash
[gwuill@web ~]$ curl -o nextcloud https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
```
```bash
[gwuill@web ~]$ sudo dnf install unzip -y 
```
```bash
[gwuill@web ~]$ sudo unzip nextcloud -d /var/www/tp5_nextcloud/
```
- **assurez-vous que le dossier `/var/www/tp2_nextcloud/` et tout son contenu appartient à l'utilisateur qui exécute le service Apache**
  - utilisez une commande `chown` si nécessaire

> A chaque fois que vous faites ce genre de trucs, assurez-vous que c'est bien ok. Par exemple, vérifiez avec un `ls -al` que tout appartient bien à l'utilisateur qui exécute Apache.

🌞 **Adapter la configuration d'Apache**

```bash
[gwuill@web ~]$ sudo cat /etc/httpd/conf.d/nextcloud.conf
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

🌞 **Redémarrer le service Apache** pour qu'il prenne en compte le nouveau fichier de conf

```bash
[gwuill@web ~]$ sudo systemctl restart httpd
```

## 3. Finaliser l'installation de NextCloud

🌞 **Exploration de la base de données**

```sql
MariaDB [(none)]> SELECT count(*) AS number FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'nextcloud';
+--------+
| number |
+--------+
|     95 |
+--------+
1 row in set (0.001 sec)
```
