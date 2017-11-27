#!/bin/sh

#===============================================================
# CONSTANTS
#---------------------------------------------------------------
FONT_NORMAL="\\033[0m"
FONT_BOLD="\\033[1m"
FONT_HALF="\\033[2m"

FONT_RED="\\033[31m"
FONT_GREEN="\\033[32m"
FONT_CYAN="\\033[36m"
FONT_GREEY="\\033[37m"


#===============================================================
# DESCRIPTION
#---------------------------------------------------------------
echo ''
echo "${FONT_BOLD}HOMESTEAD ${FONT_GREEN}EASY UP${FONT_NORMAL}"
echo "${FONT_GREEY}version: 0.1${FONT_NORMAL}"
echo ''
echo "---------------------------"
echo ''
echo "${FONT_BOLD}Solutions to possible problems${FONT_NORMAL}"
echo "${FONT_BOLD}${FONT_GREEY}1. VT-x or AMD-V virtualization not available:${FONT_NORMAL}"
echo "${FONT_GREEY}You can get this error if you are trying to start x64 bit virtual machine.${FONT_NORMAL}"
echo "${FONT_GREEY}Please check the BIOS settings.${FONT_NORMAL}"
echo ''
echo "${FONT_BOLD}${FONT_GREEY}2. NFS isn't supported:${FONT_NORMAL}"
echo "${FONT_GREEY}If you are using NFS, you must install nfs-kernel-serverll.${FONT_NORMAL}"
echo "${FONT_GREEY}(sudo apt-get install nfs-common nfs-kernel-server)${FONT_NORMAL}"
echo ''
echo "---------------------------"
echo ''



#===============================================================
# FUNCTIONS
#---------------------------------------------------------------
# Make directory
# - $1: directory path 
MakeDir() {
    ERROR=$(mkdir $1 2>&1)
    
    if [ ! $? -eq 0 ]; then
        echo "${FONT_BOLD}${FONT_RED} x ${FONT_CYAN} $1 ${FONT_HALF} ${ERROR} ${FONT_NORMAL}"
        exit 0
    fi
}

#---------------------------------------------------------------
# Copy file to
# - $1: source path
# - $2: destination path
CopyFileTo() {
    ERROR=$($(cp "${1}" "${2}") 2>&1)
    
    if [ ! $? -eq 0 ]; then
        echo "${FONT_BOLD}${FONT_RED} x ${FONT_CYAN} copy ${1} -> ${2}  ${FONT_HALF} ${ERROR} ${FONT_NORMAL}"
        exit 0
    fi
}

#---------------------------------------------------------------
# Append text to file
# - $1: file path
# - $2: text
AppendToFile() {
    ERROR=$($(echo "${2}" >> $1) 2>&1)
    
    if [ ! $? -eq 0 ]; then
        echo "${FONT_BOLD}${FONT_RED} x ${FONT_CYAN} $1 ${FONT_HALF} ${ERROR} ${FONT_NORMAL}"
        exit 0
    fi
}



#===============================================================
# INPUT
#---------------------------------------------------------------
echo "${FONT_BOLD}Project settings${FONT_NORMAL}"


#---------------------------------------------------------------
# Project name
echo -n " - [1/8] project name (${FONT_BOLD}${FONT_CYAN}homestead${FONT_NORMAL}): "
read INPUT_PROJECT_NAME

if [ "${INPUT_PROJECT_NAME}" = "" ]; then
    PROJECT_NAME="homestead"
else
    PROJECT_NAME=${INPUT_PROJECT_NAME}
fi


#---------------------------------------------------------------
# Database name
echo -n " - [2/8] database name (${FONT_BOLD}${FONT_CYAN}db_${PROJECT_NAME}${FONT_NORMAL}): "
read INPUT_DB_NAME

if [ "${INPUT_DB_NAME}" = "" ]; then
    DB_NAME="db_${PROJECT_NAME}"
else
    DB_NAME="${INPUT_DB_NAME}"
fi
echo ""


#---------------------------------------------------------------
echo "${FONT_BOLD}Site settings${FONT_NORMAL}"


#---------------------------------------------------------------
# IP
echo -n " - [3/8] server ip (${FONT_BOLD}${FONT_CYAN}192.168.10.10${FONT_NORMAL}): "
read INPUT_IP

if [ "${INPUT_IP}" = "" ]; then
    IP="192.168.10.10"
else
    IP="${INPUT_IP}"
fi


#---------------------------------------------------------------
# Index folder
echo -n " - [4/8] index folder (${FONT_CYAN}.|web|${FONT_BOLD}public${FONT_NORMAL}): "
read INPUT_ROOT_FOLDER

