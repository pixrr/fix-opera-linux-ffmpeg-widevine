#!/bin/bash

# Run using sudo
if [[ $(whoami) != "root" ]]; then
  printf 'Try to run it with sudo\n'
  exit 1
fi

readonly TEMP_FOLDER='/tmp/'
readonly OPERA_FOLDER='/usr/lib/x86_64-linux-gnu/opera'
readonly FILE_NAME='libffmpeg.so'
readonly ZIP_FILE='.zip'
readonly TEMP_FILE="$TEMP_FOLDER$FILE_NAME"
readonly OPERA_FILE="$OPERA_FOLDER/lib_extra/$FILE_NAME"
readonly FIX_WIDEVINE=true
readonly CHROME_DL_LINK="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

readonly GIT_API_MAIN=https://api.github.com/repos/iteufel/nwjs-ffmpeg-prebuilt/releases
readonly GIT_API_ALT=https://api.github.com/repos/Ld-Hagen/fix-opera-linux-ffmpeg-widevine/releases

if ! which ar > /dev/null && $FIX_WIDEVINE; then
  printf '\033[1mbinutils\033[0m package must be installed to fix Widevine\n'
  exit 1
fi

if ! which unzip > /dev/null; then
  printf '\033[1munzip\033[0m package must be installed to run this script\n'
  exit 1
fi

if ! which wget > /dev/null; then
  printf '\033[1mwget\033[0m package must be installed to run this script\n'
  exit 1
fi

printf 'Getting ffmpeg download Url ...\n'
readonly OPERA_FFMPEG_URL_MAIN=$(wget -qO - $GIT_API_MAIN | grep browser_download_url | cut -d '"' -f 4 | grep linux-x64 | head -n 1)
readonly OPERA_FFMPEG_URL_ALT=$(wget -qO - $GIT_API_ALT | grep browser_download_url | cut -d '"' -f 4 | grep linux-x64 | head -n 1)

if [ `basename $OPERA_FFMPEG_URL_ALT` \< `basename $OPERA_FFMPEG_URL_MAIN` ]; then
  readonly OPERA_FFMPEG_URL=$OPERA_FFMPEG_URL_MAIN
else
  readonly OPERA_FFMPEG_URL=$OPERA_FFMPEG_URL_ALT
fi

if [ -z "$OPERA_FFMPEG_URL" ]; then
  printf 'Failed to get ffmpeg download URL. EXiting...\n'
  exit 1
fi

printf 'Downloading ffmpeg ...\n'
wget -q --show-progress $OPERA_FFMPEG_URL -O "$TEMP_FILE$ZIP_FILE"
if [ $? -ne 0 ]; then
  printf 'Failed to download ffmpeg. Check your internet connection or try later\n'
  exit 1
fi

printf "Unzipping ...\n"
unzip "$TEMP_FILE$ZIP_FILE" -d $TEMP_FILE > /dev/null

printf "Moving file on $OPERA_FILE ...\n"
mkdir -p "$OPERA_FOLDER/lib_extra"
mv -f "$TEMP_FILE/$FILE_NAME" $OPERA_FILE

printf 'Deleting Temporary files ...\n'
find $TEMP_FOLDER -name "*$FILE_NAME*" -delete

if $FIX_WIDEVINE
  then
    rm -rf "$OPERA_FOLDER/lib_extra/WidevineCdm"
    printf  "Downloading Google Chrome ...\n"
    mkdir "$TEMP_FOLDER/chrome"
    cd "$TEMP_FOLDER/chrome"
    wget -q --show-progress "$CHROME_DL_LINK"
    if [ $? -ne 0 ]; then
      printf 'Failed to download Google Chrome. Check your internet connection or try later\n'
      exit 1
    fi

    printf "Extracting Chrome to temporary folder ...\n"
    CHROME_PKG_NAME=`basename $CHROME_DL_LINK`
    ar x "$CHROME_PKG_NAME"
    tar xf data.tar.xz

    printf "Installing WidevineCdm ...\n"
    cp -R "$TEMP_FOLDER/chrome/opt/google/chrome/WidevineCdm" "$OPERA_FOLDER/lib_extra/"
    printf "[\n      {\n         \"preload\": \"$OPERA_FOLDER/lib_extra/WidevineCdm\"\n      }\n]\n" > "$OPERA_FOLDER/resources/widevine_config.json"

    printf "Deleting temprorary files ...\n"
    rm -rf "$TEMP_FOLDER/chrome"
  else
    printf "Installing WidevineCdm skipped\n"
fi
