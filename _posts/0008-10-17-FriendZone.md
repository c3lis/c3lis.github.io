---
title : Máquina|Friend Zone|HTB|AXFR|Hijacking
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/FriendZone/FriendZone1.png" style="border-radius: 190px; width: 169px" alt="Jarvis">
    <div>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Facil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/173" style="color: lightblue;">Jarvis</a></p>
    </div>
</div>

<h2><font color="white"><center># Friend Zone</center></font></h2>
<br>

* <p>Empezamos tirando una traza ICMP para ver a que maquina nos enfrentamos, como el TTL es de 63, aproximado a 64 quiero pensar que es una maquina Linux.</p>
<img src="imgs/FriendZone/FriendZone2.png">

* <p>Vemos los nodos intermediarios de la maquina y vemos que pasa por varios nodos lo que hace que el TTL disminuya.</p>
<img src="imgs/FriendZone/FriendZone3.png">

* <p>Empezamos con la enumeración de puertos activos en el servidor, como puertos relevantes tenemos el SMB SSL, y vemos que nos da un subdominio.</p>
<img src="imgs/FriendZone/FriendZone4.png">

* <p>Procedemos a poner el subdominio en el /etc/hosts</p>
<img src="imgs/FriendZone/FriendZone5.png">
imgs</p>
<img src="imgs/FriendZone1/FriendZone13.png">

* <p>A la hora de verlos desde la web no hay nada relevante.</p>
<img src="imgs/FriendZone1/FriendZone14.png">

* <p>Procedemos a hacer un ataque AXFR (Trasferencia De Zona) para la posterior enumeración mas a detalla de subdominios existentes en la maquina. <p>
<a href="https://book.hacktricks.xyz/es/network-services-pentesting/pentesting-dns"> CVE-1999-0532</a>
<img src="imgs/FriendZone1/FriendZone15.png">

* <p>Con los subdominios otorgados procedemos a agregarlos en el /etc/hosts </p>
<img src="imgs/FriendZone1/FriendZone16.png">

* <p>Al ver el primer subdominio https://administrator1.friendzone.red/ vemos un panel de login.</p>
<img src="imgs/FriendZone1/FriendZone17.png">

* <p>Al ver la pagina https://uploads.friendzone.red vemos que podemos cargar archivos.</p>
<img src="imgs/FriendZone1/FriendZone18.png">

* <p>Por otro lado el ultimo subdominio https://hr.friendzone.red/ no nos muestra nada relevante. </p>
<img src="imgs/FriendZone1/FriendZone19.png">

* <p>Como tiene el puerto smb abierto procedemos a enumerar los recursos compartidos, y se puede observar que tiene archivo de escritura y lectura en ciertos directorios</p>
<img src="imgs/FriendZone1/FriendZone110.png">

* <p>Al estar enumerando el recurso compartido vemos credenciales.</p>
<img src="imgs/FriendZone1/FriendZone111.png">

* <p>Al insertarla en la web https://administrator1.friendzone.red/ vemos que es posible conectarnos.</p>

<img src="imgs/FriendZone1/FriendZone112.png">

* <p>Al iniciar sesión nos dice que visitemos una ruta del sistema llamada dashborad.php </p>
<img src="imgs/FriendZone1/FriendZone113.png">

* <p>Nos dice que podemos cargar imágenes y nos indica la ruta que tenemos que ejecutar</p>
<img src="imgs/FriendZone1/FriendZone114.png">

* <p>Al ver la imagen vemos que nos carga la imagen un archivo. </p>
<img src="imgs/FriendZone1/FriendZone115.png">

* <p>Procedemos a hacer test para observar que tipo de archivo ejecuta y como lo ejecuta, probando con el mismo dashboard.php, y se observa que llama a un archivo existente y automáticamente le agrega el .php</p>
<img src="imgs/FriendZone2/FriendZone20.png">

* <p>Ahora como podemos cargar archivos por SMB lo que queda seria subir un archivo php malicioso y apuntar a ese script en php, el problema reside es que no sabemos la ruta en la que se aloja el script, entonces procedemos a montarnos una herramienta que busque por las rutas del sistema nustro script.</p>