if [ "${INPUT_ROOT_FOLDER}" = "" ]; then
    ROOT_FOLDER="public"
else
    ROOT_FOLDER="${INPUT_ROOT_FOLDER}"
fi
echo ""


#---------------------------------------------------------------
echo "${FONT_BOLD}Vagrant settings${FONT_NORMAL}"


#---------------------------------------------------------------
# Homestead version
echo -n " - [5/8] homestead version (${FONT_BOLD}${FONT_CYAN}latest${FONT_NORMAL}): "
read INPUT_HOMESTEAD_VERSION
if [ "${INPUT_HOMESTEAD_VERSION}" = "" ]; then
    HOMESTEAD_VERSION="latest"
else
    HOMESTEAD_VERSION="${INPUT_HOMESTEAD_VERSION}"
fi


#---------------------------------------------------------------
# Memory
echo -n " - [6/8] memory size (${FONT_BOLD}${FONT_CYAN}2048${FONT_NORMAL}): "
read INPUT_MEMORY

if [ "${INPUT_MEMORY}" = "" ]; then
    MEMORY=2048
else
    MEMORY="${INPUT_MEMORY}"
fi


#---------------------------------------------------------------
# Cpus
echo -n " - [7/8] CPU cores (${FONT_BOLD}${FONT_CYAN}1${FONT_NORMAL}): "
read INPUT_CPU

if [ "${INPUT_CPUS}" = "" ]; then
    CPUS=1
else
    CPUS="${INPUT_CPUS}"
fi


#---------------------------------------------------------------
# Cpus
echo -n " - [8/8] enable NFS (${FONT_CYAN}y/${FONT_BOLD}N${FONT_NORMAL}): "
read INPUT_NFS

case ${INPUT_NFS} in
	Y) IS_NFS="yes" ;;
	y) IS_NFS="yes" ;;
	*) IS_NFS="no" ;;
esac

echo ''
echo "---------------------------"
echo ''



#===============================================================
# CREATE DIRECTORIES
#---------------------------------------------------------------
echo ${FONT_BOLD}"Create directories:"${FONT_NORMAL}


#---------------------------------------------------------------
DIR_PATH='./homestead'

if [ ! -d "${DIR_PATH}" ]; then
    MakeDir "${DIR_PATH}"
fi

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${DIR_PATH} ${FONT_NORMAL}"


#---------------------------------------------------------------
DIR_PATH='./homestead/config'

if [ ! -d "${DIR_PATH}" ]; then
    MakeDir "${DIR_PATH}"
fi

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${DIR_PATH} ${FONT_NORMAL}"
echo ""



#==============================================================
# SETUP HOMESTEAD
#--------------------------------------------------------------
if [ ! -f ./homestead/source/scripts/homestead.rb ]; then
    echo "${FONT_BOLD}Setup Homestead${FONT_NORMAL}"
    
    if [ -e ./homestead/source ]; then
        rm -rf ./homestead/source
    fi
    
    git clone https://github.com/laravel/homestead.git './homestead/source/'
    echo ""
fi



#==============================================================
# CREATE FILES
#--------------------------------------------------------------
echo ${FONT_BOLD}"Create files:"${FONT_NORMAL}


#--------------------------------------------------------------
FILE_PATH='./homestead/.gitignore'

if [ ! -f ${FILE_PATH} ]; then
    AppendToFile ${FILE_PATH} '/source'
fi    

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${FILE_PATH} ${FONT_NORMAL}"


#--------------------------------------------------------------
FILE_PATH='./homestead/config/after.sh'

if [ ! -f ${FILE_PATH} ]; then
    CopyFileTo './homestead/source/resources/after.sh' "${FILE_PATH}"
fi    

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${FILE_PATH} ${FONT_NORMAL}"


#--------------------------------------------------------------
FILE_PATH='./homestead/config/aliases'

if [ ! -f ${FILE_PATH} ]; then
    CopyFileTo './homestead/source/resources/aliases' "${FILE_PATH}"
fi    

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${FILE_PATH} ${FONT_NORMAL}"


#--------------------------------------------------------------
FILE_PATH='./homestead/config/Homestead.yaml'

if [ ! -f ${FILE_PATH} ]; then
    AppendToFile ${FILE_PATH} '---'
    AppendToFile ${FILE_PATH} 'name: '$PROJECT_NAME
    
if [ ! ${HOMESTEAD_VERSION} = "latest" ]; then
    AppendToFile ${FILE_PATH} 'version: '${HOMESTEAD_VERSION}
