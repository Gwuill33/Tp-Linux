# I. Service SSH
## 1. Analyse du service

🌞 **S'assurer que le service `sshd` est démarré**
```bash
[gwuill@localhost ~]$ systemctl status sshd
     Active: active (running) since Tue 2022-11-22 15:21:27 CET; 3m 4s ago
```
🌞 **Analyser les processus liés au service SSH**

```bash
[gwuill@localhost ~]$ ps -ef | grep sshd
root         696       1  0 15:21 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         869     696  0 15:22 ?        00:00:00 sshd: gwuill [priv]
gwuill       875     869  0 15:22 ?        00:00:00 sshd: gwuill@pts/0
gwuill       903     876  0 15:25 pts/0    00:00:00 grep --color=auto sshd
```

🌞 **Déterminer le port sur lequel écoute le service SSH**
```bash
[gwuill@localhost ~]$ ss -a | grep ssh
tcp   ESTAB  0      52                                   192.168.56.4:ssh                192.168.56.1:55115
```
🌞 **Consulter les logs du service SSH**

```bash
[gwuill@localhost ~]$ journalctl -g ssh
Nov 22 15:21:25 localhost systemd[1]: Created slice Slice /system/sshd-keygen.
Nov 22 15:21:26 localhost systemd[1]: OpenSSH ecdsa Server Key Generation was skipped because all trigger condition che>
Nov 22 15:21:26 localhost systemd[1]: OpenSSH ed25519 Server Key Generation was skipped because all trigger condition c>
Nov 22 15:21:26 localhost systemd[1]: OpenSSH rsa Server Key Generation was skipped because all trigger condition check>
Nov 22 15:21:26 localhost systemd[1]: Reached target sshd-keygen.target.
Nov 22 15:21:27 localhost systemd[1]: Starting OpenSSH server daemon...
Nov 22 15:21:27 localhost systemd[1]: Started OpenSSH server daemon.
Nov 22 15:22:08 localhost.localdomain sshd[869]: Accepted password for gwuill from 192.168.56.1 port 55115 ssh2
Nov 22 15:22:08 localhost.localdomain sshd[869]: pam_unix(sshd:session): session opened for user gwuill(uid=1000) by (u>
```

```bash
[gwuill@localhost ~]$ sudo tail /var/log/secure
Nov 22 15:41:17 localhost sudo[989]: pam_unix(sudo:session): session closed for user root
Nov 22 15:41:19 localhost sudo[992]:  gwuill : TTY=pts/0 ; PWD=/home/gwuill ; USER=root ; COMMAND=/bin/tail /var/log/sssd/
Nov 22 15:41:19 localhost sudo[992]: pam_unix(sudo:session): session opened for user root(uid=0) by gwuill(uid=1000)
Nov 22 15:41:19 localhost sudo[992]: pam_unix(sudo:session): session closed for user root
Nov 22 15:41:25 localhost sudo[995]:  gwuill : TTY=pts/0 ; PWD=/home/gwuill ; USER=root ; COMMAND=/bin/tail /var/log/wtmp
Nov 22 15:41:25 localhost sudo[995]: pam_unix(sudo:session): session opened for user root(uid=0) by gwuill(uid=1000)
Nov 22 15:41:25 localhost sudo[995]: pam_unix(sudo:session): session closed for user root
Nov 22 15:41:34 localhost sudo[998]:  gwuill : TTY=pts/0 ; PWD=/home/gwuill ; USER=root ; COMMAND=/bin/tail /var/log/dnf.log
Nov 22 15:41:34 localhost sudo[998]: pam_unix(sudo:session): session opened for user root(uid=0) by gwuill(uid=1000)
Nov 22 15:41:34 localhost sudo[998]: pam_unix(sudo:session): session closed for user root
[gwuill@localhost ~]$ tail /var/log/secure
```
## 2. Modification du service

Dans cette section, on va aller visiter et modifier le fichier de configuration du serveur SSH.

Comme tout fichier de configuration, celui de SSH se trouve dans le dossier `/etc/`.

Plus précisément, il existe un sous-dossier `/etc/ssh/` qui contient toute la configuration relative au protocole SSH

🌞 **Identifier le fichier de configuration du serveur SSH**

C'est ssh_config car il permet de modifier les paramètres de SSHt

🌞 **Modifier le fichier de conf**

```bash
[gwuill@localhost ~]$ echo $RANDOM
16546
```
```bash
[gwuill@localhost ~]$ sudo cat /etc/ssh/sshd_config | grep 16546
Port 16546
```
```bash
[gwuill@localhost ~]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success
[gwuill@localhost ~]$ sudo firewall-cmd --add-port=16546/tcp --permanent
success
[gwuill@localhost ~]$ sudo firewall-cmd --reload
success
[gwuill@localhost ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 16546/tcp
```
🌞 **Redémarrer le service**

