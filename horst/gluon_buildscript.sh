#!/bin/bash


########################################################
###settings
#######################################################

##firmware-name
#namesheme is as follows in freifunk flensburg releases
#gluon-fffl-branchname-comrelease_additional+info_gluon+commit_site+commit-routername.bin

#name! of the branch 
BRANCHNAME="exp"
#BRANCHNAME="stable"
#BRANCHNAME="custom"


#community release version (leave empty if you just building your custom fw)
#COMRELEASE=""
#COMRELEASE="2015.1.2-0"
COMRELEASE="2099.1.0-0"

#additional info
ADDINFO=""
#ADDINFO="_batmanadv14"


##autoupdater_branch from which the image will get updates
#BRANCH="GLUON_AUTOUPDATER_BRANCH=stable"
BRANCH="GLUON_AUTOUPDATER_BRANCH=experimental"

AUTOUPDATER_ENABLED="GLUON_AUTOUPDATER_ENABLED=1"

##building broken images
BROKEN="BROKEN=1"
#BROKEN=""

##make loglevel verbose
#LOGLEVEL="V=s"
#LOGLEVEL="V=sc"
LOGLEVEL=""

##make logfile anlegen
#BUILDLOG="BUILD_LOG=1"
BUILDLOG=""

#number of threads for make
MAKETHREADS="4"

#maximum load for new make threads
MAXLOAD="4.1"

########################################################
###build und buildlog
#######################################################

#get commit sha and info for filename
cd ./gluon
GLUONSHA=$(git log -1 --format="%h")
GLUONINFO=$(git log -1 --format="%n %h %n %an %n %s %n %ad")
cd ./site
SITESHA=$(git log -1 --format="%h")
SITEINFO=$(git log -1 --format="%n %h %n %an %n %s %n %ad")
cd ..
cd ..


#definition of namesheme
VERSION="$BRANCHNAME"-"$COMRELEASE""$ADDINFO"_"$GLUONSHA"_"$SITESHA"

echo "---------------"
echo "the script will build with following settings"
echo "---------------"
echo "gluon-commit: $GLUONINFO"
echo "..."
echo "site-fffl-commit: $SITEINFO"
echo "---------------"
echo "example name of the build:"
echo "gluon-fffl-$VERSION-routername.bin" 
echo "---------------"
echo "$BRANCH"
echo "$AUTOUPDATER_ENABLED" 
echo "loglevel: $LOGLEVEL"
echo "number of threads: $MAKETHREADS"
echo "max load: $MAXLOAD"
echo "###########################"

echo "Proceed with the build? (y;n)"
read answer
echo your answer was: $answer
case $answer in
	n*|N*) exit ;; #exit on answer no
    
	j*|J*|y*|Y*) #buildcase on answer yes
 
		#get time for build-time measurement
		STARTTIME=$(date +%s)
		STARTTIME2=$(date) 

		#fill buildlog with info 
		echo "Name des builds:" >> buildlog.txt
		echo "gluon-fffl-$VERSION-routername.bin" >> buildlog.txt

		echo "gluon-commit: $GLUONINFO" >> buildlog.txt
		echo "..." >> buildlog.txt

		echo "site-fffl-commit: $SITEINFO" >> buildlog.txt
		echo "---------------" >> buildlog.txt

		echo "autoupdater-branch: $BRANCH" >> buildlog.txt
		echo "$AUTOUPDATER_ENABLED" >> buildlog.txt
		echo "loglevel: $LOGLEVEL" >> buildlog.txt
		echo "number of threads: $MAKETHREADS" >> buildlog.txt
		echo "###########################"

		cd gluon
		
		make update
		make clean
  		#apply patches from /gluon/site/patches
		bash ./site/scripts/apply_patches.sh ./ ./site/patches
		make update

		##targets # consider GLUON_AUTOREMOVE=1 on each target to reduce hdd space impact
 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ath79-generic $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ath79-nand $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ath79-mikrotik $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 	
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=brcm2708-bcm2708 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=brcm2708-bcm2709 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=brcm2708-bcm2710 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ipq40xx-generic $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ipq40xx-mikrotik $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 		
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ipq806x-generic $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=lantiq-xrx200 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=lantiq-xway $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=mediatek-mt7622 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 		
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=mpc85xx-p1010 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=mpc85xx-p1020 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=mvebu-cortexa9 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ramips-mt7620 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ramips-mt76x8 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=ramips-rt7621 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=realtek-rtl838x $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 		
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=rockchip-armv8 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1		
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=sunxi-cortexa7 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=x86-64 $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=x86-generic $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=x86-geode $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 
		make -j$MAKETHREADS -l$MAXLOAD GLUON_TARGET=x86-legacy $BRANCH $AUTOUPDATER_ENABLED DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG GLUON_AUTOREMOVE=1 



		##fill buildlog with build duration info
		ENDTIME=$(date +%s)
		ENDTIME2=$(date)
		time_min=$(((($ENDTIME - $STARTTIME))/60))
		time_h=$(((($time_min))/60))

		echo "Images bauen dauerte $(($ENDTIME - $STARTTIME)) sekunden..."
		echo "bzw $time_min" minuten

		cd ..
		echo "start: $STARTTIME2 ende: $ENDTIME2" >> buildlog.txt
		echo "Images bauen dauerte $(($ENDTIME - $STARTTIME)) sekunden..." >> buildlog.txt
		echo "bzw $time_min minuten" >> buildlog.txt
		echo "" >> buildlog.txt
		echo "" >> buildlog.txt
		echo "###############nextbuild################" >> buildlog.txt
		
		#manifest erstellen
		cd ./gluon/
		make manifest $BRANCH DEFAULT_GLUON_RELEASE=$VERSION
		cd -

		#shasums erstellen
		cd ./gluon/output/images/sysupgrade/
		shasum -a 512 * > shasum512
		shasum -a 256 * > shasum256
		md5sum * > md5sum
		cd -
		cd ./gluon/output/images/factory/
		shasum -a 512 * > shasum512
		md5sum * > md5sum
		cd -

		##shutdown after build
		#shutdown -h 1 
                   ;;
	*) echo pls answer y or n ;;  #error on undefined answer
esac 

