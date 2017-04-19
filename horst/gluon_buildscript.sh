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

#community release version (leave empty if not needed)
#COMRELEASE="2015.1.2-0"
COMRELEASE=""

#additional info
ADDINFO="lede_pre-release3"
#ADDINFO=""

#VERSION="exp-cpe210510_lnafix_041069_35c941"
#VERSION="exp-lede_pre-release2_1222c3_3d76c0"
#VERSION="exp-cpe210510_lnafix2_11s_42035c_dab7cb4"

##autoupdater_branch from which the image will get updates (leave empty for autoupdater disabled)
BRANCH=""
#BRANCH="GLUON_BRANCH=stable"

##building broken images
#BROKEN=""
BROKEN="BROKEN=1"

##make loglevel verbose
#LOGLEVEL="V=s"
LOGLEVEL=""

##make logfile anlegen
#BUILDLOG="BUILD_LOG=1"
BUILDLOG=""

#number of threads for make
MAKETHREADS="4"

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
echo "autoupdater-branch: $BRANCH" 
echo "loglevel: $LOGLEVEL"
echo "number of threads: $MAKETHREADS"
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
		echo "loglevel: $LOGLEVEL" >> buildlog.txt
		echo "number of threads: $MAKETHREADS" >> buildlog.txt
		echo "###########################"

		cd gluon
		make clean
		make update

		##targets
		make -j$MAKETHREADS GLUON_TARGET=ar71xx-tiny $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ar71xx-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ar71xx-mikrotik $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ar71xx-nand $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=brcm2708-bcm2708 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=brcm2708-bcm2709 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ipq806x $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=mpc85xx-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=mvebu $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ramips-mt7621 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ramips-mt7628 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=ramips-rt305x $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=sunxi $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=x86-64 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=x86-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG
		make -j$MAKETHREADS GLUON_TARGET=x86-geode $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL $BUILDLOG

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

		#shasums erstellen
		cd ./gluon/output/images/sysupgrade/
		shasum -a 512 * > shasum512
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

