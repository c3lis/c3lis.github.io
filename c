#!/bin/bash

function ctrl_c(){

	echo -e "\e[31mSaliende\[0m"
	exit 1
}


trap ctrl_c INT

sleep 100
