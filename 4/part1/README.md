# Partie 1 : Partitionnement du serveur de stockage

🌞 **Partitionner le disque à l'aide de LVM**

```bash
[gwuill@storage-tp4 ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```
```bash
[gwuill@storage-tp4 ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
```
```bash
[gwuill@storage-tp4 ~]$ sudo lvcreate -l 100%FREE storage -n storage
  Logical volume "storage" created.
```

🌞 **Formater la partition**
```bash
[gwuill@storage-tp4 ~]$ sudo mkfs -t ext4 /dev/storage/storage
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: f87a171b-757d-45da-9edc-800fc4a53053
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 **Monter la partition**

```bash
[gwuill@storage-tp4 ~]$ df -h | grep storage
/dev/mapper/storage-storage  2.0G   24K  1.9G   1% /mnt/storage
```
```bash
[gwuill@storage-tp4 ~]$ sudo chown gwuill /mnt/storage/
```
```bash
[gwuill@storage-tp4 storage]$ nano test
[gwuill@storage-tp4 storage]$ cat test
test
```
```bash
[gwuill@storage-tp4 ~]$ cat /etc/fstab | grep storage
/dev/storage/storage /mnt/storage       ext4     defaults        0 0```
```bash
[gwuill@storage-tp4 ~]$ sudo mount -av
/mnt/storage             : successfully mounted
```
