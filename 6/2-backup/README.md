# Module 2 : Sauvegarde du système de fichiers

## I. Script de backup


### 3. Service et timer

➜ **Créez un *service*** système qui lance le script

- inspirez-vous des *services* qu'on a créés et/ou manipulés jusqu'à maintenant
- la seule différence est que vous devez rajouter `Type=oneshot` dans la section `[Service]` pour indiquer au système que ce service ne tournera pas à l'infini (comme le fait un serveur web par exemple) mais se terminera au bout d'un moment
- vous appelerez le service `backup.service`
- assurez-vous qu'il fonctionne en utilisant des commandes `systemctl`

```bash
$ sudo systemctl status backup
$ sudo systemctl start backup
```

➜ **Créez un *timer*** système qui lance le *service* à intervalles réguliers

- le fichier doit être créé dans le même dossier
- le fichier doit porter le même nom
- l'extension doit être `.timer` au lieu de `.service`
- ainsi votre fichier s'appellera `backup.timer`
- la syntaxe est la suivante :s

## II. NFS

### 1. Serveur NFS

> On a déjà fait ça au TP4 ensemble :)

🖥️ **VM `storage.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

➜ **Préparer un dossier à partager** sur le réseaucsur la machine `storage.tp6.linux`

- créer un dossier `/srv/nfs_shares`
- créer un sous-dossier `/srv/nfs_shares/web.tp6.linux/`

> Et ouais pour pas que ce soit le bordel, on va appeler le dossier comme la machine qui l'utilisera :)

➜ **Installer le serveur NFS**

```bash
[gwuill@storage ~]$ sudo cat /etc/exports
/srv/backup/        10.105.1.11(rw,sync,no_root_squash,no_subtree_check)
```
```bash
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
[gwuill@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
[gwuill@storage ~]$ sudo firewall-cmd --reload
```
```bash
[gwuill@storage ~]$ sudo systemctl start nfs-utils
```
- je vous laisse check l'internet pour trouver [ce genre de lien](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-rocky-linux-9) pour + de détails

### 2. Client NFS

➜ **Installer un client NFS sur `web.tp6.linux`**

- il devra monter le dossier `/srv/nfs_shares/web.tp6.linux/` qui se trouve sur `storage.tp6.linux`
- le dossier devra être monté sur `/srv/backup/`
- je vous laisse là encore faire vos recherches pour réaliser ça !
- faites en sorte que le dossier soit automatiquement monté quand la machine s'allume

➜ **Tester la restauration des données** sinon ça sert à rien :)

- livrez-moi la suite de commande que vous utiliseriez pour restaurer les données dans une version antérieure

![Backup everything](../pics/backup_everything.jpg)
