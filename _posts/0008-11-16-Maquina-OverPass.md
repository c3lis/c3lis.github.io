---
title : MQ|Over Pass|THM|CRONTAB|IDOR
published : True
---


<div class="contenedor imgc">
    <img class="imgc" src="imgs/overPass/overPass1.png" style="width: 169px" alt="Over Pass log">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Fácil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/room/picklerick" style="color: lightblue;">Over Pass</a></p>
    </div>
</div>

<h2><font color="white"><center># Over Pass</center></font></h2>
 
 * Empezamos con la enumeración de la pagina web, como el ttl es de 64 podemos intuir que estamos frente a una maquina Linux.

 <img src="imgs/overPass/overPass2.png">

* Vemos que tiene el puerto 22 80 activo.

<img src="imgs/overPass/overPass3.png">

* Empezamos con la enumeración de directorios activos en la pagina web.

<img src="imgs/overPass/overPass4.png">


* Vemos el panel de admin y probamos credenciales por defecto, admin:admin admin:password administrator:admin, admin:administrator, pero no tenemos éxito.

<img src="imgs/overPass/overPass5.png">

* Procedemos a ver la red por la que se esta tramitando la información para ello desde el teclado pulsamos [ f12 ] y click en [ red ], vemos que la información a la hora de colocar las credenciales correctas se le asigna una cookie y un estado de cookie luego redirecciona  a el lugar /admin.

<img src="imgs/overPass/overPass6.png">

<center> java </center>

```java
async function login() {
    const usernameBox = document.querySelector("#username");
    const passwordBox = document.querySelector("#password");
    const loginStatus = document.querySelector("#loginStatus");
    loginStatus.textContent = ""
    const creds = { username: usernameBox.value, password: passwordBox.value }
    const response = await postData("/api/login", creds)
    const statusOrCookie = await response.text()
    if (statusOrCookie === "Incorrect credentials") {
        loginStatus.textContent = "Incorrect Credentials"
        passwordBox.value=""
    } else {
        Cookies.set("SessionToken",statusOrCookie) // Asignacion de una cookie y un estado.
        window.location = "/admin"
    }
}
```

* Procedemos a inyectar nuestra cookie para ver que pasa.
<center>| curl http://$target_ip/admin -H "Cookie: SessionToken=1" -s -L | html2text </center>

<img src="imgs/overPass/overPass7.png">

* Vemos que nos da un clave privado pero encriptada, procedemos a desencriptarla, con herramientas como ssh2john que permiten
el ataque por fuerza bruta a este tipo de claves rsa, copiamos la clave rsa y lo guardamos en un archivo ssh_key para posteriormente generar un hash con la herramienta ssh2john.

<img src="imgs/overPass/overPass8.png">

* Guardamos el hash generado en un archivo llamado : hash

<img src="imgs/overPass/overPass9.png">

* Desencriptamos el archivo hash

<center>| john -wordlist=/usr/share/wordlists/rockyou.txt hash</center>

<img src="imgs/overPass/overPass11.png">

* Una vez encontrada la credencial procedemos a darle permiso 600 al archivo ssh_key y conectarnos por ssh como el usuario james con la credencial obtenida anteriormente.

<img src="imgs/overPass/overPass12.png">

* Obtenga la flag del usuario. Después de un rato de estar enumerando los directorio vemos en /etc/crontab algo interesante una tarea ejecutándose como usuario root, descarga una archivo overpass.thm y lo ejecuta.

<img src="imgs/overPass/overPass13.png">

* Vemos que tenemos permisos frente al archivo /etc/hosts esto la hace vulnerables ya que podemos modificar los dns y hacer que cuando apunte a la dirección overpass.thm nos redirija a nuestra ip de atacante donde alojaremos un archivo malicioso que hara darle permisos SUID al binario /bin/bash de tal forma poder convertirnos en root.

<img src="imgs/overPass/overPass14.png">

* Envenenamiento DNS. Hacemos que overpass.thm apunte a nuestra dirección ip modificando el /etc/hosts.

<img src="imgs/overPass/overPass15.png">

* Ahora creamos la carpetas necesarias es importante porque recordemos que la tarea cron esta haciendo un curl a los directorios /downloads/src/ asi que vamos a tener que crear los nuestros, creamos el archivo buildscript.sh

<img src="imgs/overPass/overPass17.png">

* Procedemos a montarnos un servidor con python3 por el puerto 80, se realiza la petición y ganamos acceso como root.

<img src="imgs/overPass/overPass18.png">







