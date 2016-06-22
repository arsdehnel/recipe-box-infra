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
echo "starting nodejs and npm installs..."
sudo apt-get -y install git
git clone https://github.com/arsdehnel/recipe-box-api.git
cd recipe-box-api
mix deps.get --only prod
mix local.rebar --force
npm install
sudo mv /home/ubuntu/prod.secret.exs /var/config.exs
sudo npm install -g brunch
brunch build --production
MIX_ENV=prod mix compile
MIX_ENV=prod mix phoenix.digest


MIX_ENV=prod mix ecto.migrate
# MIX_ENV=prod PORT=4001 mix phoenix.server
# MIX_ENV=prod PORT=4001 elixir --detached -S mix do compile, phoenix.server