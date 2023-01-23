# Module 3 : Fail2Ban

Fail2Ban c'est un peu le cas d'école de l'admin Linux, je vous laisse Google pour le mettre en place.

![Fail2Ban](./../pics/fail2ban.png)

C'est must-have sur n'importe quel serveur à peu de choses près. En plus d'enrayer les attaques par bruteforce, il limite aussi l'imact sur les performances de ces attaques, en bloquant complètement le trafic venant des IP considérées comme malveillantes

🌞 Faites en sorte que :

```bash
[gwuill@proxy-tp6 ~]$ sudo nano /etc/fail2ban/jail.local
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
bantime  = 10m
findtime  = 1m
maxretry = 3

```
```bash
[gwuill@proxy-tp6 ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- File list:        /var/log/secure
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:
        `- 10.105.1.11/24
```
```bash
[gwuill@proxy-tp6 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 443/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
        rule family="ipv4" source address="10.105.1.11/24" reject
```
```bash
[gwuill@proxy-tp6 ~]$ sudo fail2ban-client set sshd unbanip 10.105.1.11
```