#!/bin/bash

#######################################################################
# Description : Script to easily compare checksums on Linux and Mac OS.
# Usage : ./Checksum.sh <Algorithm> <PathToFile>
# Author : Alexandre Guillin
#######################################################################

# Define a few colors 
red='\e[0;31m'
redhl='\e[0;31;7m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
GREEN='\e[0;92m'
NC='\e[0m' # No Color

# Get command arguments
ALGO=$1
FILE_PATH=$2

# ===================================== #
# ========= UTILITY FUNCTIONS ========= #
# ===================================== #

### FUNCTION BEGIN ###
# Utility function that returns OS type.
# OUTPUTS: 
# 	Writes String to STDOUT (solaris, macOS, linux, bsd, windows)
### FUNCTION END ###
function getOS() {
	local os_name
	case "$OSTYPE" in
		solaris*)
			os_name="solaris"
			echo $os_name
		;;
		darwin*)
			os_name="macOS"
			echo $os_name
		;;
		linux*)
			os_name="linux"
			echo $os_name
		;;
		bsd*)
			os_name="bsd"
			echo $os_name
		;;
		msys*)
			os_name="windows"
			echo $os_name
		;;
	esac
}

# ===================================== #
# ========= PROGRAM FUNCTIONS ========= #
# ===================================== #

### FUNCTION BEGIN ###
# Execute command to get hash checksum (on Linux machines)
# GLOBALS: 
#   ALGO, FILE_PATH
# ARGUMENTS: 
# 	Choosen algorithm and file for which we must generate checksum
# RETURN: 
# 	0 if success, non-zero otherwise.
### FUNCTION END ###
function getHashLinux() {
    local cmd_output
    local hash
   
   # Check algorithm and execute command to get checksum
    if [ "$ALGO" == "md5" ]
    then
        cmd_output=$(md5sum $FILE_PATH)
    elif [ "$ALGO" == "sha1" ]
    then
        cmd_output=$(sha1sum $FILE_PATH)
    elif [ "$ALGO" == "sha256" ]
    then
        cmd_output=$(sha256sum $FILE_PATH)
    elif [ "$ALGO" == "sha512" ]
    then
        cmd_output=$(sha512sum $FILE_PATH)
    else
        exit 1
    fi

    # Split output of command to get only output hash
    IFS='  ' read -ra output_array <<< "$cmd_output"
    hash=${output_array[0]}

    # Return value
    echo $hash
}

### FUNCTION BEGIN ###
# Execute command to get hash checksum (on MAC machines)
# GLOBALS: 
#   ALGO, FILE_PATH
# ARGUMENTS: 
# 	Choosen algorithm and file for which we must generate checksum
# RETURN: 
# 	0 if success, non-zero otherwise.
### FUNCTION END ###
function getHashMac() {
    local cmd_output
    local hash
   
   # Check algorithm and execute command to get checksum
    if [ "$ALGO" == "md5" ]
    then
        cmd_output=$(md5 $FILE_PATH)
    elif [ "$ALGO" == "sha1" ]
    then
        cmd_output=$(shasum -a 1 $FILE_PATH)
    elif [ "$ALGO" == "sha256" ]
    then
        cmd_output=$(shasum -a 256 $FILE_PATH)
    elif [ "$ALGO" == "sha512" ]
    then
        cmd_output=$(shasum -a 512 $FILE_PATH)
    else
        exit 1
    fi

    # Split output of command to get only output hash
    IFS='  ' read -ra output_array <<< "$cmd_output"
    hash=${output_array[0]}

    # Return value
    echo $hash
}

# ================================== #
# ========= INITS & CHECKS ========= #
# ================================== #

# Get OS of user machine
OS_TYPE=$(getOS)

# Check if arguments where correcly passed
if [ "$ALGO" == "" ] || [ "$FILE_PATH" == "" ]
then
    echo -e $CYAN"Usage : ./Checksum.sh <Algorithm> <PathToFile>"$NC
    exit 1
fi

# Check if choosen algorithm is correct
valid_algos=("md5" "sha1" "sha256" "sha512")
if [[ ! " ${valid_algos[*]} " =~ " ${ALGO} " ]]
then
    # whatever you want to do when array doesn't contain value
    echo -e $RED"Choosen algorithm is not valid !\nPlease choose md5, sha1, sha256 or sha512."$NC
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]
then
    echo -e $RED"File not found ! Please check file path."$NC
    exit 1
fi

# Define ANSI Colors (color codes can vary between macos and linux bash version because of escape char)
# Get escape character
if [ "$OS_TYPE" == "linux" ]
then
    esc_char="\e"
elif [ "$OS_TYPE" == "macOS" ]
then
    esc_char="\033"
else
    echo "This script only runs on Linux and MacOS !"
    exit 1
fi

# ANSI codes
red="$esc_char[0;31m"
redhl="$esc_char[0;31;7m"
RED="$esc_char[1;31m"
blue="$esc_char[0;34m"
BLUE="$esc_char[1;34m"
cyan="$esc_char[0;36m"
CYAN="$esc_char[1;36m"
GREEN="$esc_char[0;92m"
NC="$esc_char[0m" # No Color

# ==================================== #
# ========= START OF PROGRAM ========= #
# ==================================== #

echo -e $cyan"\n========= COMPARE CHECKSUMS =========\n"$NC
echo -e "[*] Generating hash ..."

# === Get OS and execute right commands === #


if [ "$OS_TYPE" == "linux" ]
then
    hash_to_check=$(getHashLinux)
elif [ "$OS_TYPE" == "macOS" ]
then
    # Check if module shasum is installed
    shasum_check=$(which shasum) 
    if [ $? != 0 ]
    then
        echo -e $RED"[!!!] Fatal Error : shasum module is not installed ! Please install it before continuing !"$NC
        exit 1
    fi
    # If ok then proceed
    hash_to_check=$(getHashMac)
else
    echo -e $RED"Script is only compatible for linux or MacOS machines ... sorry"$NC
    exit 1
fi

echo -e "[*] Hash generated !\n"

# Ask user reference hash
read -p "Please insert reference hash for comparison : " ref_hash

# Show user both hashes
echo -e "\nHash generated ($ALGO)"
echo -e "--------------"
echo -e "$hash_to_check\n"
echo -e "Reference Hash"
echo -e "--------------"
echo -e "$ref_hash\n"

# ================================== #
# ========= PROGRAM OUTPUT ========= #
# ================================== #

# Compare hashes and output result
if [ "$hash_to_check" == "$ref_hash" ]
then
    echo -e $GREEN"OK ! Checksums are a match :-)\n"$NC
else
    echo -e $RED"Checksums don't match !!! :-(\nEither entered hash was wrong or this file has been tampered with ...\n"$NC
fi
