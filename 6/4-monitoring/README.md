# Module 4 : Monitoring

Dans ce sujet on va installer un outil plutôt clé en main pour mettre en place un monitoring simple de nos machines.

L'outil qu'on va utiliser est [Netdata](https://learn.netdata.cloud/docs/agent/packaging/installer/methods/kickstart).

![Netdata](../pics/netdata.png)

➜ **Je vous laisse suivre la doc pour le mettre en place** [ou ce genre de lien](https://wiki.crowncloud.net/?How_to_Install_Netdata_on_Rocky_Linux_9). Vous n'avez pas besoin d'utiliser le "Netdata Cloud" machin truc. Faites simplement une install locale.

Installez-le sur `web.tp6.linux` et `db.tp6.linux`.

Une fois en place, Netdata déploie une interface un Web pour avoir moult stats en temps réel, utilisez une commande `ss` pour repérer sur quel port il tourne.

Utilisez votre navigateur pour visiter l'interface web de Netdata `http://<IP_VM>:<PORT_NETDATA>`.

➜ **Configurer Netdata pour qu'il vous envoie des alertes** dans [un salon Discord](https://learn.netdata.cloud/docs/agent/health/notifications/discord) dédié en cas de soucis

➜ **Vérifier que les alertes fonctionnent** en surchargeant volontairement la machine par exemple (effectuez des *stress tests* de RAM et CPU, ou remplissez le disque volontairement par exemple)

![Monitoring](../pics/monit.jpg)