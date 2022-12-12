# Partie 1 : Mise en place et maîtrise du serveur Web

## 1. Installation

🌞 **Installer le serveur Apache**

```bash
[gwuill@web ~]$ sudo dnf install httpd
Complete!
```
🌞 **Démarrer le service Apache**

```bash
[gwuill@web ~]$ sudo systemctl start httpd
```
```bash
[gwuill@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```
```bash
[gwuill@web ~]$ ss -alnpt | grep 80
LISTEN 0      511                *:80              *:*
```
```bash
[gwuill@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[gwuill@web ~]$ sudo firewall-cmd --reload
success
```

🌞 **TEST**

```bash
[gwuill@web ~]$ sudo systemctl status httpd | grep active
     Active: active (running) since Mon 2022-12-12 15:58:46 CET; 8min ago
```
```bash
[gwuill@web ~]$ sudo systemctl status httpd | grep enabled
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
```
```bash
[gwuill@web ~]$ curl localhost | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
```
```bash
$ curl 10.105.1.11:80 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  4754k      0 --:--:-- --:--:-- --:--:-- 7441k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
```

## 2. Avancer vers la maîtrise du service

🌞 **Le service Apache...**

```bash
[gwuill@web ~]$ cat /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#       [Service]
#       Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

🌞 **Déterminer sous quel utilisateur tourne le processus Apache**

```bash
[gwuill@web ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep User | head -1
User apache
```
```bash
[gwuill@web ~]$ ps -ef | grep apache | head -4
apache      1563    1562  0 15:58 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1564    1562  0 15:58 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1565    1562  0 15:58 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1566    1562  0 15:58 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```
```bash
[gwuill@web ~]$ ls -al /usr/share/testpage/index.html
-rw-r--r--. 1 root root 7620 Jul 27 20:05 /usr/share/testpage/index.html
```

🌞 **Changer l'utilisateur utilisé par Apache**

```bash
[gwuill@web ~]$ sudo useradd toto -d /usr/share/httpd -s /sbin/nologin
useradd: warning: the home directory /usr/share/httpd already exists.
useradd: Not copying any file from skel directory into it.
```
```bash
[gwuill@web ~]$ cat /etc/httpd/conf/httpd.conf | grep User | head -1
User toto
```
```bash
[gwuill@web ~]$ sudo systemctl restart httpd
```
```bash
[gwuill@web ~]$ ps -ef | grep toto | head -4
toto        1999    1998  0 16:32 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
toto        2000    1998  0 16:32 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
toto        2001    1998  0 16:32 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
toto        2002    1998  0 16:32 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```
🌞 **Faites en sorte que Apache tourne sur un autre port**

```bash
[gwuill@web ~]$ cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 2048
```
```bash
[gwuill@web ~]$ sudo firewall-cmd --remove-port=80/tcp
success
[gwuill@web ~]$ sudo firewall-cmd --add-port=2048/tcp --permanent
success
[gwuill@web ~]$ sudo firewall-cmd --reload
success
```
```bash
[gwuill@web ~]$ sudo systemctl restart httpd
```
```bash
[gwuill@web ~]$ ss -alnpt | grep 2048
LISTEN 0      511                *:2048            *:*
```
```bash
[gwuill@web ~]$ curl localhost:2048 | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
100  7620  100  7620    0     0   620k      0 --:--:-- --:--:-- --:--:--  676k
```

```bash
$ curl 10.105.1.11:2048 | head -5
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
```

📁 **Fichier `/etc/httpd/conf/httpd.conf`**

➜ **Si c'est tout bon vous pouvez passer à [la partie 2.](../part2/README.md)**