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
# erlang, elixir, phoenix          #
####################################
echo "starting erlange, elixir and phoenix installs..."
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get -y update
sudo apt-get -y install esl-erlang
sudo apt-get -y install elixir
mix local.hex --force
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

####################################
# postgres client (optional)       #
####################################
sudo apt-get install -y postgresql-client-common
sudo apt-get install -y postgresql-client

####################################
# recipe_box clone and start       #
####################################
echo "getting git ready and cloning the repo"
sudo apt-get -y install git
git clone https://github.com/arsdehnel/recipe-box-api.git
cd recipe-box-api

##########################################
# compilation and project initialization #
##########################################
echo -e "\E[1;34mRetrieving Elixir dependencies..."
mix deps.get --only prod
mix local.rebar --force
echo -e "\E[1;34mRunning npm install..."
npm install
echo -e "\E[1;34mMoving production config file..."
sudo mv /home/ubuntu/config.exs /var/config.exs
echo -e "\E[1;34mInstalling brunch..."
sudo npm install -g brunch
echo -e "\E[1;34mBuilding brunch..."
brunch build --production
echo -e "\E[1;34mCompiling the application..."
MIX_ENV=prod mix compile
echo -e "\E[1;34mDigesting the assets..."
MIX_ENV=prod mix phoenix.digest
echo -e "\E[1;34mMigrating the database..."
MIX_ENV=prod mix ecto.migrate

##########################################
# server start                           #
##########################################
echo -e "\E[1;34mStarting up the server..."
pwd
# MIX_ENV=prod PORT=4001 phoenix.server
cd /home/ubuntu/recipe-box-api
MIX_ENV=prod PORT=4001 elixir --detached -S mix do compile, phoenix.server