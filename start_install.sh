#!/bin/sh
#
# Execute with sudo !
#

# Create variables
FILE="linux64"
LINK="https://dl.pstmn.io/download/latest/$FILE"
FOLDER_INSTALL="/opt/Postman"
DESKTOP_FILE="$HOME/.local/share/applications/Postman.desktop"

############################
#
#   function to downloading binary 
#   @var FILE file with binary downloaded
#   @var LINK link to download
#   @var PATH_FOLDER path to extract final folder
#
#############################
download()
{
    FILE=$1
    LINK=$2
    PATH_FOLDER=$3

    if [ ! -f $FILE ]; then
       echo "Downloading binary ..."
       /usr/bin/wget $LINK

       download $FILE $LINK $PATH_FOLDER
    else
       echo "Extracting binary ..."
       extract $FILE $PATH_FOLDER
    fi
    
}
############################
#
#   function to extract binary to folder 
#   @var FILE file with binary downloaded
#   @var PATH_FOLDER path to extract final folder
#
#############################
extract()
{
    FILE=$1
    PATH_FOLDER=$2
    echo "$FILE";
    echo "$PATH_FOLDER";
    echo "Extracting ...";
    # remove extract folder, remove temp file and move folder to path
    /bin/tar -xzvf $FILE && rm -R $FILE && mv Postman $PATH_FOLDER
}
############################
#
#   function to make desktop file 
#   @var FOLDER_INSTALL path to your install folder
#   @var PATH_DESKTOP_FILE path to create your desktop file
#
#############################
make_desktop()
{
    FOLDER_INSTALL=$1
    PATH_DESKTOP_FILE=$2
    
    echo "[Desktop Entry]
    Encoding=UTF-8
    Name=Postman
    Exec=$FOLDER_INSTALL/app/Postman %U
    Icon=$FOLDER_INSTALL/app/resources/app/assets/icon.png
    Terminal=false
    Type=Application
    Categories=Development;" > $PATH_DESKTOP_FILE
    
    echo "Fixing permissions ...";
    fix_permission $FOLDER_INSTALL $PATH_DESKTOP_FILE
}
############################
#
#   function to fix permission  
#   @var FOLDER_INSTALL path to your install folder
#   @var PATH_DESKTOP_FILE path to your desktop file
#
#############################
fix_permission()
{
    FOLDER_INSTALL=$1
    PATH_DESKTOP_FILE=$2

    chmod +x $PATH_DESKTOP_FILE && chown $USER:$USER $FOLDER_INSTALL $PATH_DESKTOP_FILE
}

# Execute
echo "Starting ...";
download $FILE $LINK $FOLDER_INSTALL

echo "Making desktop file ...";
make_desktop $FOLDER_INSTALL $DESKTOP_FILE

echo "Done !";
