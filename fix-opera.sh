#!/bin/bash

# Run using sudo
if [[ $(whoami) != "root" ]]; then
  printf 'Try to run it with sudo\n'
  exit 1
fi

readonly TEMP_FOLDER='/tmp'
readonly OPERA_FOLDER='/usr/lib/x86_64-linux-gnu/opera'
readonly FILE_NAME='libffmpeg.so'
readonly ZIP_FILE='.zip'
readonly TEMP_FILE="$TEMP_FOLDER/$FILE_NAME"
readonly OPERA_FILE="$OPERA_FOLDER/lib_extra/$FILE_NAME"
readonly FIX_WIDEVINE=true

readonly GIT_API_MAIN=https://api.github.com/repos/iteufel/nwjs-ffmpeg-prebuilt/releases
readonly GIT_API_ALT=https://api.github.com/repos/Ld-Hagen/fix-opera-linux-ffmpeg-widevine/releases

readonly WIDEVINE_VERSIONS=https://dl.google.com/widevine-cdm/versions.txt

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

if $FIX_WIDEVINE;  then
  rm -rf "$OPERA_FOLDER/lib_extra/WidevineCdm"
  printf  "Getting Widevine CDM download Url ...\n"
  readonly WIDEVINE_LATEST=`wget -qO - $WIDEVINE_VERSIONS | tail -n1`
  readonly WIDEVINE_URL="https://dl.google.com/widevine-cdm/$WIDEVINE_LATEST-linux-x64.zip"

  printf  "Downloading Widevine CDM ...\n"
  wget -q --show-progress "$WIDEVINE_URL" -O "$TEMP_FOLDER/widevine.zip"
  if [ $? -ne 0 ]; then
    printf 'Failed to download Widevine CDM. Check your internet connection or try later\n'
    exit 1
  fi

  printf "Extracting Widevine CDM to temporary folder ...\n"
  unzip "$TEMP_FOLDER/widevine.zip" -d $TEMP_FOLDER/widevine > /dev/null

  printf "Installing WidevineCdm ...\n"
  mkdir -p "$OPERA_FOLDER/lib_extra/WidevineCdm/_platform_specific/linux_x64"
  cp -R "$TEMP_FOLDER/widevine/manifest.json" "$OPERA_FOLDER/lib_extra/WidevineCdm/manifest.json"
  cp -R "$TEMP_FOLDER/widevine/libwidevinecdm.so" "$OPERA_FOLDER/lib_extra/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
  printf "[\n      {\n         \"preload\": \"$OPERA_FOLDER/lib_extra/WidevineCdm\"\n      }\n]\n" > "$OPERA_FOLDER/resources/widevine_config.json"

  printf "Deleting temprorary files ...\n"
  rm -rf "$TEMP_FOLDER/widevine"
else
  printf "Installing WidevineCdm skipped\n"
fi
