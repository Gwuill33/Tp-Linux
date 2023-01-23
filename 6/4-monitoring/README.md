# Module 4 : Monitoring

🌞 **Installer Netdata**

```bash
[gwuill@web ~]$ sudo dnf install netdata
```

```
guill@Gwuill MINGW64 ~
$ curl http://10.105.1.11:19999 -s | head -1
<!doctype html><html lang="en"><head><title>netdata dashboard</title><meta name="application-name" content="netdata"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"><meta name="author" content="costa@tsaousis.gr"><link rel="icon" href="data:image/x-icon;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAP9JREFUeNpiYBgFo+A/w34gpiZ8DzWzAYgNiHGAA5UdgA73g+2gcyhgg/0DGQoweB6IBQYyFCCOGOBQwBMd/xnW09ERDtgcoEBHB+zHFQrz6egIBUasocDAcJ9OxWAhE4YQI8MDILmATg7wZ8QRDfQKhQf4Cie6pAVGPA4AhQKo0BCgZRAw4ZSBpIWJNI6CD4wEKikBaFqgVSgcYMIrzcjwgcahcIGRiPYCLUPBkNhWUwP9akVcoQBpatG4MsLviAIqWj6f3Absfdq2igg7IIEKDVQKEzN5ofAenJCp1I8gJRTug5tfkGIdR1FDniMI+QZUjF8Amn5htOdHCAAEGACE6B0cS6mrEwAAAABJRU5ErkJggg=="/><meta property="og:locale" content="en_US"/><meta property="og:url" content="https://my-netdata.io"/><meta property="og:type" content="website"/><meta property="og:site_name" content="netdata"/><meta property="og:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta property="og:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta property="og:image" content="https://cloud.githubusercontent.com/assets/2662304/22945737/e98cd0c6-f2fd-11e6-96f1-5501934b0955.png"/><meta property="og:image:type" content="image/png"/><meta property="fb:app_id" content="1200089276712916"/><meta name="twitter:card" content="summary"/><meta name="twitter:site" content="@linuxnetdata"/><meta name="twitter:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta name="twitter:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta name="twitter:image" content="https://cloud.githubusercontent.com/assets/2662304/14092712/93b039ea-f551-11e5-822c-beadbf2b2a2e.gif"/><style>.loadOverlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:2000;font-size:10vh;font-family:sans-serif;padding:40vh 0 40vh 0;font-weight:700;text-align:center}</style><link href="./static/css/2.c454aab8.chunk.css" rel="stylesheet"><link href="./static/css/main.53ba10f1.chunk.css" rel="stylesheet"></head><body data-spy="scroll" data-target="#sidebar" data-offset="100"><div id="loadOverlay" class="loadOverlay" style="background-color:#fff;color:#888"><div style="font-size:3vh">You must enable JavaScript in order to use Netdata!<br/>You can do this in <a href="https://enable-javascript.com/" target="_blank">your browser settings</a>.</div></div><script type="text/javascript">// Cleanup JS warning.
```
```
guill@Gwuill MINGW64 ~
$ curl http://10.105.1.12:19999 -s | head -1
<!doctype html><html lang="en"><head><title>netdata dashboard</title><meta name="application-name" content="netdata"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"><meta name="author" content="costa@tsaousis.gr"><link rel="icon" href="data:image/x-icon;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAP9JREFUeNpiYBgFo+A/w34gpiZ8DzWzAYgNiHGAA5UdgA73g+2gcyhgg/0DGQoweB6IBQYyFCCOGOBQwBMd/xnW09ERDtgcoEBHB+zHFQrz6egIBUasocDAcJ9OxWAhE4YQI8MDILmATg7wZ8QRDfQKhQf4Cie6pAVGPA4AhQKo0BCgZRAw4ZSBpIWJNI6CD4wEKikBaFqgVSgcYMIrzcjwgcahcIGRiPYCLUPBkNhWUwP9akVcoQBpatG4MsLviAIqWj6f3Absfdq2igg7IIEKDVQKEzN5ofAenJCp1I8gJRTug5tfkGIdR1FDniMI+QZUjF8Amn5htOdHCAAEGACE6B0cS6mrEwAAAABJRU5ErkJggg=="/><meta property="og:locale" content="en_US"/><meta property="og:url" content="https://my-netdata.io"/><meta property="og:type" content="website"/><meta property="og:site_name" content="netdata"/><meta property="og:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta property="og:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta property="og:image" content="https://cloud.githubusercontent.com/assets/2662304/22945737/e98cd0c6-f2fd-11e6-96f1-5501934b0955.png"/><meta property="og:image:type" content="image/png"/><meta property="fb:app_id" content="1200089276712916"/><meta name="twitter:card" content="summary"/><meta name="twitter:site" content="@linuxnetdata"/><meta name="twitter:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta name="twitter:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta name="twitter:image" content="https://cloud.githubusercontent.com/assets/2662304/14092712/93b039ea-f551-11e5-822c-beadbf2b2a2e.gif"/><style>.loadOverlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:2000;font-size:10vh;font-family:sans-serif;padding:40vh 0 40vh 0;font-weight:700;text-align:center}</style><link href="./static/css/2.c454aab8.chunk.css" rel="stylesheet"><link href="./static/css/main.53ba10f1.chunk.css" rel="stylesheet"></head><body data-spy="scroll" data-target="#sidebar" data-offset="100"><div id="loadOverlay" class="loadOverlay" style="background-color:#fff;color:#888"><div style="font-size:3vh">You must enable JavaScript in order to use Netdata!<br/>You can do this in <a href="https://enable-javascript.com/" target="_blank">your browser settings</a>.</div></div><script type="text/javascript">// Cleanup JS warning.
```