```bash
#!/bin/bash

function ctrl_c(){
	echo -e "\e[33;1m 	* Saliendo \n\n"
	rm -rf file.tmp file2.tmp
	exit 1
}

trap ctrl_c INT

if [ -f "you_wordlists.txt" ];then
	echo -e "\e[36;1mEl archivo $1\e[0m"
	echo -ne "\e[36;1mDesea sobrescribir este archivo?\e[0m" ; read NULL
	rm -rf $1
fi

if [[ ! -n $1 ]];then
	echo -e "\n\e[35;1m	* ?nombre de archivo a buscar\n\n"
	exit 1
fi


echo -e "\n\n\e[35;1m Generando rutas con la indicación del archivo : $1\n	* Espere..\e[0m"
tput civis

for i in $(seq 1 $(cat ./wordlists/rutas.txt | wc -l)); do

	sed 's/\(.*\)\/[^\/]*$/\1/' ./wordlists/rutas.txt >> file.tmp
	echo """$(cat file.tmp | awk "NR==$i")/$1""" >> file2.tmp

done

sort file2.tmp | uniq  >> "you_wordlists.txt"


rm -rf file.tmp file2.tmp
echo -e "	\e[35;1m * Archivo $1 generado correctamente\e[0m\n"
tput cnorm

```


* <p>Si quieres usar mi script es necesario que descargue el archivo rutas.txt y lo coloque dentro de una carpeta llamada wordlists descargue la herramienta comprimida : </p>

<center><a href="uploads/Herramiento.zip" downlaod="Herramient.zip">> Herramienta<</a></center>

* <p>Al iniciar el script me genera 296 posibles rutas me dirá que le ponga el nombre de archivo, en este caso sera el que queremos buscar.</p>


<img src="imgs/FriendZone2/FriendZone21.png">

* <p>Posteriormente subimos un recuso compartido por SMB, que va a contener un archivo php malicioso.</p>
<img src="imgs/FriendZone2/FriendZone22.png">

* <p>Ahora lo que sigue es dar con el archivo para ello ejecutamos el script en bash para generar rutas que puedan dar con el archivo.</p>
<img src="imgs/FriendZone2/FriendZone23.png">

* <p>Una vez generado el archivo 'you_wordlists.txt' tenemos que sacar la cookie del navegador web, para ello hacemos</p><p>F12 -> Red -> Session GET 200 -> Cookie </p>
<img src="imgs/FriendZone2/FriendZone24.png">

* <p>Luego nos ponemos en escucha en el puerto 4445 y ejecutamos wfuzz </p>
<img src="imgs/FriendZone2/FriendZone25.png">

* <p>Ejecución de wfuzz y acceso al sistema </p>
<video controls style="width: 100%; max-width: 700px; border-radius: 12px; margin: 0 auto; display: block;">
  <source src="imgs/FriendZone/Video.mp4" type="video/mp4">
  Tu navegador no soporta la reproducción de video.
</video>

* <p>Procedemos a hacerle el tratamiento a la Shell para tener una full tty interactiva.</p>
<img src="imgs/FriendZone2/FriendZone27.png">

* <p>Exportamos variables de entorno.</p>
<img src="imgs/FriendZone2/FriendZone28.png">

* <p>Procedemos a verificar todo el entorno de trabajo en búsqueda de usuarios y credenciales, nos damos cuenta que hay credenciales tiradas en archivos.</p>
<img src="imgs/FriendZone2/FriendZone29.png">

* <p>Enumeramos los usuario del sistema, nos damos cuenta que existe el usuario friend.</p>
<img src="imgs/FriendZone2/FriendZone210.png">

* <p>Probamos las credenciales encontradas y funcionan. </p>
<img src="imgs/FriendZone2/FriendZone211.png">

* <p>Después de enumerar todo el sistema en búsqueda de credenciales no encontramos nada, entonces procedemos a enumerar procesos que se ejecuta en el sistema creando un simple archivo en bash.</p>
<img src="imgs/FriendZone2/FriendZone212.png">

```bash
#!/bin/bash

function ctrl_c(){
	echo -e "\e[33;1m	* Saliendo\e[0m"
	exit 1
}

trap ctrl_c INT

old_process=$(ps -eo command)

while true;do

	new_process=$(ps -eo command)
	diff <(echo "$old_process") <(echo "$new_process") | grep "[\>\<]" | grep -vE "command|process"
	old_process=$new_process
	trap ctrl_c INT

done
```


* <p>Procedemos a darle permisos y ejecutar el script process.sh, vemos que ejecuta el archivo reporter.py y vemos que en donde esta la librería la cual es la que hace uso en el script reporter.py; tenemos permisos de escritura lectura y ejecución.</p>
<img src="imgs/FriendZone2/FriendZone213.png">

* <p>Modificamos la librería os.py para hacer que el os.py le otorgue permisos SUID al binario /bin/bash </p>
<img src="imgs/FriendZone2/FriendZone214.png">

* <p>Ahora queda esperar para que la tarea cron se vuelva a ejecutar y le de permisos SUID a la  /bin/bash. </p>
<img src="imgs/FriendZone2/FriendZone215.png">

* <p>Después de esta esperando ya tenemos permisos SUID en la /bin/bash.</p>
<img src="imgs/FriendZone2/FriendZone216.png">

* <p>Procedemos a ejecutar el binario.</p>
<img src="imgs/FriendZone2/FriendZone217.png">
