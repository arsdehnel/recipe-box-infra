#!/bin/bash

args=("$@")

# remove previous versions of this file just in case there was one
rm $1

echo "set -ex" >> $1

# install dependencies
echo "echo \"Installing dependencies...\"" >> $1
echo "sudo yum install -y python-pip ruby2.0 awscli" >> $1

# install consul
echo "echo \"Fetching codedeploy-agent...\"" >> $1
echo "AWS_ACCESS_KEY_ID=$3 AWS_SECRET_ACCESS_KEY=$4 aws s3 cp s3://aws-codedeploy-$2/latest/install . --region $2" >> $1

echo "echo \"Installing codedeploy-agent...\"" >> $1
echo "chmod +x ./install" >> $1
echo "sudo ./install auto" >> $1