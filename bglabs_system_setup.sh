#!/bin/bash

# Installation script for the BlueGreen Labs research environment
# 
# This script installs all required research software on your linux
# computer (after a fresh install). This install covers both end user
# software such as R, and low level libraries such as the GDAL
# geospatial libraries.
#
# This routine works for workstations based on Ubuntu 20.04 or laptops
# running the Pop OS! Ubuntu 22.04 version. The script runs as admin
# and can therefore damage your system. It is adviced not to run the
# script on an already running system. Only use it on a fresh install.
#
# Please execute this script with administative rights
# (i.e. sudo bash bglabs_system_setup.sh)
#
# Koen Hufkens (August 2022)

#-------- Warnings --------

if (TERM=vt100 whiptail --title "BGLab system setup"\
 --yesno "This installs research software on your computer. The process is unsupervised and run as superuser. As such the process might break your computer.\n\nThe setup scheme should be run on either a Ubuntu 20.04 workstation, or in case of (hybrid) laptops a more recent Pop OS! 22.04 install. It is adviced not to run the script on a currently operational system.\n\nOnly use this script on a fresh install!! \nDo you want to continue" 20 70); then
 echo " "
else
 exit 0
fi

release=`lsb_release -cs`

if [[ ${release} == "jammy" ]]; then
 if cat /etc/os-release | grep -q "pop"; then
  whiptail --title "Example Title" --msgbox "Running on Jammy Jellyfish (Ubuntu base 22.04) on Pop OS!" 8 70
 else
  whiptail --title "Example Title" --msgbox "Running on Jammy Jellyfish (Ubuntu base 22.04). No Pop OS! is detected, some parts of the script might fail." 8 70
 fi
fi

#-------- Setup and system specific parameters --------

# update location info (units, date formats)
sudo update-locale LC_ALL=en_IE.UTF-8 >/dev/null 2>&1

#-------- System utilities --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up system utilities and libraries" 8 80

# Install tools
sudo apt install synaptic -y >/dev/null 2>&1

# Install general compilation and system utilities
sudo apt install python3-pip git -y >/dev/null 2>&1
sudo apt install cmake gfortran libclang-dev -y >/dev/null 2>&1

# R devtools requirements
sudo apt install libfontconfig1-dev libharfbuzz-dev libfribidi-dev -y >/dev/null 2>&1

# authentication libraries and unit conversions
sudo apt install libsodium-dev libudunits2-dev -y >/dev/null 2>&1

# data wrangling libraries
sudo apt install protobuf-compiler libprotobuf-dev libjq-dev -y >/dev/null 2>&1

# system profiling, login management and other fun tools
sudo apt install tmux htop -y >/dev/null 2>&1

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
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu \
 $(lsb_release -cs)-cran40/" >/dev/null 2>&1

# update repo
sudo apt-get update >/dev/null 2>&1

# Install base R
sudo apt install r-base r-base-core r-recommended r-base-dev -y >/dev/null 2>&1
sudo apt install r-cran-devtools r-cran-remotes -y >/dev/null 2>&1

#-------- R & statistical software --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up RStudio" 8 80

if [[ ${release} == "focal" ]]; then
 wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2022.07.1-554-amd64.deb  >/dev/null 2>&1
else
 wget https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.1-554-amd64.deb  >/dev/null 2>&1
fi

sudo dpkg -i rstudio-2022.07.1-554-amd64.deb >/dev/null 2>&1
rm rstudio-2022.07.1-554-amd64.deb >/dev/null 2>&1

#-------- ML acceleration --------

if lspci | grep -q "NVIDIA"; then
 
 TERM=vt100 whiptail --title "BGlabs install tools" --infobox "setting up GPU acceleration" 8 80

 if [[ ${release} == "focal" ]]; then
  # TODO probably safe to install numpy and scipy from the default repo
  # install CUDA
  wget https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda-repo-ubuntu2004-11-1- local_11.1.1-455.32.00-1_amd64.deb >/dev/null 2>&1
  sudo dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb >/dev/null 2>&1
  sudo apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub >/dev/null 2>&1
  sudo apt-get update >/dev/null 2>&1
  sudo apt-get -y install cuda nvidia-cuda-toolkit >/dev/null 2>&1
 else
  # NVIDIA drivers are installed if running a hybrid platform
  # only CUDA pieces are missing these are installed together with
  # Tensorman for dockerized tensorflow runs
  sudo apt-get -y install ssystem76-cuda-latest system76-cudnn-11.2 >/dev/null 2>&1
  sudo apt-get -y install nvidia-container-runtime >/dev/null 2>&1
  sudo apt-get -y install tensorman >/dev/null 2>&1
 fi
fi

#-------- Zotero reference manager --------

TERM=vt100 whiptail --title "BGlabs install tools" --infobox "Installing the Zotero reference manager" 8 80
sleep 4

# find current main user (should be a single user on a fresh install)
user=(`users`)

# download zotero
wget "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64" -O zotero.tar.gz
tar -xvf zotero.tar.gz
mv Zotero_linux-x86_64 /opt/zotero/
rm zotero.tar.gz

chown -R ${user[0]} /opt/zotero
chgrp -R ${user[0]} /opt/zotero

# run launcher icon script
su ${user[0]} -c "bash /opt/zotero/set_launcher_icon"

# set link target
target="/home/${user[0]}/.local/share/applications/zotero.desktop"

# link to the application
su ${user[0]} "ln -s /opt/zotero/zotero.desktop $target"

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
