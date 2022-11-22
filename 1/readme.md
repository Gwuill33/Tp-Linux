Première solution 

```
[gwuill@localhost ~]$ sudo rm -r /boot/vmlinuz-0-rescue-af0a4bbbf4814e05a8b1266bd5f79041
[gwuill@localhost ~]$ sudo rm -r /etc/passwd
[gwuill@localhost ~]$ sudo rm -r /etc/shadow
```

Ici la vm se lance correctement mais lorsqu'on va entrer nos register, la session ne va pas s'ouvrir et va redemander les identifiants et ça jusqu'a l'infini

Deuxième solution :
```
[gwuill@localhost ~]$ sudo rm -r /home
[gwuill@localhost ~]$ sudo rm -r /usr
[gwuill@localhost ~]$ exit

```
La machine se lance plus 

Troisième solution :
```
[gwuill@localhost ~]$ sudo rm -r /root
[gwuill@localhost ~]$ sudo rm -r /lib
[gwuill@localhost ~]$ sudo rm -r /lib64
[gwuill@localhost ~]$ exit
```
Peux plus se rendre sur sa machine 

Quatrième solution : 
```
[gwuill@localhost ~]$ :(){ :|: & };:
```
