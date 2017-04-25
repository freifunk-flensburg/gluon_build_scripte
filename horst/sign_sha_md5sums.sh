#!/bin/bash
### script signs checksumfiles

## settings
SECRETPATH="/path/to/secret" #path to secretfile
GLUONPATH="/path/to/gluon" #path to cloned gluon folder

##
echo "---------------------------------------------------"
echo ""
echo "do you want to sign shasum512 and md5sums in factory and sysupgrade? (y;n)"
read answer
echo your answer was: $answer
case $answer in
	n*|N*) exit ;; #exit on answer no
    
	j*|J*|y*|Y*) #buildcase on answer yes

			
			#sign manifests
			cd ./gluon/contrib/
			./sign.sh $SECRETPATH $GLUONPATH/output/images/factory/shasum512 
			./sign.sh $SECRETPATH $GLUONPATH/output/images/factory/md5sum 
			./sign.sh $SECRETPATH $GLUONPATH/output/images/sysupgrade/md5sum 
			./sign.sh $SECRETPATH $GLUONPATH/output/images/sysupgrade/shasum512
			echo ""
			echo "---------------------------------------------------"
			echo "signing finished"
			cd - 
			;;

	*) echo pls answer y or n ;;  #error on undefined answer
esac 

