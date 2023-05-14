#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/s6-overlay"
FILE_NAME="download.sh"
FILE_PATH="$SCRIPT_DIR/$FILE_NAME"

if [ -e "$FILE_PATH" ]; then
    echo "File \"${FILE_NAME}\" exists in the script directory."
    echo "Proceeding with the download and boot process."
else
    echo "File \"${FILE_NAME}\" does not exist. Please create it from the template file."
    echo "[ IMPORTANT ]: Make sure to set the expected architecture for your server."
    exit 1
fi

./s6-overlay/download.sh
