---
title: ScanPorts
published: true
---
<p>Hola, hoy vamos a crear un escáner de puertos en
<b>bash scripting</b>
para salir un poco de nmap y dependencias similares por un momento. Así de paso, también no solo dependeremos de estas herramientas.</p> <p>Vale, primero, ¿qué es un escáner de puertos? Un escáner de puertos es aquel que te permite conocer los puertos activos de una máquina para así poder vulnerarla. Pero hay que saber que esta no es la única forma de poder vulnerar, existen diversas formas de hacerlo; una de ellas es en la misma página web donde la página contiene vulnerabilidades a explotar. Recuerden que el puerto por donde se efectúan las páginas suele ser el puerto 
<b>80 (HTTP)</b>.</p>
<p><font color="yellow">[*]</font> Tipos de escaneo:</p>
* TCP
* UDP
<p>El más común, el cual usamos diariamente, es el TCP, y en este caso usaremos el protocolo TCP.</p> 
[Más información aquí](https://www.google.com/search?client=firefox-b-d&q=scaneo+tcp+y+udp) <br> 


<center><font color="yellow">[<font color="red">*</font>]</font><font color="green"> ScanPorts </font></center> <br> 
<font color="yellow"></font> Creamos un script en Bash con una función, que nos ayudará a mejorar la estética del script. Lo que hace la función es que cuando oprimamos Ctrl + C, el script no muestre tantos errores, así de esta manera controlamos el flujo de los errores

<p><center><font color="yellow">[<font color="red">*</font>]</font><font color="green"> ScanPorts </font></center></p>
<p><font color="yellow">[*]</font> El código de la función  <b>Para el control de las salidas</b>: </p>
```bash
#!/bin/bash

function ctrl_c(){
	echo -e "\e[31mSaliendo\n\e[31m"
	exit 1
}
trap ctrl_c INT
```
<br>
<p>La parte donde hace <b>\e[31m</b> significa que quiere empezar una secuencia de color, en este caso, el rojo. Es muy importante que cada vez que utilicemos esto, debe ir cerrado con <b>\e[0m</b>, ya que de lo contrario el código dará errores.</p>
[Puede encontrar mas información aquí](https://medium.com/linux-tips-101/bash-script-con-salida-en-colores-82bab9263998)

<p><font color="yellow">[*] </font>Empezaremos ahora a desarrollar el script : </p>

```bash
for x in $(seq 1 65536); do

                timeout 1 bash -c "echo '' > /dev/tcp/$1/$x"  && echo -e "Port Open: $x";
done

```
<br>
<p><font color="yellow">[*]</font> Como pueden ver, hice un <b>for</b>, donde <b>x</b> almacena una variable de una secuencia de <b>1 a 65536</b>, que, si recuerdan, es la cantidad total de puertos que hay dentro de un servidor. Con el comando <b>timeout</b> controlo el tiempo de espera de un comando, en este caso, para el comando:</p>
```bash
echo '' > /dev/tcp/$1/$x
```
<br>

<p><font color="yellow">[*]</font> Donde: </p>
* $1   Es   El segundo dígito al ejecutar el script es decir:
```bash
./scanPorts.sh 8.8.8.8
```
<br>
* $x  Es   la variable donde almaceno el comando:
```bash
  seq 1 65535
```
<br>

<p><font color="yellow">[*]</font> Y los && significa si el comando anterior fue correcto entonces ejecutare esto, en este caso:</p>
```bash
echo -e "Port Open :$x"
```
<p><font color="yellow">[*]</font> La <b>-e</b> significa que le quieres indicar a <b>echo</b> que deseas incluir caracteres especiales. Aquí, el carácter especial es <b>$x (seq 1 65536).</b></p>
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

