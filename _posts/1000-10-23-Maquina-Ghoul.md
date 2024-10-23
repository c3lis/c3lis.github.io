---
title : Máquina|Ghoul|HTB|ZIP SLIP|PIVOTING
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/Ghoul/Ghoul1.png" style="border-radius: 150px; width: 169px" alt="Ghoul logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Dificil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/Ghoul" style="color: lightblue;">Ghoul</a></p>
    </div>
</div>

 <h2><font color="white"><center> # Ghoul</center></font></h2>

* Empezamos sabiendo que nos enfrentamos a una maquina Linux por su ttl (64).

<img src="imgs/Ghoul/Ghoul3.png">

* Empezamos con la enumeración de los puertos activos.

<img src="imgs/Ghoul/Ghoul2.png">

* Enumeramos los puertos y servicios que corren bajo esos puertos. 

<img src="imgs/Ghoul/Ghoul5.png">

* Vemos los puertos http que tiene esta maquina puerto 80.

<img src="imgs/Ghoul/Ghoul7.png">

* Vemos ahora el puerto 8080, y es un simple panel de autenticación.

<img src="imgs/Ghoul/Ghoul8.png">

* Nos creamos un diccionario para hacer un ataque de fuera bruta para esta pagina con cewl.

<img src="imgs/Ghoul/Ghoul9.png">

* Abrimos el diccionario creado y agregamos posibles credenciales por defecto.

<img src="imgs/Ghoul/Ghoul10.png">


* Nos creamos un script en python para hacer ataque de fuerza bruta para este panel de login.

```python
#!/usr/bin/python
import requests
import signal
import sys
import threading
import time

def salida(sig, frame):
    print(" \n    *Saliendo\n")
    sys.exit(1)

signal.signal(signal.SIGINT, salida)


if __name__ == '__main__':

    try:
        url = sys.argv[1]
        username = sys.argv[2]
        password = sys.argv[3]
 
    except Exception as e:
        print("Use: ./webPanel-BF.py http://10.10.10.101 <username> <file password>")
        sys.exit(1)
    
    
    def bf(username, password):
        
        with open(password, 'r') as file:
            for i in file:
                s = requests.session()
                password = i.split()
                password = i.strip()
                r = s.get(url, auth=(username, password))
                print(r.status_code, f'{username, password}')
                if r.status_code == 200 :
                    print(f"\n\n-------\nPassword Succes Fully : {username, password}\n---------\n")
                    s.close()
                    sys.exit(0)
                s.close()
            
    bf(username, password)   
   
```

<font color="red"><center><a href="uploads/webPanel-BF.py">>Descargar<</a></center></font>

* Procedemos a ejecutar el script en python, y vemos la credencial admin, admin

<img src="imgs/Ghoul/Ghoul11.png">

* Se mira que podemos cargar archivos zip procedemos a hacer pruebas de vulnerabilidad en esta carga de archivos.

<img src="imgs/Ghoul/Ghoul13.png">

* Cargamos el archivo.

<img src="imgs/Ghoul/Ghoul14.png">

* Ahora queda ponernos en escucha por el puerto 4444 y lanzar una petición GET a esa ruta donde localizamos el archivo, para ganar acceso a la maquina.

<img src="imgs/Ghoul/Ghoul15.png">

* Procedemos a hacerle tratamiento a el caparazón para tener una full tty.

<img src="imgs/Ghoul/Ghoul16.png">

* Exportamos variables de entorno.

<img src="imgs/Ghoul/Ghoul17.png">

* Enumerando el sistema vemos que la carga de archivos la gestión root.

<img src="imgs/Ghoul/Ghoul17.png">

* Creamos entonces con openssl una credencial para root.

<img src="imgs/Ghoul/Ghoul19.png">

* Procedemos a ver el archivo /etc/passwd de la maquina (10.10.10.101).

<img src="imgs/Ghoul/Ghoul20.png">

* Modificamos el passwd de la maquina y le ponemos la credencial generada con openssl.

<img src="imgs/Ghoul/Ghoul21.png">


* Procedemos a cargar el archivo en la pagina web.

<img src="imgs/Ghoul/Ghoul22.png">

* Luego vemos que que se modifico el /etc/passwd correctamente.

<img src="imgs/Ghoul/Ghoul23.png">

* su root : Con las respectiva credencial creada.

<img src="imgs/Ghoul/Ghoul24.png">

* Vemos que estamos dentro de un contenedor por que la Ip no es la de maquina real.

<img src="imgs/Ghoul/Ghoul25.png">

* Procedemos a enumerar credenciales en el directorio, y vemos credenciales que guardaremos.

<img src="imgs/Ghoul/Ghoul26.png">

* Vemos credenciales en la raíz del sistema que guardaremos.

<img src="imgs/Ghoul/Ghoul27.png">

<img src="imgs/Ghoul/Ghoul28.png">

* Procedemos a enumerar maquinas activas bajo el segmento de red en el que estoy. (172.20.0.200)
```bash
#!/bin/bash 
 for i in $(seq 1 265);do
    timeout 1 bash -c "ping -c1 172.20.0.$i" &>/dev/null && echo "Maquina activa : 127.20.0.$i" &
done; wait
```
<br>
* Vemos la maquina 172.20.0.1 172.20.0.150 (172.20.0.200 Maquina actual) activa.

<img src="imgs/Ghoul/Ghoul37.png">

* Vemos que en el directorio /home/kaneki/.ssh tiene un 2 authorized_keys lo que me hace pensar que posiblemente la comparta
para con la maquina 127.20.0.150

<img src="imgs/Ghoul/Ghoul30.png">

* Listando la id_rsa se observa que esta encriptada procedemos a hacer un ataque de fuerza bruta para esta id_rsa.

