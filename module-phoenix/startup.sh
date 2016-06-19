#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install git

####################################
# node                             #
####################################
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get -y install nodejs
sudo apt-get -y install npm

####################################
# erlang, elixir, phoenix          #
####################################
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get -y install esl-erlang
sudo apt-get -y install elixir
mix local.hex --force
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

####################################
# erlang, elixir, phoenix          #
####################################
git clone https://github.com/arsdehnel/recipe-box-api.git
cd recipe-box-api
mix deps.get --only prod
npm install
# MIX_ENV=prod mix compile
mix compile
mix phoenix.server