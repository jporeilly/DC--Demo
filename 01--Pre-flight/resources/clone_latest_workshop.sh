#!/bin/bash

# =============================================================
# check Workshop-LDC directory exists
# remove Workshop-LDC 
# create Workshop-LDC directory
# clone remote git DC--Demo repository to Workshop-DC directory
# copy files over to Scripts
# 
# dont forget to close and open VSC ..
# 21/06/2022
# =============================================================

remoteHost=github.com
remoteUser=jporeilly
localUser=dc
remoteDir=DC--Demo
remoteRepo=http://$remoteHost/$remoteUser/$remoteDir
localDirW=~/Workshop-DC
localDirS=~/Scripts

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
    echo "Deleting Scripts .."
    sudo rm -rfv $localDirS/*.sh
    sudo rm -rfv $localDirS/*.yml
    echo "Copying over required scripts .."
    sudo cp -rfp $localDirW/01--Pre-flight/*.sh  $localDirS
    sudo cp -rfp $localDirW/01--Pre-flight/*.yml  $localDirS
    sudo cp -rfp $localDirW/02--Data-Catalog/*.yml  $localDirS
    sudo chown -R $localUser $localDirS
    echo "Latest Data-Catalog Workshop copied over .. close and open VSC .."