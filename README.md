# Fix Opera Linux ffmpeg & WidevineCdm

* Fix Opera html5 media content including DRM-protected one.
* It script must be execute all times opera will fails on showing html5 media content.
* On Debian-based and Arch-based distros it may be started automatically after Opera update.

## Requirements

1. **wget** (Is needed for downloading the ffmpeg lib and Chrome)
    ```sudo apt install wget```

2. **unzip** (Is needed for unpacking the downloaded file)
    ```sudo apt install unzip```

## Usage

1. Clone this repo

    ```git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git```
    
2. Go to the repo root folder

    ```cd ./fix-opera-linux-ffmpeg-widevine```

3. Run install script and answer few questions.
    
    ```sudo ./install.sh```

