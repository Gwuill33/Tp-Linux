**Partie I**
```bash
[gwuill@tp3-linux ~]$ bash /srv/idcard/idcard.sh
Machine name : tp3-linux
OS Rocky Linux release 9.0 (Blue Onyx) and kernel version is Linux 5.14.0-70.26.1.el9_0.x86_64
IP : 10.0.2.15/24
RAM : 653M memory available on 960M total memory
Disk : 5.1G space left
Top 5 processs by RAM usage :
 - /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
 - /usr/sbin/NetworkManager --no-daemon
 - /usr/lib/systemd/systemd --switched-root --system --deserialize 28
 - /usr/lib/systemd/systemd --user
 - /usr/lib/systemd/systemd-logind
Listening ports :
 - 323 udp : chronyd
 - 22 tcp : sshd
Here is your random cat : cat_pic.jpeg
```

**Partie II**
```bash
[gwuill@tp3-linux ~]$ bash /srv/yt/yt.sh https://www.youtube.com/watch?v=jjs27jXL0Zs
Video https://www.youtube.com/watch?v=jjs27jXL0Zs was downloaded.
File path /srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE.mp4
```

**Partie III**
```bash
[gwuill@tp3-linux ~]$ sudo systemctl status yt
● yt.service - Potit chat downloader
     Loaded: loaded (/etc/systemd/system/yt.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2022-12-13 16:24:03 CET; 8min ago
   Main PID: 29590 (yt-v2.sh)
      Tasks: 2 (limit: 5908)
     Memory: 976.0K
        CPU: 32.949s
     CGroup: /system.slice/yt.service
             ├─29590 /bin/bash /srv/yt/yt-v2.sh
             └─30299 sleep 1

Dec 13 16:32:41 tp3-linux yt-v2.sh[30251]: [youtube] -Lmb6nh9wXM: Downloading webpage
Dec 13 16:32:43 tp3-linux yt-v2.sh[30251]: [download] Destination: /srv/yt/downloads/1 second of peak cat meow/1 second of peak cat meow.mp4
Dec 13 16:32:47 tp3-linux yt-v2.sh[30251]: [607B blob data]
Dec 13 16:32:51 tp3-linux yt-v2.sh[29590]: Video https://www.youtube.com/watch?v=-Lmb6nh9wXM was downloaded.
Dec 13 16:32:51 tp3-linux yt-v2.sh[29590]: File path /srv/yt/downloads/1 second of peak cat meow/1 second of peak cat meow.mp4
Dec 13 16:32:52 tp3-linux yt-v2.sh[29590]: URL required
```