```bash
[gwuill@localhost ~]$ sudo systemctl restart sshd
```
🌞 **Effectuer une connexion SSH sur le nouveau port**

```bash
PS C:\Users\guill> ssh gwuill@192.168.56.4 -p 16546
gwuill@192.168.56.4's password:
```

# II. Service HTTP

Dans cette partie, on ne va pas se limiter à un service déjà présent sur la machine : on va ajouter un service à la machine.

On va faire dans le *clasico* et installer un serveur HTTP très réputé : NGINX.  
Un serveur HTTP permet d'héberger des sites web.

Un serveur HTTP (ou "serveur Web") c'est :

- un programme qui écoute sur un port (ouais ça change pas ça)
- il permet d'héberger des sites web
  - un site web c'est un tas de pages html, js, css
  - un site web c'est aussi parfois du code php, python ou autres, qui indiquent comment le site doit se comporter
- il permet à des clients de visiter les sites web hébergés
  - pour ça, il faut un client HTTP (par exemple, un navigateur web)
  - le client peut alors se connecter au port du serveur (connu à l'avance)
  - une fois le tunnel de communication établi, le client effectuera des requêtes HTTP
  - le serveur répondra à l'aide du protocole HTTP

> Une requête HTTP c'est "donne moi tel fichier HTML". Une réponse c'est "voici tel fichier HTML" + le fichier HTML en question.

Ok bon on y va ?

## 1. Mise en place

![nngijgingingingijijnx ?](./pics/njgjgijigngignx.jpg)

🌞 **Installer le serveur NGINX**
 ```bash
 [gwuill@localhost ~]$ sudo dnf install nginx
 ```

🌞 **Démarrer le service NGINX**

```bash
[gwuill@localhost ~]$ sudo systemctl status nginx
     Active: active (running) since Tue 2022-11-22 16:15:15 CET; 4s ago
```
🌞 **Déterminer sur quel port tourne NGINX**

```bash
[gwuill@localhost ~]$ ss -alnpt | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
LISTEN 0      511             [::]:80           [::]:*
```
```bash
[gwuill@localhost ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[gwuill@localhost ~]$ sudo firewall-cmd --reload
success
[gwuill@localhost ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 22/tcp 80/tcp
```

🌞 **Déterminer les processus liés à l'exécution de NGINX**

```bash
[gwuill@localhost ~]$ ps -ef | grep nginx
root        4092       1  0 16:18 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4093    4092  0 16:18 ?        00:00:00 nginx: worker process
gwuill      4136    1202  0 16:38 pts/0    00:00:00 grep --color=auto nginx
```

🌞 **Euh wait**
```bash
guill@Gwuill MINGW64 ~
$ curl 192.168.56.4:80 | head -7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  5361k      0 --:--:-- --:--:-- --:--:-- 7441k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

```bash
[gwuill@localhost ~]$ ls -al /etc/nginx/
[gwuill@localhost ~]$ ls -al /etc/nginx/
total 84
drwxr-xr-x.  4 root root 4096 Nov 22 16:14 .
drwxr-xr-x. 78 root root 8192 Nov 22 16:14 ..
drwxr-xr-x.  2 root root    6 May 16  2022 conf.d
drwxr-xr-x.  2 root root    6 May 16  2022 default.d
-rw-r--r--.  1 root root 1077 May 16  2022 fastcgi.conf
-rw-r--r--.  1 root root 1077 May 16  2022 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 May 16  2022 fastcgi_params
-rw-r--r--.  1 root root 1007 May 16  2022 fastcgi_params.default
-rw-r--r--.  1 root root 2837 May 16  2022 koi-utf
-rw-r--r--.  1 root root 2223 May 16  2022 koi-win
-rw-r--r--.  1 root root 5231 May 16  2022 mime.types
-rw-r--r--.  1 root root 5231 May 16  2022 mime.types.default
-rw-r--r--.  1 root root 2334 May 16  2022 nginx.conf
-rw-r--r--.  1 root root 2656 May 16  2022 nginx.conf.default
-rw-r--r--.  1 root root  636 May 16  2022 scgi_params
-rw-r--r--.  1 root root  636 May 16  2022 scgi_params.default
-rw-r--r--.  1 root root  664 May 16  2022 uwsgi_params
-rw-r--r--.  1 root root  664 May 16  2022 uwsgi_params.default
-rw-r--r--.  1 root root 3610 May 16  2022 win-utf
```

🌞 **Trouver dans le fichier de conf**
```bash
[gwuill@localhost ~]$ sudo cat /etc/nginx/nginx.conf | grep '^ *server {' -A 12
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }
    }
```
```bash
[gwuill@localhost tp2_linux]$ sudo cat /etc/nginx/nginx.conf | grep -i '^ *include'
    include /etc/nginx/conf.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**
