#!/bin/bash

set -euo pipefail

GLUON_BRANCH="v2021.1.2"
SITE_NAME="fffl"
SITE_BRANCH="2021.1.2"
SITE_VERSION="0"
BUILD_NAME="exp"
BUILD_BRANCH="experimental"

if [[ ! -d gluon ]];then
    git clone --branch="${GLUON_BRANCH}" --depth=1 https://github.com/freifunk-gluon/gluon.git
fi

if [[ ! -d gluon/site ]];then
    git clone --branch="${SITE_BRANCH}"  --depth=1 https://github.com/freifunk-flensburg/site-fffl.git gluon/site
fi

cd ./gluon/
GLUON_SHA=$(git log -1 --format="%h")
GLUON_INFO="$(git branch --show-current) - $(git tag) - $(git log -1 --format='%h %an %s %ad')"
cd -

cd ./gluon/site/
SITE_SHA=$(git log -1 --format="%h")
SITE_INFO="$(git branch --show-current) - $(git tag) - $(git log -1 --format='%h %an %s %ad')"
cd -

#gluon-fffl-buildname-sitebranch-siteversion_gluon+commit_site+commit-routername.bin
VERSION="${BUILD_NAME}-${SITE_BRANCH}-${SITE_VERSION}_${GLUON_SHA}_${SITE_SHA}"
OPTIONS="GLUON_AUTOUPDATER_BRANCH=${BUILD_BRANCH} GLUON_AUTOUPDATER_ENABLED=1 DEFAULT_GLUON_RELEASE=${VERSION} BROKEN=1"

TARGETS=(ar71xx-generic ar71xx-tiny ar71xx-nand ath79-generic brcm2708-bcm2708 brcm2708-bcm2709 ipq40xx-generic ipq806x-generic lantiq-xrx200 lantiq-xway mpc85xx-generic mpc85xx-p1020 ramips-mt7620 ramips-mt7621 ramips-mt76x8 ramips-rt305x sunxi-cortexa7 x86-generic x86-geode x86-legacy x86-64)

LOGFILE="${PWD}/log_build_$(date +%s).txt"
THREADS=$(nproc)

function log() {
    echo "$(date -u) $@" | tee -ap --output-error=exit "${LOGFILE}"
}

function log_time() {
    echo "$(($SECONDS / 60)) minutes and $(($SECONDS % 60)) seconds elapsed."
}

log "Buildlog: ${LOGFILE}"
log "Buildscript: $(shasum -a 512 --tag "$0")"
log "Building with: ${THREADS} threads on $(uname -rvmo)"
log "Filename: gluon-${SITE_NAME}-${VERSION}-routername.bin"
log "Options: ${OPTIONS}"
log "Targets: ${TARGETS[@]}"
log "gluon: ${GLUON_INFO}"
log "site: ${SITE_INFO}"

echo "#############################"
echo "Proceed with the build? (y|n)"

read answer
case $answer in
    y)
        log "Build started"

        cd ./gluon/

        SECONDS=0

        log "Starting gluon make update"
        make -j"${THREADS}" update "${OPTIONS}"

        log "Starting gluon make clean"
        make -j"${THREADS}" clean  "${OPTIONS}"

        log "Starting gluon make update again"
        make -j"${THREADS}" update "${OPTIONS}"

        log "Time for preparing: $(log_time)"

        for TARGET in ${TARGETS[@]}; do
            SECONDS=0

            log "Building ${TARGET}"
            make -j"${THREADS}" GLUON_TARGET="${TARGET}" "${OPTIONS}"

            log "Built ${TARGET}"
            make -j"${THREADS}" GLUON_TARGET="${TARGET}" "${OPTIONS}" clean

            log "Time for ${TARGET}: $(log_time)"
        done

        log "Starting manifest generation"

        make -j"${THREADS}" "${OPTIONS}" manifest

        log "Manifest: $(cat ./output/images/sysupgrade/"${BUILD_BRANCH}".manifest | shasum -a 512)"

        for IMAGE in factory sysupgrade other; do
            log "Creating hashes for ${IMAGE}"

            cd "./output/images/${IMAGE}"
            shasum -a 512 gluon-* > shasum512
            log "$(shasum -a 512 --tag shasum512)"

            shasum -a 256 gluon-* > shasum256
            log "$(shasum -a 512 --tag shasum256)"

            md5sum gluon-* > md5sum
            log "$(shasum -a 512 --tag md5sum)"
            cd -
        done

        cd ..

        log "Build finished"
    ;;
esac

