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

```bash
$ curl 192.168.56.4:8648
<h1>MEOW mon premier serveur web</h1>
```
# III. Your own services

🌞 **Afficher le fichier de service SSH**
```bash
[gwuill@localhost ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 **Afficher le fichier de service NGINX**

```bash
[gwuill@localhost ~]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**
```bash
[gwuill@localhost ~]$ cd /etc/systemd/system
[gwuill@localhost system]$ sudo touch tp2_nc.service
[gwuill@localhost system]$ sudo nano tp2_nc.service
[gwuill@localhost system]$ cat tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 806
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**
```bash
[gwuill@localhost ~]$ sudo systemctl daemon-reload
```

🌞 **Démarrer notre service de ouf**
```bash
[gwuill@localhost ~]$ sudo systemctl start tp2_nc
```

🌞 **Vérifier que ça fonctionne**

```bash
[gwuill@localhost ~]$ sudo systemctl status tp2_nc
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Sun 2022-11-27 22:30:20 CET; 8s ago
```
```bash
[gwuill@localhost ~]$ ss -alnpt | grep 806
LISTEN 0      10           0.0.0.0:806       0.0.0.0:*
LISTEN 0      10              [::]:806          [::]:*
[gwuill@localhost ~]$ sudo firewall-cmd --add-port=806/tcp --permanent
success
[gwuill@localhost ~]$ sudo firewall-cmd --reload
success
```
- vérifer que juste ça marche en vous connectant au service depuis votre PC

➜ Si vous vous connectez avec le client, que vous envoyez éventuellement des messages, et que vous quittez `nc` avec un CTRL+C, alors vous pourrez constater que le service s'est stoppé

- bah oui, c'est le comportement de `nc` ça ! 
- le client se connecte, et quand il se tire, ça ferme `nc` côté serveur aussi
- faut le relancer si vous voulez retester !

🌞 **Les logs de votre service**
```bash
[gwuill@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep Started | head -1
Nov 27 22:30:20 localhost.localdomain systemd[1]: Started Super netcat tout fou.
```
  - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
```bash
[gwuill@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep Stopped | head -1
Nov 27 23:14:23 localhost.localdomain systemd[1]: Stopped Super netcat tout fou.
```

🌞 **Affiner la définition du service**

```
[gwuill@localhost ~]$ sudo cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 806
Restart=always
```