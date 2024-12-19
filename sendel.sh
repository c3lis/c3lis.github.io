#!/bin/bash
function ctrl_c(){
	echo -e "	* Saliendo"
	exit 1
}
trap ctrl_c INT
if [ -z $1 ]; then
	echo -e "* nombre del contenedor de imagenes"
	exit 1
fi
mkdir ./imgs/$1 2>/dev/null

function sendel(){

	counter=0;
	while true; do
		mv /home/c3lis/Imágenes/2024-* /home/c3lis/.www/c3lis.github.io/imgs/$1/$1$counter.png  2>/dev/null && echo -e """<img src="imgs/$1/$1$counter.png">""" | xclip -rmlastnl -sel clip && let counter+=1
		sleep 2.5
	done
}
sendel $1

