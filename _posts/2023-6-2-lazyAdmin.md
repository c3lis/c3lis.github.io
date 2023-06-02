---
title : Lazy Admin
published : True
---
<p></p>
---
<p>Name : LazyAdmin</p>
<p>Url : <a href="https://tryhackme.com/room/lazyadmin"> LazyAdmin</a></p>
<p></p>
---
* <p>Empezamos con el reconocimiento de la maquina</p>
<img src="/imgs/lazyAdmin/lazyAdmin0.jpg"/>
<br>
<br>
`Vemos que es una maquina linux por el ttl que es de 63, por proximidad hacia 64 podemos decir que la maquina es linux.`
* <p>Empezamos con el reconocimiento de puertos.</p>
<img src="/imgs/lazyAdmin/lazyAdmin1.jpg"/>
<br>
<br>
`Podemos observar que tiene el puerto ssh y http abierto.`
* <p>Ahora enumeraremos los directorios activos de la pagina web</p>
<img src="/imgs/lazyAdmin/lazyAdmin2.jpg"/>
<br>
<br>
`Vemos que hay un direcotorio llamado content.`
* <p>Miremos que trae ese directorio.</p>
<img src="/imgs/lazyAdmin/lazyAdmin3.jpg"/>
<br><br>
`Vemos que en su sistema usa SweetRice el cual miraremos si tiene vulnerabilidades.`
* <p>Miremos si tiene vulnerabilidades el sistema que tiene en uso.</p>
<img src="/imgs/lazyAdmin/lazyAdmin4.jpg"/>
* <p>Mirando bien tenemos un exploit llamado Backup Disclosure que recopila informacion</p>

