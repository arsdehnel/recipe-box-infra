#!/bin/bash
sudo apt-get -y update

####################################
# node                             #
####################################
echo "starting nodejs and npm installs..."
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get -y install nodejs
sudo apt-get -y install npm

####################################
# recipe_box clone and start       #
####################################
echo "starting recipe-box clone and npm install..."
sudo apt-get -y install git
git clone https://github.com/arsdehnel/recipe-box.git
cd recipe-box
# npm install