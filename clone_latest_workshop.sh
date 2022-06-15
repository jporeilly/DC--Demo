#!/bin/bash

# -------------------------------------------------------------------------------------
# check Workshop-LDC directory exists
# remove Workshop-LDC 
# create Workshop-LDC/directory
# clone remote git LDC--Installation repository to /installers/Workshop-LDC directory
# copy files over to /etc/ansible/playbooks
# tidy up directory..
# dont forget to close and open VSC ..
# 25/03/2022
# -------------------------------------------------------------------------------------

remoteHost=github.com
remoteUser=jporeilly
localUser=installer
remoteDir=LDC--Installation
remoteRepo=http://$remoteHost/$remoteUser/$remoteDir
localDir=/installers
localDirW=/installers/Workshop-LDC
ansPlaybooks=/etc/ansible/playbooks
mod_01E=$localDirW/01--Infrastructure/01-Environment
mod_01A=$localDirW/01--Infrastructure/02-Ansible
mod_02=$localDirW/02--Pre-flight
mod_03=$localDirW/03--LDC-7.0
mod_04=$localDirW/04--Post-Installation


if [ -d "$localDirW" -a ! -h "$localDirW" ]
then
    echo "Directory $localDirW exists .." 
    echo "Deleting $localDirW .."
    sudo rm -rf $localDirW
else
    echo "Error: Directory $localDirW does not exists .."
fi
    echo "Creating $localDirW directory .."
    sudo mkdir $localDirW
    sudo git clone $remoteRepo $localDirW
    sudo chown -R $localUser $localDirW
    echo "Deleting $ansPlaybooks .."
    sudo rm -rfv $ansPlaybooks/*
    echo "Copying over Module 01 - Infrastructure .."
    sudo cp -rfp $mod_01E/*  $ansPlaybooks
    sudo cp -rfp $mod_01A/*  $ansPlaybooks
    echo "Copying over Module 02 - Pre-flight .."
    sudo cp -rfp $mod_02/*  $ansPlaybooks
    echo "Copying over Module 03 - LDC-7.0 .."
    sudo cp -rfp $mod_03/*  $ansPlaybooks
    echo "Copying over Module 04 - Post Installation .."
    sudo cp -rfp $mod_04/*  $ansPlaybooks
    echo "Tidying up directory .."
    sudo rm -rfv $ansPlaybooks/*.md
    sudo rm -rfv $ansPlaybooks/resources
    sudo rm -rfv $ansPlaybooks/assets
    sudo rm -rfv $ansPlaybooks/licenses
    echo "Latest LDC Workshop copied over .. close and open VSC .."