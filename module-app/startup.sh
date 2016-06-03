#!/bin/bash
# this is some basic stuff to prove the instance is up and running
sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start       