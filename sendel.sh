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
		mv /home/nouser/Imágenes/2024-* /home/nouser/.www/h4cker-0.github.io/imgs/$1/Cheese$counter.png  2>/dev/null && echo -e "imgs/$1/Cheese$counter.png" | xclip -rmlastnl -sel clip && let counter+=1
		sleep 2.5
	done
}
sendel $1