```bash
[gwuill@localhost var]$ sudo mkdir www
[gwuill@localhost var]$ cd www/
[gwuill@localhost www]$ sudo mkdir tp2_linux
[gwuill@localhost www]$ cd tp2_linux/
[gwuill@localhost tp2_linux]$ sudo touch index.html
[gwuill@localhost tp2_linux]$ sudo nano index.html
[gwuill@localhost tp2_linux]$ sudo cat index.html
<h1>MEOW mon premier serveur web</h1>
```
🌞 **Adapter la conf NGINX**
```bash
[gwuill@localhost ~]$ sudo cat /etc/nginx/conf.d/tp2_linux.conf
server {
  listen 8648;

  root /var/www/tp2_linux;
}
```

🌞 **Visitez votre super site web**

- toujours avec une commande `curl` depuis votre PC (ou un navigateur)

# III. Your own services

Dans cette partie, on va créer notre propre service :)

HE ! Vous vous souvenez de `netcat` ou `nc` ? Le ptit machin de notre premier cours de réseau ? C'EST L'HEURE DE LE RESORTIR DES PLACARDS.

## 1. Au cas où vous auriez oublié

Au cas où vous auriez oublié, une petite partie qui ne doit pas figurer dans le compte-rendu, pour vous remettre `nc` en main.

> Allez-le télécharger sur votre PC si vous ne l'avez pu. Lien dans Google ou dans le premier TP réseau.

➜ Dans la VM

- `nc -l 8888`
  - lance netcat en mode listen
  - il écoute sur le port 8888
  - sans rien préciser de plus, c'est le port 8888 TCP qui est utilisé

➜ Sur votre PC

- `nc <IP_VM> 8888`
- vérifiez que vous pouvez envoyer des messages dans les deux sens

> Oubliez pas d'ouvrir le port 8888/tcp de la VM bien sûr :)

## 2. Analyse des services existants

Un service c'est quoi concrètement ? C'est juste un processus, que le système lance, et dont il s'occupe après.

Il est défini dans un simple fichier texte, qui contient une info primordiale : la commande exécutée quand on "start" le service.

Il est possible de définir beaucoup d'autres paramètres optionnels afin que notre service s'exécute dans de bonnes conditions.

🌞 **Afficher le fichier de service SSH**

- vous pouvez obtenir son chemin avec un `systemctl status <SERVICE>`
- mettez en évidence la ligne qui commence par `ExecStart=`
  - encore un `cat <FICHIER> | grep <TEXTE>`
  - c'est la ligne qui définit la commande lancée lorsqu'on "start" le service
    - taper `systemctl start <SERVICE>` ou exécuter cette commande à la main, c'est (presque) pareil

🌞 **Afficher le fichier de service NGINX**

- mettez en évidence la ligne qui commence par `ExecStart=`

## 3. Création de service

![Create service](./pics/create_service.png)

Bon ! On va créer un petit service qui lance un `nc`. Et vous allez tout de suite voir pourquoi c'est pratique d'en faire un service et pas juste le lancer à la min.

Ca reste un truc pour s'exercer, c'pas non plus le truc le plus utile de l'année que de mettre un `nc` dans un service n_n

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

- son contenu doit être le suivant (nice & easy)

```service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 8888
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

- la commande c'est `sudo systemctl daemon-reload`

🌞 **Démarrer notre service de ouf**

- avec une commande `systemctl start`

🌞 **Vérifier que ça fonctionne**

- vérifier que le service tourne avec un `systemctl status <SERVICE>`
- vérifier que `nc` écoute bien derrière un port avec un `ss`
  - vous filtrerez avec un `| grep` la sortie de la commande pour n'afficher que les lignes intéressantes
- vérifer que juste ça marche en vous connectant au service depuis votre PC

➜ Si vous vous connectez avec le client, que vous envoyez éventuellement des messages, et que vous quittez `nc` avec un CTRL+C, alors vous pourrez constater que le service s'est stoppé

- bah oui, c'est le comportement de `nc` ça ! 
- le client se connecte, et quand il se tire, ça ferme `nc` côté serveur aussi
- faut le relancer si vous voulez retester !

🌞 **Les logs de votre service**

- mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
- `sudo journalctl -xe -u tp2_nc` pour visualiser les logs de votre service
- `sudo journalctl -xe -u tp2_nc -f ` pour visualiser **en temps réel** les logs de votre service
  - `-f` comme follow (on "suit" l'arrivée des logs en temps réel)
- dans le compte-rendu je veux
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
  - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service

🌞 **Affiner la définition du service**

- faire en sorte que le service redémarre automatiquement s'il se termine
  - comme ça, quand un client se co, puis se tire, le service se relancera tout seul
  - ajoutez `Restart=always` dans la section `[Service]` de votre service
  - n'oubliez pas d'indiquer au système que vous avez modifié les fichiers de service :)