<img src="imgs/Ghoul/Ghoul32.png">

* Usamos jhon pero no existe una credencial para este hash.

<img src="imgs/Ghoul/Ghoul33.png">

* Procedemo a enumerar la pagina web mas a detalle a ver que se puede encontrar. y vemos un secret.php

<img src="imgs/Ghoul/Ghoul34.png">

* Vemos que en la conversación se dice que necesita acceso remoto al servidor y le pasa la credencial ILoveTouka 

<img src="imgs/Ghoul/Ghoul35.png">

* Probando conectarnos con esa credencial por ssh vemos que la credencial es permitida.

<img src="imgs/Ghoul/Ghoul36.png">

* Ahora conectemonos como kaneki_pub@127

<img src="imgs/Ghoul/Ghoul39.png">

* Vemos que ya estamos en la ip 172.18.0.200

<img src="imgs/Ghoul/Ghoul38.png">

* Vemos una posible credencial.

<img src="imgs/Ghoul/Ghoul40.png">

* Vemos que tenemos acceso a otra interfaz de red al parecer.

<img src="imgs/Ghoul/Ghoul41.png">

* Procedemos a enumerar maquina activas bajo ese segmento de red.

<img src="imgs/Ghoul/Ghoul42.png">

* Vemos que hay maquina activas 172.18.0.1 172.18.0.2 (172.18.0.200 Maquina actual).

<img src="imgs/Ghoul/Ghoul43.png">


* Procedemos a enumerar puertos activos en la maquina 172.18.0.2 y vemos que tiene activado el puerto 3000

```bash
#Enumerar puertos

#!/bin/bash
for i in $(seq 1 65536);do
    timeout 1 bash -c "echo ' ' >/dev/tcp/172.18.0.2/$i" &>/dev/null && echo "Puerto activos: $i" &
done; wait

```

<img src="imgs/Ghoul/Ghoul44.png">

* Hacemos Port Fordwarding para tener acceso a ese puerto desde nuestra maquina.
Copiamos la id_rsa de root 

<img src="imgs/Ghoul/Ghoul45.png">

* Posteriormente lo que hacemos es hacer abrir el puerto 2000 para comunicarse por el puerto 22 de la maquina 172.20.0.150

<img src="imgs/Ghoul/Ghoul46.png">

* Ahora desde nuestra maquina entablamos la conexión para tener acceso.

<img src="imgs/Ghoul/Ghoul48.png">

* Posterior mente complementamos el Port Forwarding para traer ese puerto y compartirlo por el puerto 3000 de nuestra maquina.

<img src="imgs/Ghoul/Ghoul49.png">

* Vemos que comparte un panel de autenticación.

<img src="imgs/Ghoul/Ghoul50.png">


* Recordamos que ya habíamos descubierto el usuario AogiriTest en la maquina kaneki_pub 

<img src="imgs/Ghoul/Ghoul51.png">


* Hacemos uso de las credenciales anteriormente encontradas en la primera maquina 172.20.0.200

<img src="imgs/Ghoul/Ghoul52.png">

* Iniciamos session.

<img src="imgs/Ghoul/Ghoul53.png">

* Vemos que nos dice la version de este panel.

<img src="imgs/Ghoul/Ghoul54.png">

* Miramos vulnerabilidades para esta version, y vemos un exploit dedica paro esta version que nos permite tener un RCE.

<center><font color="red"><a href="https://github.com/TheZ3ro/gogsownz">>github exploit<</a></font></center>
<img src="imgs/Ghoul/Ghoul55.png">

* Vemos los datos que nos piden.

<img src="imgs/Ghoul/Ghoul56.png">

* Y nos piden el nombre de la cookie usuario y credencial, nos ponemos en escucha y vemos que nos ejecuto la revese Shell.

<img src="imgs/Ghoul/Ghoul57.png">

* Vemos que tiene ssh y copiamos la clave publica de kaneki para conectarnos a esta maquina.

<img src="imgs/Ghoul/Ghoul59.png">

* Me conecto por ssh a git desde kanki_pub que esta bajo el segmento de red de git.

<img src="imgs/Ghoul/Ghoul60.png">

* Procedemos a enumerar binario con permiso SUID y vemos un binario llamado ./usr/sbin/gosu

<img src="imgs/Ghoul/Ghoul61.png">

* Viendo mas a detalle lo que hace ejecuta como root algún comando.

<img src="imgs/Ghoul/Ghoul62.png">

* Procedemos a spwnear una Shell como root.

<img src="imgs/Ghoul/Ghoul63.png">

* En el directorio root vemos un comprimido que posteriormente no los trasferimos a nuestra maquina para examinarlo.

<img src="imgs/Ghoul/Ghoul64.png">

* Vemos credenciales de kaneki.

<img src="imgs/Ghoul/Ghoul65.png">

* Posteriormente vemos que la credencial funciona para convertirnos en root en la maquina kaneki_pub

<img src="imgs/Ghoul/Ghoul66.png">

* Vemos comando que se estén ejecutando a nivel de sistema.

<img src="imgs/Ghoul/Ghoul67.png">

* Vemos que se ejecuta un comando que se conecta como root a la 10.10.10.101 por el puerto 2222 

<img src="imgs/Ghoul/Ghoul68.png">


* Vemos que nos crea una carpeta en /tmp llamada ssh-nuZgOXdjYp y nos deposita un agente de usuario.

<img src="imgs/Ghoul/Ghoul70.png">


* Rápidamente hacemos uso del agente de usuario para conectarnos por ssh a la maquina.

<img src="imgs/Ghoul/Ghoul71.png">

* Posterior a esto ya estaríamos en la maquina original y podríamos observar la flag.

<img src="imgs/Ghoul/Ghoul72.png">

