---
title : Máquina|<font color="#5d9b9b">Anonymous</font>
published : True
---
<p></p>

<p>Nombre: Anonymous</p>
<p>Url : <a href="https://tryhackme.com/room/anonymous">Anonymous</a></p>
<br>
<h2><font color="white"><center># Anonymous</center></font></h2>
* <p>Empezamos con el reconocimiento de la maquina.</p>
> ping -c 1 10.10.51.98
<img src="/imgs/anonymous/anonymous0.jpg"/>
<br><br>
`Vemos que su ttl es de 63 aproximando a 64 podemos intuir que estamos frente a una maquina font Linux`
* <p>Por que el ttl no es de 64 entonces?, eso es porque no tenemos conexión directa con la maquina, es decir
hay nodos intermediarias por la cual pasa nuestra petición para poder tener comunicación con la maquina es decir</p>
> ping -R -c 1 10.10.51.98
<img src="/imgs/anonymous/anonymous1.jpg"/>
<br><br>
`Vemos que la ip de la maquina la cual es 10.10.51.98 pasa primeramente por la ip : 10.18.27.215, 10.0.0.94`
* <p>Enumeramos puertos de la maquina</p>
> nmap --min-rate 5000 -sV -sS -Pn --open 10.10.51.98
<img src="/imgs/anonymous/anonymous2.jpg"/>
<br><br>
`Vemos que esta maquina no tiene el puerto http ( 80 ) con el que estábamos acostumbrados encontrarnos en diferentes maquinas.`
* <p>No obstante tiene el puerto smb abierto, vamos enumerar archivos compartidos con sbmclient</p>
> smbclient -NL 10.10.51.98
<img src="/imgs/anonymous/anonymous3.jpg"/>
<br><br>
`Parámetros smbclient :`
<br>
`-N No pass -->> Hace referencia a que no tenemos ninguna información sobre algún usuario`
<br>
`-L Print share files -->> Hace referencia a que nos muestre archivos compartidos`
<br><br>
`En el comando anterior vemos un archivo compartido llamado pics`
* <p>Miremos que hay dentro de esa carpeta compartida</p>
> smbclient -N //10.01.51.98/pics
<img src="/imgs/anonymous/anonymous4.jpg"/>
<br><br>
`En el comando anterior enumeramos los archivos existentes de la carpeta pics, y vemos 2 imágenes.`
* <p>Asi que con el comando <font color="yellow">get</font> podemos trasferir las imágenes.</p>
> get corgo2.jpg
<br>
> get puppos.jpeg
<br>
<img src="/imgs/anonymous/anonymous5.jpg"/>
* <p>Ahora miremos las imagenes.</p>
> corpo2.jpg
<img src="/imgs/anonymous/anonymous6.jpg"/>
> puppos.jpeg
<img src="/imgs/anonymous/anonymous7.jpg"/>
<br>
* <p>No vemos nada interesante en las imágenes, recordemos que tenia el puerto ftp abierto, asi que nos conectaremos con la credencial "anonymous" a ver si tiene esta vuln el el server.</p>
> ftp 10.10.151.98
<img src="/imgs/anonymous/anonymous8.jpg"/>
`Al parecer si le es valido, y miramos que hay una carpeta llamada scripts que al entrar en ella vemos archivos`
<br>
* <p>vamos a trasferirnos los archivos a nuestra maquina con el comando [ get (file) ] y miramos que hacen esos archivos.</p>
> get file
<img src="/imgs/anonymous/anonymous9.jpg"/>
<br><br>
`Vemos que hay un archivo llamado clean.sh el cual al ver un archivo nuevo lo elimina de lo contrario dice "Nothing to delete", al ver el archivo removed_files.log vemos una cantidad de lineas, con lo que podemos intuir que hay una tarea cron que ejecuta el archivo`
* <p>Nos damos cuenta que tenemos permiso de escritura frente al archivo clean.sh, asi que porque no remplazamos, todo el código por una reverse Shell?</p>
> put [ File ] # para subir un archivo local a la maquina.
<img src="/imgs/anonymous/anonymous11.jpg"/>
<br>
<br>
`Como podemos ver cree un archivo llamado clean.sh que tiene una reverse Shell y la subí a la maquina con el comando put clean.sh`
* <p>Como es una tarea cron debemos entender que nos tocara esperar un rato para poder que el script se ejecute.</p>
> Despues de estar esperando un rato.
<img src="/imgs/anonymous/anonymous12.jpg"/>
<p>Ahora escalamos privilegios, vemos que comandos con permisos SUID podemos ejecutar</p>
> find /usr perm +6000 | grep '\/usr'
<img src="/imgs/anonymous/anonymous14.jpg"/>
<br><br>
`Mirando el resultado anterior vemos un archivo /usr/bin/env que nos puede ayudar para escalar privilegios entonces`

* <p> Escalamos privilegios con el binario /usr/bin/env </p>
> /usr/bin/env /bin/sh -p
<img src="/imgs/anonymous/anonymous15.jpg"/>
<p>OK maquina vulnerada</p>





