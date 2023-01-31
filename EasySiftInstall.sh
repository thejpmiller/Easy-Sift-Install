#!/usr/bin/env bash

# Improvement Options:
# Write a function/part to ensure user is downloading the latest version.

# SIFT github : https://github.com/teamdfir/sift-cli/
# Referenced : https://www.youtube.com/watch?v=yXuSPZEUcYk

# Run "sudo apt get update" and then "sudo apt get upgrade"

echo "Welcome to Sift setup for WSL"

# Test for value, echo $UBUNTUVALUE, should print 20.04

UBUNTUVALUE="20.04"
DOWNLOADLOCATION="$HOME/Downloads"

cd "$HOME/Downloads"

if grep -q "$UBUNTUVALUE" /etc/lsb-release; then
    echo "WSL is in the correct Ubuntu version."
fi

echo "Checking if SIFT prerequists are meet?"
echo "Downloading SIFT prerequisists."

# Downloading #
# sift-cli-linux
wget --show-progress "https://github.com/teamdfir/sift-cli/releases/download/v1.14.0-rc1/sift-cli-linux" -P $DOWNLOADLOCATION

# sift-cli-linux.sig
wget -v "https://github.com/teamdfir/sift-cli/releases/download/v1.14.0-rc1/sift-cli-linux.sig" -P $DOWNLOADLOCATION

#sift-cli.pub
wget -v "https://github.com/teamdfir/sift-cli/releases/download/v1.14.0-rc1/sift-cli.pub" -P $DOWNLOADLOCATION

# download go
wget "https://dl.google.com/go/go1.15.4.linux-amd64.tar.gz" -P $DOWNLOADLOCATION

# extracting go version
sudo tar -xvf $HOME/Downloads/go1.15.4.linux-amd64.tar.gz

# installing in /usr/local directory
sudo mv go "/usr/local"

# assigning a few GO Lang specific variables
export GOROOT=/usr/local/go
export GOPATH=/var/tmp
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# what version is GO
go version

wget "https://github.com/sigstore/cosign/releases/download/v1.13.1/cosign-linux-amd64" -P $DOWNLOADLOCATION

#make it executable
sudo mv cosign-linux-amd64 /usr/local/bin/cosign

# set file permission
sudo chmod +x /usr/local/bin/cosign

# install go language
go install

echo "Verifying file signatures"
cosign verify-blob --key sift-cli.pub --signature sift-cli-linux.sig sift-cli-linux

# moving sift-cli-linux files to /usr/local/bin/sift, installing it.
sudo mv sift-cli-linux /usr/local/bin/sift

# set file permissions
chmod 755 /usr/local/bin/sift

# testing if it is install...
sift --help

echo "Installing SIFT"
# execute this command, it must be this specifically for WSL installation
sudo sift install --mode=server

echo "Finished. Thank you for using EASY SIFT INSTALL for WSL."