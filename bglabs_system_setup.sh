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

if (TERM=vt100 whiptail --title "BGLab system setup"\
 --yesno "This installs research software on your computer. Do you want to continue" 8 70); then
  echo "All done"
else
  exit 0
fi

# update location info (units, date formats)
sudo update-locale LC_ALL=en_IE.UTF-8 >/dev/null 2>&1

#-------- System utilities --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up system utilities and libraries" 8 80

# Install general compilation and system utilities
sudo apt install python3-pip git -y >/dev/null 2>&1
sudo apt install cmake gfortran libclang-dev -y >/dev/null 2>&1

# R devtools requirements
sudo apt install libfontconfig1-dev ibharfbuzz-dev libfribidi-dev libsodium-dev -y >/dev/null 2>&1

# authentication libraries and unit conversions
sudo apt install libsodium-dev libudunits2-dev -y >/dev/null 2>&1

# mommentuHMM dependencies
sudo apt install protobuf-compiler libprotobuf-dev libjq-dev -y >/dev/null 2>&1

#-------- Internet utilities --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up internet utilities" 8 80

# Install general tools for internet sleughting
sudo apt install wget curl -y >/dev/null 2>&1

# VPN software
sudo apt install -y network-manager-openconnect network-manager-openconnect-gnome >/dev/null 2>&1

#-------- GDAL and geospatial software --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up GDAL" 8 80

# Install GDAL and GDAL development libraries
# the latest versions can be fetched from the ppa
# this will not be required if running Ubuntu 22.04
# as this includes a recent version of GDAL etc.
# Test for the release date
if [[ ${release} == "focal" ]]; then
  sudo add-apt-repository ppa:ubuntugis/ppa -y >/dev/null 2>&1
fi

sudo apt-get update >/dev/null 2>&1
sudo apt-get install gdal-bin libgdal-dev qgis -y >/dev/null 2>&1

# install spatial packages + GIS
#sudo add-apt-repository 'deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu focal main '
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160
#sudo apt update
#sudo apt install -y libgdal-dev libproj-dev libgeos-dev libudunits2-dev libnode-dev libcairo2-dev libnetcdf-dev qgis

#-------- R & statistical software --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up R" 8 80

# Install the most recent version of R
# from https://cloud.r-project.org/bin/linux/ubuntu/

# install R + RStudio
#sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#sudo apt update
#sudo apt install -y r-base r-base-core r-recommended r-base-dev

# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common\
 dirmngr -y >/dev/null 2>&1

# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc |
 sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc >/dev/null 2>&1

# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy'
# or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu \
 $(lsb_release -cs)-cran40/" >/dev/null 2>&1

# update repo
sudo apt-get update >/dev/null 2>&1

# Install base R
sudo apt install r-base r-base-core r-recommended r-base-dev -y >/dev/null 2>&1

#-------- R & statistical software --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up RStudio" 8 80

#if [[ ${release} == "focal" ]]; then
# wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2022.07.1-554-amd64.deb  >/dev/null 2>&1
#else
# wget https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.1-554-amd64.deb  >/dev/null 2>&1
#fi

#sudo dpkg -i rstudio-2022.07.1-554-amd64.deb >/dev/null 2>&1
#rm rstudio-2022.07.1-554-amd64.deb >/dev/null 2>&1

#-------- Python ML etc --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up python & machine learning tooling" 8 80

# TODO probably safe to install numpy and scipy from the default repo
# install CUDA
wget https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda



# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212772
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
# sudo dpkg -i cuda-keyring_1.0-1_all.deb

sudo apt install nvidia-cuda-toolkit

# pytorch
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

#-------- Zotero reference manager --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up the Zotero reference manager" 8 80
sleep 4

#-------- Cleanup --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "cleaning up" 8 80
sudo apt autoremove -y >/dev/null 2>&1

#-------- Reboot --------

if (TERM=vt100 whiptail --title "BGLab system setup" \
 --yesno "Do you want to reboot the system? (required for some installations to complete)" 8 70); then
  sudo reboot  
else
  exit 0
fi
