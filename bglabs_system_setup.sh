#!/bin/bash

# Installation script for the BlueGreen Labs research environment
# 
# This script installs all required research software on your linux
# computer (after a fresh install). This install covers both end user
# software such as R, and low level libraries such as the GDAL
# geospatial libraries.
#
# This setup script should be compatible with all Ubuntu flavoured
# linux distributions (e.g. Ubuntu >=20.04, XUbuntu, KUbuntu, Mint etc.)
#
# Please execute this script with administative rights
# (i.e. sudo bash bglabs_system_setup.sh)
#
# Koen Hufkens (August 2022)

# determine Ubuntu release

#-------- Setup and system specific parameters --------

release=`lsb_release -cs`

if (TERM=vt100 whiptail --title "BGLab system setup" \
 --yesno "This installs research software on your computer.\
  Do you want to continue" 8 70); then
  echo "All done"
else
  exit 0
fi


if (TERM=vt100 whiptail --title "BGLab system setup" \
 --yesno "What system are you running"\
 --yes-button "Laptop"\
 --no-button "Workstation" 8 70); then
  system="laptop"
else
  system="workstation"
fi

whiptail --msgbox --title "Intro to Whiptail" "$system" 25 80

exit 0

#-------- Internet utilities --------

TERM=vt100 whiptail --title "BGlabs install tools"\
 --infobox "setting up internet utilities" 8 80

# Install general tools for internet sleughting
sudo apt install wget curl -y

#-------- GDAL and geospatial software --------

TERM=vt100 whiptail --title "BGlabs install tools"\
 --infobox "setting up GDAL" 8 80

# Install GDAL and GDAL development libraries
# the latest versions can be fetched from the ppa
# this will not be required if running Ubuntu 22.04
# as this includes a recent version of GDAL etc.
# Test for the release date
if ( ${release} == "focal"); then
  sudo add-apt-repository ppa:ubuntugis/ppa -y
fi

sudo apt-get update
sudo apt-get install gdal-bin libgdal-dev qgis -y

#-------- R & statistical software --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up R" 8 80

# Install the most recent version of R
# from https://cloud.r-project.org/bin/linux/ubuntu/

# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr -y

# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc |
 sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy'
# or 'bionic' as needed
sudo add-apt-repository\
 "deb https://cloud.r-project.org/bin/linux/ubuntu ${release}-cran40/"

# Install base R
sudo apt install --no-install-recommends r-base -y

#-------- Python etc --------

TERM=vt100 whiptail --title "BGlabs install tools"\
 --infobox "setting up R" 8 80


#-------- Zotero reference manager --------

TERM=vt100 whiptail --title "BGlabs install tools"\
 --infobox "setting up R" 8 80


exit 1
