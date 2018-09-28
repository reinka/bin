#!/bin/bash

# set umask for all users such that created directories under a specific user
# can be written by users of the same group (group will be set in the end).
# This will be needed when different machines are going to ssh into the VM
echo "umask 002" >> /etc/profile
umask 002

# get cmake which is needed for gym's atari extension
sudo apt-get --assume-yes install cmake

# create a new directory within the default deeplearning workspace that comes
# with the preconfigured VM
cd /opt/deeplearning/workspace
mkdir berkeleydeeprl
cd berkeleydeeprl

# git clone my berkeleydeeprl fork and openai's gym
git clone https://github.com/reinka/homework.git
git clone https://github.com/openai/gym.git

# replace lunar_lander.py as required in hw2 (for more info see the hw
# instructions)
cp homework/hw2/lunar_lander.py gym/gym/envs/box2d/

# install gym with atari extension; install seaborn for plotting
pip3 install -e gym[atari]
pip3 install seaborn

# install box2d for the lunar lander homework part
sudo apt-get install swig3.0 && sudo ln -s /usr/bin/swig3.0 /usr/bin/swig
pip3 install Box2D==2.3.2
pip3 install box2d box2d-kengz

#  interactive system-monitor process-viewer and process-manager
sudo apt-get install htop

# change folder group to `adm`
sudo chgrp -R adm /opt/deeplearning/workspace
# change access rights of the group so any ssh user can read / write
sudo chmod -R g+sw /opt/deeplearning/workspace
