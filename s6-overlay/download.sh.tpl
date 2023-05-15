#!/usr/bin/env bash

set -e

## Set the required S6 Overlay version and architecture
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

S6_OVERLAY_VERSION="3.1.5.0"
S6_OVERLAY_ARCH=arm

## Check if the packed S6 Overlay file already exists
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE_NAME="s6-overlay.tar.xz"
FILE_PATH="$SCRIPT_DIR/../dnscrypt/$FILE_NAME"

if [ -e "$FILE_PATH" ]; then
    echo "The file \"${FILE_NAME}\" exists in the script directory."
else
    echo "The file \"${FILE_NAME}\" DOES NOT exist; downloading dependencies and creating it now..."

    ## The S6 Overlay file does no exist. We need to download it
    ## https://github.com/just-containers/s6-overlay/releases
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    curl -o ${SCRIPT_DIR}/s6-overlay-noarch.tar.xz -fsSLO https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz
    curl -o ${SCRIPT_DIR}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz -fsSLO https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

    mkdir ${SCRIPT_DIR}/s6-overlay
    tar -xf ${SCRIPT_DIR}/s6-overlay-noarch.tar.xz --directory=${SCRIPT_DIR}/s6-overlay
    tar -xf ${SCRIPT_DIR}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz --directory=${SCRIPT_DIR}/s6-overlay

    tar -cf ${FILE_PATH} -C ${SCRIPT_DIR}/s6-overlay .
    rm ${SCRIPT_DIR}/s6-overlay-noarch.tar.xz ${SCRIPT_DIR}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz
    rm -rf ${SCRIPT_DIR}/s6-overlay

    echo "Done!"
fi
