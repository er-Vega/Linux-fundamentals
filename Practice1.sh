#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#variables Globales

directorio_proyecto="cambiar por ruta del programa"

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm && exit 1 
}

# Ctrl + c
trap ctrl_c INT

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Opciones:${endColour}"
	echo -e "\t${purpleColour}r)${endColour}${grayColour} Correr proyecto${endColour}"
	echo -e "\t${purpleColour}c)${endColour}${grayColour} Compilar proyecto${endColour}"
	echo
}

function correrProyecto(){
	echo -e "\n${redColour}[+] Seguro que quieres CORRER el proyecto? (y/n)${endColour}"
	read respuesta
	if [ "$respuesta" = "y" ] ; then
		echo -e "\n${blueColour}[+]${endColour}${grayColour} Corriendo codigo...${endColour}"
		cd $directorio_proyecto 
		if mvn javafx:run > /dev/null; then	
			echo -e "\n${greenColour}[!] Operacion Exitosa ${endColour}\n"
		else
			echo -e "\n${redColour}[!] Operacion Fallida ${endColour}\n" >&2
			mvn javafx:run
			tput cnorm && exit 1
		fi
		cd;
		echo -e "\n${blueColour}[+]${endColour}${greenColour} Operacion Completada${endColour}"
		echo
	else
		echo -e "\n${redColour}[!] Operacion Cancelada ${endColour}\n"
		exit 1;
	fi
}

function compilarProyecto(){
	echo -e "\n${redColour}[+] Seguro que quieres COMPILAR el proyecto? (y/n)${endColour}"
	read respuesta
	if [ "$respuesta" = "y" ] ; then
		tput civis
		echo -e "\n${blueColour}[+]${endColour}${grayColour} Corriendo codigo...${endColour}"
		cd $directorio_proyecto
		if mvn clean install /dev/null ; then	
			echo -e "\n${greenColour}[!] Operacion Exitosa ${endColour}"
		else
			echo -e "\n${redColour}[!] Operacion Fallida ${endColour}" >&2
			mvn clean install
			tput cnorm && exit 1
		fi
		cd;
		echo -e "\n${blueColour}[+]${endColour}${greenColour} Operacion Completada${endColour}"
		echo
	else
		echo -e "\n${redColour}[!] Operacion Cancelada ${endColour}\n"
		exit 1;
	fi
}

function comp_correr_Proyecto(){
	echo -e "\n${redColour}[+] Seguro que quieres COMPILAR y CORRER el proyecto? (y/n)${endColour}"
	read respuesta
	if [ "$respuesta" = "y" ] ; then
		tput civis
		echo -e "\n${blueColour}[+]${endColour}${grayColour} Corriendo codigo...${endColour}"
		cd $directorio_proyecto;
		if mvn clean install > /dev/null && mvn javafx:run > /dev/null; then	
			echo -e "\n${greenColour}[!] Operacion Exitosa ${endColour}"
		else
			echo -e "\n${redColour}[!] Operacion Fallida ${endColour}" >&2
			mvn clean install && mvn javafx:run #ver fallos
			tput cnorm && exit 1
		fi
		cd;
		echo -e "\n${greenColour}[+]${endColour}${greenColour} Operacion Completada${endColour}"
		echo
		tput cnorm
	else
		echo -e "\n${redColour}[!] Operacion Cancelada ${endColour}\n"
		exit 1;
	fi
}

#doble parametro
declare -i doble_correr=0
declare -i doble_compilar=0

#variable de opcion
declare -i opcion=0

while getopts "hrc" arg ; do
	case $arg in 
	r) doble_correr=1; let opcion+=1;;
	c) doble_compilar=1; let opcion+=2;;
	h);;
	esac
done

if [ $opcion -eq 1 ]; then
	correrProyecto
elif [ $opcion -eq 2 ]; then
	compilarProyecto
elif [ $doble_correr -eq 1 ] && [ $doble_compilar -eq 1 ]; then	
	comp_correr_Proyecto
else
	helpPanel
fi

