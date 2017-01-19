#!/bin/bash

###settings


##firmware-name
#VERSION="exp-cpe210510_lnafix_041069_35c941"
#VERSION="exp-2016.2.x_42035c_dab7cb4"
VERSION="exp-cpe210510_lnafix2_11s_42035c_dab7cb4"

##autoupdater_branch
BRANCH=""
#BRANCH="GLUON_BRANCH=stable"

##building broken images
#BROKEN=""
BROKEN="BROKEN=1"

##make loglevel verbose
#LOGLEVEL="V=s"
LOGLEVEL=""


###build und buildlog

STARTTIME=$(date +%s)
STARTTIME2=$(date) 

echo "Name des builds: $VERSION" >> buildlog.txt
echo "autoupdater-branch: $BRANCH" >> buildlog.txt


cd gluon
make clean
make update

##targets
make -j4 GLUON_TARGET=ar71xx-tiny $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=ar71xx-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=ar71xx-mikrotik $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=ar71xx-nand $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=brcm2708-bcm2708 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=brcm2708-bcm2709 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=mpc85xx-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=mvebu $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=ramips-mt7621 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=ramips-rt305x $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=sunxi $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=x86-64 $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=x86-generic $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL
#make -j4 GLUON_TARGET=x86-xen_domu $BRANCH DEFAULT_GLUON_RELEASE=$VERSION $BROKEN $LOGLEVEL


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
md5sum > md5sum
cd -
cd ./gluon/output/images/factory/
shasum -a 512 * > shasum512
md5sum > md5sum
cd -

##shutdown after build
#shutdown -h 1 
