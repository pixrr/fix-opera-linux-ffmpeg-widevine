# Fix Opera Linux ffmpeg & WidevineCdm

* Fix Opera html5 media content
* It script must be execute all times opera will fails on showing html5 media content.
* Now it also fixes WidevineCdm support for DRM video. You can try it on Vevo youtube channel for example.

## Requirements

1. **wget** (Is needed for downloading the ffmpeg lib and Chrome)
    ```sudo apt install wget```

2. **unzip**, **binutils** (Is needed for unpacking the downloaded file)
    ```sudo apt install unzip binutils```

## Usage

1. Clone this repo

    ```git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git```
    
2. Go to the repo root folder

    ```cd ./fix-opera-linux-ffmpeg-widevine```

3. (*Optional*) You may disable **Widevine** fix if one that comes with Opera works well for you.

    ```sed -i '/FIX_WIDEVINE=/s/true/false/g' ./fix-opera.sh```

4. Run script. And if it works well got ot next step.
    
    ```sudo ./fix-opera.sh```

5. Create a **.scripts** folder on **root**'s **home**
    
    ```sudo mkdir ~root/.scripts```

6. Copy the script into the **.scripts** folder
    
    ```sudo cp ./fix-opera.sh ~root/.scripts```

7. Choose one or both options
    * (*Optional*) Create an **alias**. And then you'll be able to start it by typing ```fix-opera``` command in terminal.
    
        ```echo "alias fix-opera='sudo ~root/.scripts/fix-opera.sh' # Opera fix HTML5 media" >> ~/.bashrc```

        ```source ~/.bashrc```

    * (*Optional*) Autostart after each opera upgrade (Debian-based distros)
        
        ```sudo cp ./99fix-opera ~root/.scripts```
        
        ```sudo ln -s ~root/.scripts/99fix-opera /etc/apt/apt.conf.d/```

8. Delete the repo
    
    ```cd .. && rm -rf ./fix-opera-linux-ffmpeg-widevine```
