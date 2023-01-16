## I. Script de backup

🌞 **Ecrire le script `bash`**

```bash
[gwuill@web ~]$ sudo cat /srv/tp6_backup.sh
#!/bin/bash
#Gwuill
#10/01/2023
#Auto BackUp service NextCloud
fileName="nextcloud_$(date +%Y%m%d%H%M%S).tar.gz"
tar -czf /srv/backup/$fileName /var/www/tp5_nextcloud/
echo "Filename : $fileName saved in /srv/backup"
```

```bash
[gwuill@web ~]$ sudo -u backup /srv/tp6_backup.sh
[gwuill@web ~]$ sudo -u backup /srv/tp6_backup.sh
Filename : nextcloud_20230116222129.tar.gz saved in /srv/backup
```

### 3. Service et timer

🌞 **Créez un *service*** système qui lance le script

```bash
[gwuill@web ~]$ sudo cat /etc/systemd/system/backup.service
[Unit]
Description=Backup script for nextcloud

[Service]
Type=oneshot
User=backup
ExecStart=/bin/bash /srv/tp6_backup.sh
```

```bash
[gwuill@web ~]$ sudo systemctl status backup
○ backup.service - Backup script for nextcloud
     Loaded: loaded (/usr/lib/systemd/system/backup.service; static)
     Active: inactive (dead)
TriggeredBy: ● backup.timer
```

🌞 **Créez un *timer*** système qui lance le *service* à intervalles réguliers

```bash
[gwuill@web ~]$ sudo cat /etc/systemd/system/backup.timer
[Unit]
Description=Run service X

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```

> [La doc Arch est cool à ce sujet.](https://wiki.archlinux.org/title/systemd/Timers)

🌞 Activez l'utilisation du *timer*

- vous vous servirez des commandes suivantes :

```bash
[gwuill@web ~]$ sudo systemctl daemon-reload
[gwuill@web ~]$ sud systemctl start backup.timer
[gwuill@web ~]$ sudo systemctl start backup.timer
[gwuill@web ~]$ sudo systemctl enable backup.timer
[gwuill@web ~]$ sudo systemctl status backup.timer
● backup.timer - Run service X
     Loaded: loaded (/etc/systemd/system/backup.timer; enabled; vendor preset: disabled)
     Active: active (waiting) since Mon 2023-01-16 21:58:20 CET; 31min ago
      Until: Mon 2023-01-16 21:58:20 CET; 31min ago
    Trigger: Tue 2023-01-17 04:00:00 CET; 5h 29min left
   Triggers: ● backup.service

Jan 16 21:58:20 web systemd[1]: Started Run backup.service.
[gwuill@web ~]$ sudo systemctl list-timers | grep backup
Tue 2023-01-17 04:00:00 CET 5h 28min left n/a                         n/a         backup.timer                 backup.service
```

## II. NFS

### 1. Serveur NFS

> On a déjà fait ça au TP4 ensemble :)

🖥️ **VM `storage.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

🌞 **Préparer un dossier à partager sur le réseau** (sur la machine `storage.tp6.linux`)

```bash
[gwuill@web backup]$ pwd
/srv/backup
```
```bash
[gwuill@storage web.tp6.linux]$ pwd
/srv/nfs_shares/web.tp6.linux
```
> Et ouais pour pas que ce soit le bordel, on va appeler le dossier comme la machine qui l'utilisera :)

🌞 **Installer le serveur NFS** (sur la machine `storage.tp6.linux`)

```bash
[gwuill@storage ~]$ sudo dnf install nfs-utils
[gwuill@storage ~]$ sudo chown nobody /srv/nfs_shares/web.tp6.linux/
[gwuill@storage ~]$ sudo cat /etc/exports
/srv/nfs_shares/web.tp6.linux/        10.105.1.11(rw,sync,no_root_squash,no_subtree_check)
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
[gwuill@storage ~]$ sudo firewall-cmd --reload
```

### 2. Client NFS

🌞 **Installer un client NFS sur `web.tp6.linux`**

```bash
[gwuill@web ~]$ sudo mount 10.105.1.14:/srv/nfs_shares/web.tp6.linux/ /srv/backup/
[gwuill@web ~]$ df -h | grep 10.105.1.14
10.105.1.14:/srv/nfs_shares/web.tp6.linux  6.2G  1.4G  4.9G  23% /srv/backup
[gwuill@web ~]$ sudo cat /etc/fstab | grep 10.105.1.14
10.105.1.14:/srv/nfs_shares/web.tp6.linux/ /srv/backup/ nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

🌞 **Tester la restauration des données** sinon ça sert à rien :)

- livrez-moi la suite de commande que vous utiliseriez pour restaurer les données dans une version antérieure

![Backup everything](../pics/backup_everything.jpg)