fi    
    
    AppendToFile ${FILE_PATH} ''    
    AppendToFile ${FILE_PATH} 'provider: virtualbox'
    AppendToFile ${FILE_PATH} 'memory: '${MEMORY}
    AppendToFile ${FILE_PATH} 'cpus: '${CPUS}
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'hostname: '${PROJECT_NAME}'.dev'
    AppendToFile ${FILE_PATH} 'ip: '${IP}
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'authorize: ~/.ssh/id_rsa.pub'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'keys:'
    AppendToFile ${FILE_PATH} "    - ~/.ssh/id_rsa"
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'folders:'
    AppendToFile ${FILE_PATH} '    - map: "."'
    AppendToFile ${FILE_PATH} '      to: /home/vagrant/source'
    
if [ ${IS_NFS} = "yes" ]; then
    AppendToFile ${FILE_PATH} '      type: "nfs"'
fi

    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'sites:'
    AppendToFile ${FILE_PATH} '    - map: '${PROJECT_NAME}'.dev'
    AppendToFile ${FILE_PATH} '      to: /home/vagrant/source/'${ROOT_FOLDER}
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'databases:'
    AppendToFile ${FILE_PATH} '    - '${DB_NAME}
    AppendToFile ${FILE_PATH} ''    
fi    

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${FILE_PATH} ${FONT_NORMAL}"


#--------------------------------------------------------------
FILE_PATH='./Vagrantfile'

if [ ! -f ${FILE_PATH} ]; then
    AppendToFile ${FILE_PATH} '# -*- mode: ruby -*-'
    AppendToFile ${FILE_PATH} '# vi: set ft=ruby :'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'require "json"'
    AppendToFile ${FILE_PATH} 'require "yaml"'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'VAGRANTFILE_API_VERSION ||= "2"'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'homesteadYamlPath = "homestead/config/Homestead.yaml"'
    AppendToFile ${FILE_PATH} 'homesteadJsonPath = "homestead/config/Homestead.json"'
    AppendToFile ${FILE_PATH} 'afterScriptPath = "homestead/config/after.sh"'
    AppendToFile ${FILE_PATH} 'aliasesPath = "homestead/config/aliases"'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'require File.expand_path(File.dirname(__FILE__) + "/homestead/source/scripts/homestead.rb")'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'Vagrant.require_version ">= 1.9.0"'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} 'Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|'
    AppendToFile ${FILE_PATH} '    if File.exist? aliasesPath then'
    AppendToFile ${FILE_PATH} '        config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"'
    AppendToFile ${FILE_PATH} '    end'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} '    if File.exist? homesteadYamlPath then'
    AppendToFile ${FILE_PATH} '        settings = YAML::load(File.read(homesteadYamlPath))'
    AppendToFile ${FILE_PATH} '    elsif File.exist? homesteadJsonPath then'    
    AppendToFile ${FILE_PATH} '        settings = JSON.parse(File.read(homesteadJsonPath))'
    AppendToFile ${FILE_PATH} '    else'
    AppendToFile ${FILE_PATH} '        abort "Homestead settings file not found in #{confDir}"'        
    AppendToFile ${FILE_PATH} '    end'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} '    Homestead.configure(config, settings)'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} '    if File.exist? afterScriptPath then'
    AppendToFile ${FILE_PATH} '        config.vm.provision "shell", path: afterScriptPath, privileged: false, keep_color: true'
    AppendToFile ${FILE_PATH} '    end'
    AppendToFile ${FILE_PATH} ''
    AppendToFile ${FILE_PATH} '    if defined? VagrantPlugins::HostsUpdater'
    AppendToFile ${FILE_PATH} '        config.hostsupdater.aliases = settings["sites"].map { |site| site["map"] }'
    AppendToFile ${FILE_PATH} '    end'
    AppendToFile ${FILE_PATH} 'end'
    AppendToFile ${FILE_PATH} ''
fi    

echo "${FONT_BOLD}${FONT_GREEN} + ${FONT_CYAN} ${FILE_PATH} ${FONT_NORMAL}"

echo ''
echo "---------------------------"
echo ''



#==============================================================
# SETUP VAGRANT AND UP
#-------------------------------------------------------------
echo "${FONT_BOLD}Vagrant up${FONT_NORMAL}"
vagrant up

echo ''
echo "---------------------------"
echo ''



#==============================================================
# COMPLETED
#-------------------------------------------------------------
echo "Server link: http://${IP}/"
echo "${FONT_BOLD}Completed.${FONT_NORMAL} "
echo ''

