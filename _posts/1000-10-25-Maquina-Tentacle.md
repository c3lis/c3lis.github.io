---
title : Máquina|TENTACLE|HTB|PROXYCHAINS|KERVEROS
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/Tentacle/Tentacle0.png" style="border-radius: 150px; width: 169px" alt="Ghoul logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Difícil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/Tentacle" style="color: lightblue;">Tentacle</a></p>
    </div>
</div>

<h2><font color="white"><center> # Tentacle</center></font></h2>

* Empezamos con una traza ICMP para ver a que maquina nos enfrentamos, gracias a su TTL (63) podemos intuir que nos enfrentamos a una maquina Linux.

<img src="imgs/Tentacle/Tentacle1.png">

* Empezamos con la enumeración de puertos de la maquina, en relevancia el puerto en donde corres KERVEROS puerto 88
y el puerto http 3128

<img src="imgs/Tentacle/Tentacle2.png">

* Empezamos observando la pagina web, donde nos da un nombre de usuario y posterior a eso nos da lo que al parecer es un subdominio.

<img src="imgs/Tentacle/Tentacle2.png">

* Agregamos el subdominio con esa ip en el /etc/hosts para tener conectividad.

<img src="imgs/Tentacle/Tentacle6.png">

* Como tiene el puerto 53 abierto podríamos tratar de hacer un ataque AXFR pero de momento no nos arroja nada relevante.

<img src="imgs/Tentacle/Tentacle4.png">

* Posterior a esto procedemos a enumerar mas la pagina. listado los servicios mx de la pagina web, no nos da nada relevante tampoco.

<img src="imgs/Tentacle/Tentacle5.png">

* Como sabemos que puede estar jugando con subdominios podemos hacer un ataque por fuerza bruta para enumerar posibles subdominios con la herramienta dnsenum, el que nos reporta 3 subdominios.

<img src="imgs/Tentacle/Tentacle7.png">


* Usamos expresiones regulares para establecer el formato para agregarlo al /etc/hosts

<img src="imgs/Tentacle/Tentacle8.png">

* Arreglamos el /etc/hosts

<img src="imgs/Tentacle/Tentacle9.png">


* OBJETIVO: nuestro objetivo aquí sera poder listar la pagina web: wpad.realcorp.htb de la ip : 10.197.243.31  que anteriormente pudimos observar gracias al escaneo por fuerza bruta, recordemos que directamente no tenemos comunicación directa a esta maquina por lo que vamos a tener que hacer uso de proxychains para navegar por los proxys de la pagina web y lograr tener comunicación con las demás maquinas.

<img src="imgs/Tentacle2/Tentacle222.png">


* Posterior a esto podemos intuir que la maquina pasa por un Squid Proxy para tener acceso a esas direcciones Ip internas.
aquí se lo dibujo para que entienda mejor.

<img src="imgs/Tentacle/Tentacle11.png">



* Para tener conectividad con estas maquina tenemos que usar proxychains esto nos ayudara a pasar por el Squid Proxy de la maquina victima; Para ello primeramente configuramos el /etc/proxychains.conf y colocamos el Squid Proxy de la maquina victima.

<img src="imgs/Tentacle/Tentacle13.png">

* Luego de hacer esto ya tendríamos conectividad con proxychains para la conectividad de la misma.

<img src="imgs/Tentacle2/Tentacle224.png">

* Empezamos entonces con nmap a escanear todo el rango de puertos de la ip 10.197.243.77 y se observa que emplea también Squid Proxye.

<img src="imgs/Tentacle/Tentacle15.png">


* Agregamos el Squid Proxye de esa maquina al /etc/proxychains.conf

<img src="imgs/Tentacle/Tentacle16.png">


* Ahora si tenemos comunicación con el puerto 80 que este Podría contener la pagina web que estamos buscando: wpad.realcorp.htb, asi que empezamos con la enumeración de puerto activos en la maquina 10.197.243.31

<img src="imgs/Tentacle/Tentacle18.png">

* A la hora de listar el contenido de la pagina me aparece que no tengo acceso con un código de estado, 403;

<img src="imgs/Tentacle/Tentacle19.png">

* Investigando mas acerca de la url vemos que usa "wpad" y buscamos algo importante relacionado con esto, vemos que hay rutas
que revela información que podría ser de ayuda.

<font color="red"><center><a href="https://book.hacktricks.xyz/generic-methodologies-and-resources/pentesting-network#spoofing-wpad">>Mas información aquí<</a></center></font>

<img src="imgs/Tentacle2/Tentacle223.png">

* Entonces procedemos a husmear que hay por ahi, vemos que nos da unas direcciones ip nuevas.

<img src="imgs/Tentacle/Tentacle21.png">

* Escaneamos el nuevo segmento de red el cual es : 10.241.251.0 es decir tendríamos que validar bajo este segmento de red están maquinas activas, para ello nos montamos un script en bash, que validara las maquinas activas y los puertos activos para este segmento de red dedicado. 10.241.251.0/254

