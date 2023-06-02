#!/bin/bash

function ctrl_c(){
	echo -e "\e[31;1mSaliendo\e[0m\n"
	killall jekyll &>/dev/null || kill -9 jekyll &>/dev/null
	exit 2
}
trap ctrl_c INT

if test $UID -eq 0 ;then
	echo ''
else
	echo -e "\n\e[31;1m[!] Tienes que ser usuario root para ejecutar estas acciones.\e[0m\n"
	exit 2
fi

if test -z $1;then
	echo -e "\n\e[31m[!]\e[0m\e[31;1m Indique un nombre para el nombre de la cartpeta.\e[0m\n "
	exit 2
fi


function init(){
	function listener(){
		sudo openvpn /home/anonimo/Documentos/tryhackme/vpn/s4ntiagood.ovpn &>/dev/null &
		jekyll serve --watch --port 80 &>/dev/null & 
		mkdir /home/anonimo/.www/h4cker-0.github.io/imgs/$1 2>/dev/null &>/dev/null && echo -e "\e[33;1mCarpeta Name \e[0m\e[35;1m $1\e[0m";
	}
	declare -i parameterCounter=0;
	function sendel(){
		parameterCounter=$parameterCounter
		for x in $(seq 1 10000);do
			x=$x
			if test -f /home/anonimo/Captura\ de\ pantalla\ de\ 202*; then
				mv /home/anonimo/Captura\ de\ pantalla\ de\ 202* /home/anonimo/.www/h4cker-0.github.io/imgs/$1/$1$parameterCounter.jpg
				echo $1$parameterCounter.jpg
				let parameterCounter+=1
			else
				while true;do
					if test -f /home/anonimo/Captura\ de\ pantalla\ de\ 202* ; then
						sendel $1
					fi
				done
			fi
						

		done
	
	}
	listener $1
	sendel $1
	
} 
init $1
