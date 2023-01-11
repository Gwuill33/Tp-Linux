# I. Setup

🖥️ **VM `proxy.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

➜ **On utilisera NGINX comme reverse proxy**

```bash
[gwuill@proxy-tp6 ~]$ sudo dnf install nginx
Complete!
```
```bash
[gwuill@proxy-tp6 ~]$ sudo systemctl start nginx
```
```bash
[gwuill@proxy-tp6 ~]$ ss -alnpt4 | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
```
```bash
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --reload
success
```
```bash
[gwuill@proxy-tp6 ~]$ ps -ef | grep nginx | head -2
root        1545       1  0 15:15 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1546    1545  0 15:15 ?        00:00:00 nginx: worker process
```
```html
$ curl 10.105.1.13:80 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   647k      0 --:--:-- --:--:-- --:--:--  744k<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
```

➜ **Configurer NGINX**

```bash
[gwuill@proxy-tp6 ~]$ sudo cat /etc/nginx/conf.d/proxy.conf
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```

```bash
[gwuill@web ~]$ sudo cat /var/www/tp5_nextcloud/config/config.php | grep trusted_domains -A 4
  'trusted_domains' =>
  array (
    0 => 'web.tp6.linux',
        1 => 'proxy.tp6.linux',
  ),
```


➜ **Modifier votre fichier `hosts` de VOTRE PC**

```bash
$ curl -s 10.105.1.11:80 | head -5
<!DOCTYPE html>
<html class="ng-csp" data-placeholder-focus="false" lang="en" data-locale="en" >
        <head
 data-requesttoken="vCmp8ZE/269CxIU6npBE47sigOnY3SdbvtuwHcJaSvw=:y3rTwKdei+o6gvZuq+ENioxp453uqUIRypXCK6csAZM=">
                <meta charset="utf-8">
```
```bash
$ curl -s 10.105.1.13:80 | head -5
<!DOCTYPE html>
<html class="ng-csp" data-placeholder-focus="false" lang="en" data-locale="en" >
        <head
 data-requesttoken="53voY3msDACN8t8xKvZTyUYFlPy6gNurmuxY0r/m3p0=:rh2gFk/qa0e9pO9BH9kdkw9j+6nWw4zPqtU1uveRnaQ=">
                <meta charset="utf-8">

```

➜ **Faites en sorte de**

```bash
[gwuill@web ~]$ sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.105.1.1" port port="22" protocol="tcp" accept'
[gwuill@web ~]$ sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.105.1.13" port port="80" protocol="tcp" accept'
[gwuill@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[gwuill@web ~]$ sudo firewall-cmd --remove-service=ssh --permanent
success
```

➜ **Une fois que c'est en place**

```
PS C:\Users\guill> ping proxy.tp6.linux

Envoi d’une requête 'ping' sur proxy.tp6.linux [10.105.1.13] avec 32 octets de données :
Réponse de 10.105.1.13 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.13 : octets=32 temps<1ms TTL=64
```
```
PS C:\Users\guill> ping web.tp6.linux

Envoi d’une requête 'ping' sur web.tp6.linux [10.105.1.11] avec 32 octets de données :
Délai d’attente de la demande dépassé.

Statistiques Ping pour 10.105.1.11:
    Paquets : envoyés = 1, reçus = 0, perdus = 1 (perte 100%),
```

# II. HTTPS

```bash
[gwuill@proxy-tp6 ~]$ sudo dnf install openssl -y
[gwuill@proxy-tp6 ~]$ openssl genrsa -out private.key 2048
[gwuill@proxy-tp6 ~]$ openssl req -new -x509 -key private.key -out certificat.crt
```
```bash
[gwuill@proxy-tp6 ~]$ sudo cat /etc/nginx/conf.d/proxy.conf | grep listen -A 3
[sudo] password for gwuill:
    listen 443 ssl;
        ssl_certificate /home/gwuill/certificat.crt;
        ssl_certificate_key /home/gwuill/private.key;
}
```
```bash
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --reload
success
```