🌞 **Une fois Netdata installé et fonctionnel, déterminer :**

```bash
[gwuill@web ~]$ ps -aux | grep netdata
netdata      976  1.2 11.0 517120 86332 ?        SNsl 16:53   0:15 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
netdata      982  0.0  0.7  28724  5612 ?        SNl  16:53   0:00 /usr/sbin/netdata --special-spawn-server
netdata     1234  0.0  0.4   4504  3476 ?        SN   16:53   0:00 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
netdata     1244  0.7  1.2 134548  9728 ?        SNl  16:53   0:09 /usr/libexec/netdata/plugins.d/apps.plugin 1
root        1246  0.0  4.9 750664 39040 ?        SNl  16:53   0:01 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
netdata     1248  0.2  5.6 773668 44520 ?        SNl  16:53   0:03 /usr/libexec/netdata/plugins.d/go.d.plugin 1
gwuill      4917  0.0  0.2   6408  2204 pts/0    S+   17:13   0:00 grep --color=auto netdata
```
```bash
[gwuill@web ~]$ ss -alnpt | grep 19999
LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*
LISTEN 0      4096            [::]:19999         [::]:*
```
```bash
[gwuill@web ~]$ sudo cat /var/log/netdata/
```

🌞 **Configurer Netdata pour qu'il vous envoie des alertes** 

```bash
[gwuill@web ~]$ cat /etc/netdata/health_alarm_notify.conf 
# discord (discordapp.com) global notification options
# multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."
# enable/disable sending discord notifications
SEND_DISCORD="YES"
# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1062675743739494440/D0FoevOa9Vb-wQDLbHVBExrE4zn5pF_MvOiERNLgCTFrbgCTFrb8-g6RG1sVZ5dv6i4a-A3rlM"
```

🌞 **Vérifier que les alertes fonctionnent**

```bash
[gwuill@web ~]$ stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 10s
```
```bash
[gwuill@web ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-23 16:53:05 CET; 35min ago
    Process: 743 ExecStartPre=/bin/mkdir -p /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 756 ExecStartPre=/bin/chown -R netdata /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 878 ExecStartPre=/bin/mkdir -p /run/netdata (code=exited, status=0/SUCCESS)
    Process: 942 ExecStartPre=/bin/chown -R netdata /run/netdata (code=exited, status=0/SUCCESS)
   Main PID: 976 (netdata)
      Tasks: 78 (limit: 4640)
     Memory: 202.2M
        CPU: 49.787s
     CGroup: /system.slice/netdata.service
             ├─ 976 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
             ├─ 982 /usr/sbin/netdata --special-spawn-server
             ├─1234 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
             ├─1244 /usr/libexec/netdata/plugins.d/apps.plugin 1
             ├─1246 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
             └─1248 /usr/libexec/netdata/plugins.d/go.d.plugin 1

```
![Monitoring](../pics/monit.jpg)
