# Partie 2 : Serveur de partage de fichiers

🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**

```bash
[gwuill@storage-tp4 ~]$ cat /etc/exports
/storage/site_web_1/        192.168.56.7(rw,sync,no_root_squash,no_subtree_check)
/storage/site_web_2/        192.168.56.7(rw,sync,no_root_squash,no_subtree_check)
```

🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/fstab
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=56f9fea4-5b77-4197-b1d7-46aa2ebb5449 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
192.168.56.6:/storage/site_web_1               /var/www/site_web_1      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.56.6:/storage/site_web_2               /var/www/site_web_2      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

