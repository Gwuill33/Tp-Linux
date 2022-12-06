# Partie 3 : Serveur web

## 2. Install

🖥️ **VM web.tp4.linux**

🌞 **Installez NGINX**
```bash
[gwuill@web-server-tp4 ~]$ sudo dnf install nginx
Complete!
```

## 3. Analyse


🌞 **Analysez le service NGINX**

```bash
[gwuill@web-server-tp4 ~]$ ps -ef | grep nginx
root        1476       1  0 14:05 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1477    1476  0 14:05 ?        00:00:00 nginx: worker process
gwuill      1488    1255  0 14:07 pts/0    00:00:00 grep --color=auto nginx
```
```bash
[gwuill@web-server-tp4 ~]$ ss -alnpt | grep 80 | head -1
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
```
```bash
[gwuill@web-server-tp4 ~]$ sudo cat /etc/nginx/nginx.conf | grep '^ *server {' -A 12 | grep include
        include /etc/nginx/default.d/*.conf;
```
```bash
[gwuill@web-server-tp4 ~]$ ls -al /etc/nginx/default.d/
total 4
drwxr-xr-x. 2 root root    6 Oct 31 16:37 .
drwxr-xr-x. 4 root root 4096 Dec  6 14:01 ..
```

## 4. Visite du service web

**Et ça serait bien d'accéder au service non ?** Genre c'est un serveur web. On veut voir un site web !

🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

```bash
[gwuill@web-server-tp4 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[gwuill@web-server-tp4 ~]$ sudo firewall-cmd --reload
success
```

🌞 **Accéder au site web**

```bash
$ curl http://192.168.56.7 | head -3
<!doctype html>
<html>
  <head>
```

🌞 **Vérifier les logs d'accès**

```bash
[gwuill@web-server-tp4 ~]$ sudo cat /var/log/nginx/access.log | tail -3
192.168.56.1 - - [06/Dec/2022:14:24:13 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.84.0" "-"
192.168.56.1 - - [06/Dec/2022:14:24:47 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.84.0" "-"
192.168.56.1 - - [06/Dec/2022:14:24:54 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.84.0" "-"
```

## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/nginx.conf | grep listen | head -1
        listen       8080;
```
```bash
[gwuill@web-server-tp4 ~]$ ss -alnpt | grep 8080 | head -1
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*
```
```bash
[gwuill@web-server-tp4 ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[gwuill@web-server-tp4 ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[gwuill@web-server-tp4 ~]$ sudo firewall-cmd --reload
success
```
```bash
$ curl http://192.168.56.7:8080 | head -3
<!doctype html>
<html>
  <head>
```

---

🌞 **Changer l'utilisateur qui lance le service**

```bash
[gwuill@web-server-tp4 ~]$ sudo useradd -p ggg -d /home/web web
```
```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/nginx.conf | grep user | head -1
user web;
```
```bash
[gwuill@web-server-tp4 ~]$ ps -ef | grep nginx | grep web
web         1645    1644  0 14:40 ?        00:00:00 nginx: worker process
```

---

**Il est temps d'utiliser ce qu'on a fait à la partie 2 !**

🌞 **Changer l'emplacement de la racine Web**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/nginx.conf | grep root | head -1
        root         /var/www/site_web_1/;
```
```
$ curl 192.168.56.7:8080
<h1>Petitchat.png</h1>
```

## 6. Deux sites web sur un seul serveur

🌞 **Repérez dans le fichier de conf**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/nginx.conf | grep conf.d | tail -1
    include /etc/nginx/conf.d/*.conf;
```
🌞 **Créez le fichier de configuration pour le premier site**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/conf.d/site_web_1.conf
 server {
        listen       8080;
        listen       [::]:80;
        server_name  _;
        root         /var/www/site_web_1/;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

🌞 **Créez le fichier de configuration pour le deuxième site**

```bash
[gwuill@web-server-tp4 ~]$ cat /etc/nginx/conf.d/site_web_2.conf
 server {
        listen       8888;
        listen       [::]:80;
        server_name  _;
        root         /var/www/site_web_2/;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

🌞 **Prouvez que les deux sites sont disponibles**

```
$ curl 192.168.56.7:8080
<h1>Petitchat.png</h1>

$ curl 192.168.56.7:8888
<h1>Petitchien.png</h1>

```