```bash
#!/bin/bash

for port in 21 22 25 80 88 443 8080 ; do
    for i in $(seq 1 254);do
        proxychains -q timeout 3 bash -c "echo  ' ' > /dev/tcp/10.241.251.$i/$port" 2>/dev/null && echo "[+] Host : 10.241.251.$i:$port" &
    done; wait
done
```

* Procedemos a correr el script, y nos detecta puertos y maquinas, lo mas interesante del escaneo es que podemos ver que al parecer tiene el puerto smtp abierto.

<img src="imgs/Tentacle/Tentacle22.png">

* Enumeramos la version y servicio exacto que corre bajo este puerto, vemos que esta en la version 2.0.0

<img src="imgs/Tentacle/Tentacle23.png">

* Procedemos a buscar vulnerabilidades para esta version de smtp.

<img src="imgs/Tentacle/Tentacle24.png">

* Analizando el exploit no funcionara si lo ejecuta a la primera instancia por que necesita primera mente de un usuario existente.

<img src="imgs/Tentacle/Tentacle25.png">

* Recordando que al principio la pagina de la maquina real 10.10.10.204 nos daba un usuario que posiblemente exista.

<img src="imgs/Tentacle/Tentacle26.png">

* Retocamos el exploit y cambios le correo de usuario.

<img src="imgs/Tentacle/Tentacle27.png">

* Seguidamente procedemos a hacer un index.html que contendrá la reverse Shell que luego vamos a ejecutar.

<img src="imgs/Tentacle2/Tentacle20.png">

* Ejecutamos el archivo reverse guardado anteriormente y ganamos acceso a un contenedor.

<img src="imgs/Tentacle2/Tentacle21.png">

* Exportamos configuración para una full tty.

<img src="imgs/Tentacle2/Tentacle22.png">

* Retocamos variables de entorno.

<img src="imgs/Tentacle2/Tentacle23.png">

* Enumeramos usuarios y credenciales.

<img src="imgs/Tentacle2/Tentacle24.png">

* Probamos conectarnos por ssh a la maquina real 10.10.10.224

<img src="imgs/Tentacle2/Tentacle25.png">

* Aplicamos verbose para ver mas a fondo el problema.

<img src="imgs/Tentacle2/Tentacle26.png">

* Vemos que necesitamos al parecer de un archivo de configuración, procedemos entonces a instalar krb5-user
<center>
> sudo apt install krb5-user
</center>
<img src="imgs/Tentacle2/Tentacle27.png">

* Creamos la configuración de un archivo que posteriormente iria en /etc/krb5.conf
<center>
> dpkg-reconfigure krb5-user
</center>

* Creamos el archivo en /etc/krb5.conf tal que quede de la siguiente forma

<img src="imgs/Tentacle2/Tentacle28.png">

* Ejecutamos < kinit j.nakazawa > y colocamos la credencial del respectivo usuario que era la que habíamos encontrado anteriormente

<img src="imgs/Tentacle2/Tentacle29.png">

* Indicamos el archivo temporal que nos muestra en klist para introducirlo en ssh como SSH_AUTH_SOCK=, y nos conectamos a la maquina

<img src="imgs/Tentacle2/Tentacle210.png">

* Podemos ver la flag del usuario.

<img src="imgs/Tentacle2/Tentacle211.png">

* Ahora procedemos anumerar el directorio para escalar privilegios, y vemos que tenemos permisos frente a un carpeta que esta enlazada con la ejecución de un comando por admin.

<img src="imgs/Tentacle2/Tentacle212.png">

* Investigando mas KERVEROS usa un archivo de configuración llamado k5login el cual garantiza el acceso de un usuario, como nosotros tenemos el nuestro y lo que hace el script ejecutado por admin es mover todo a la carpeta admin cada minuto, pues colocamos nuestro principal el cual seria j.nakazawa@REALCORP.HTB y lo alojamos en un archivo llamado k5login,cuando se ejecute la tarea cron el archivo se colocara dentro del directorio /home/admin y nosotros podríamos conectarnos remotamente por ssh sin la proporción de credencial. Investigue mas acerca de la funcionalidad del archivo k5login y su función.

<img src="imgs/Tentacle2/Tentacle215.png">

<img src="imgs/Tentacle2/Tentacle213.png">


* Enumeramos el directorio activo de esta maquina, y vemos un krb5.keytab

<img src="imgs/Tentacle2/Tentacle217.png">

* Si investigamos mas acerca sobre la capacidad y la importancia de este archivo vemos que este archivo nos puede permitir la entrada al sistema ya que es legible para nosotros.

<font color="red"><center><a href="https://web.mit.edu/kerberos/krb5-1.5/krb5-1.5.4/doc/krb5-install/The-Keytab-File.html">>Mas información aquí<</a></center></font>
<img src="imgs/Tentacle2/Tentacle216.png">


* Enumeramos principales con la ayuda del archivo /etc/krb5.keytab

<img src="imgs/Tentacle2/Tentacle218.png">

* Nos conectamos con kadmin y le cambiamos la credencial a root. Seguidamente nos conectamos como root con la credencial modificada anteriormente con el comando ksu.

<img src="imgs/Tentacle2/Tentacle221.png">
<img src="imgs/Tentacle2/Tentacle220.png">