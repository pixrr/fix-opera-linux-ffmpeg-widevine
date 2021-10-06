# Fix Opera Linux ffmpeg & WidevineCdm

* Fix Opera html5 media content including DRM-protected one.
* It script must be execute all times opera will fails on showing html5 media content.
* On Debian-based and Arch-based distros it may be started automatically after Opera update.

## Requirements

1. **wget** (Is needed for downloading the ffmpeg lib and widevine)
    ```sudo apt install wget```

2. **unzip** (Is needed for unpacking the downloaded file)
    ```sudo apt install unzip```

## Usage

1. Clone this repo and

    ```git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git```

2. Go to the repo root folder

    ```cd ./fix-opera-linux-ffmpeg-widevine```

3. (*Optional*) Run script. And if it works well go to next step.

    ```sudo ./scripts/fix-opera.sh```

4. Run install script and answer few questions.

    ```sudo ./install.sh```

5. Delete the repo

    ```cd .. && rm -rf ./fix-opera-linux-ffmpeg-widevine```
