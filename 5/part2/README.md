# Partie 2 : Mise en place et maîtrise du serveur de base de données

🌞 **Install de MariaDB sur `db.tp5.linux`**

```bash
[gwuill@db ~]$ sudo dnf install mariadb-server
[gwuill@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
[gwuill@db ~]$ sudo systemctl start mariadb
[gwuill@db ~]$ sudo mysql_secure_installation
```

🌞 **Port utilisé par MariaDB**

```bash
[gwuill@db ~]$ ss -alntp | grep 3306
LISTEN 0      80                 *:3306            *:*
```
```bash
[gwuill@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[gwuill@db ~]$ sudo firewall-cmd --reload
success
```

🌞 **Processus liés à MariaDB**

```bash
[gwuill@db ~]$ ps -ef | grep maria | head -1
mysql       3514       1  0 16:51 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
```

➜ **Une fois la db en place, go sur [la partie ".](../part3/README.md)**
