#!/bin/bash

###script clones github gluon and site-fffl
echo "---------------------------------------------------"
echo ""
echo "do you want to clone gluon/site-fffl/ in this folder? (y;n)"
read answer
echo your answer was: $answer
case $answer in
	n*|N*) exit ;; #exit on answer no
    
	j*|J*|y*|Y*) #buildcase on answer yes

			#clone gluon
			git clone https://github.com/freifunk-gluon/gluon.git

			#clone site-fffl
			cd gluon
			git clone https://github.com/freifunk-flensburg/site-fffl.git site
			echo ""
			echo "---------------------------------------------------"
			echo "git cloning of gluon and site-fffl finished" 
			;;

	*) echo pls answer y or n ;;  #error on undefined answer
esac 

