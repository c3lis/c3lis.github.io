---
title: ScanPorts
published: true
---


<p>Hola hoy vamos a crear un scaner de puertos en <b>bash scripting</b>
para salir un poco de nmap y dependencias iguales por un momento, asi de paso tambies no solo depender de estas
herramientas.</p>

<p>Vale primero que es un scaner de puertos, un scaner de puertos es quel que te permiter conecer los puertos activos
de una maquina para asi poderla vulnerar, pero hay que saber que esta no es la unica forma de poderla vulnerar, exiten
diversas formas de hacerlo una de ella es en la misma pagina web donde la pagina web es la que contiene
vulnerabilidades a explotar, recuerden que el puerto por donde
efectuan las paginas sulen ser el puerto <b>80 http</b>.</p>
<p><font color="yellow">[*]</font> Tipos de scaneo:</p>
* Tcp
* Udp
<p>El mas comun el cual usamos diariamente es el tcp, y en este caso usaremos el protocolo tcp.</p>
[mas informacion aqui](https://www.google.com/search?client=firefox-b-d&q=scaneo+tcp+y+udp)

-------
<br>
<center><font color="yellow">[<font color="red">*</font>]</font><font color="green"> ScanPorts </font></center>
<br>
<p><font color="yellow"></font> Creamos un script en bash con una funcion, que nos ayudara a que la estetica del script
mejore, lo que hace la funcion es para cuando oprimamos ctrl + c, el script no muestre tantos errores asi de esta manera controlar el flujo de los errores.</p>


<p><font color="yellow">[*]</font> El codigo de la funcion  <b>Para el control de las salidas</b>: </p>
```bash
#!/bin/bash

function ctrl_c(){
	echo -e "\e[31mSaliendo\n\e[31m"
	exit 1
}
trap ctrl_c INT
```
<br>

<p>La parte donde hace  <b>\e[31m</b>  significa que quiere empezar una secuencia de color en este caso el rojo muy importante cada
vez que utilizamos esto debe ir cerrado <b>\e[0m</b> ya que de lo contrario el codigo dara errores</p>
[Pudes encontrar mas informacion aqui](https://medium.com/linux-tips-101/bash-script-con-salida-en-colores-82bab9263998)
<p><font color="yellow">[*] </font>Empezaremos ahora a desrrollar el script : </p>

```bash
for x in $(seq 1 65536); do

                timeout 1 bash -c "echo '' > /dev/tcp/$1/$x"  && echo -e "Port Open: $x";
done

```
<br>
<p><font color="yellow">[*]</font> Como puden ver hice un <b>for</b>, en donde x almacenaba una variable de una secuencia de :
<b> 1 a 65536 </b> que si recuerdan es la cantiadad de puertos en total  que hay demtro de un servidor.
con el comando timeout controlo el tiempo de espera de un comando, en este caso para el comando :  </p>
```bash
echo '' > /dev/tcp/$1/$x
```
<br>

<p><font color="yellow">[*]</font> Donde: </p>
--> $1   Es   El segundo digito al ejecutar el script es decir:
```bash
./scanPorts.sh 8.8.8.8
```
<br>
--> $x  Es   la variable donde alamaceno el comando:
```bash
  seq 1 65535
```
<br>

<p><font color="yellow">[*]</font> Y los && significa si el comando anterior fue correcto entonces ejecutame esto, en este caso:</p>
```bash
echo -e "Port Open :$x"
```
<p><font color="yellow">[*]</font> La <b>-e</b> siginifica que le quieres indicar a echo que quieres incluir caracteres especiales
aqui el caracter especial es <b>$x (seq 1 65536).</b></p>

<p><font color="yellow">[*]</font> Resultado del script : </p>

```bash
#!/bin/bash

function ctrl_c(){

        echo -e "\e[31mSaliendo\n\e[0m"
        exit 1

}

trap ctrl_c INT

for x in $(seq 1 65536); do

                timeout 1 bash -c "echo '' > /dev/tcp/$1/$x"  && echo -e "Port Open: $x";
done

```

