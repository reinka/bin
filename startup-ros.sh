#!/bin/bash

cat <<EOF >> /etc/profile
    umask 002
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
EOF

cat <<EOF >> /etc/vim/vimrc.local
    " Set syntax and search highlighting
    syntax on
    set hlsearch
    " Set the filetype based on the file's extension, but only if
    " 'filetype' has not already been set
    au BufRead,BufNewFile *.launch setfiletype xml
    " Have Vim load indentation rules and plugins
    " according to the detected filetype.
    if has("autocmd")
      filetype plugin indent on
    endif
EOF

# install ros for debian stretch (9.0)
# http://wiki.ros.org/lunar/Installation/Debian
cat <<EOF >> /etc/apt/sources.list
    # allow contrib and non-free repositories
    deb http://deb.debian.org/debian stretch contrib non-free
    deb-src http://deb.debian.org/debian stretch contrib non-free

    deb http://deb.debian.org/debian-security/ stretch/updates contrib non-free
    deb-src http://deb.debian.org/debian-security/ stretch/updates contrib non-free

    deb http://deb.debian.org/debian stretch-updates contrib non-free
    deb-src http://deb.debian.org/debian stretch-updates contrib non-free
EOF


sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
apt-get install dirmngr --install-recommends
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5523BAEEB01FA116
apt-get update
apt-get --assume-yes install ros-lunar-desktop-full
rosdep init
rosdep update

echo "source /opt/ros/lunar/setup.bash" >> /etc/bash.bashrc
apt-get --assume-yes install python-rosinstall python-rosinstall-generator python-wstool build-essential

# Install catkin_tools for e.g. catkin build
# https://catkin-tools.readthedocs.io/en/latest/installing.html#installing-from-source
cd /opt/ros/lunar/etc
git clone https://github.com/catkin/catkin_tools.git
cd catkin_tools
pip install -r requirements.txt --upgrade
python setup.py install --record install_manifest.txt
echo "source /etc/bash_completion.d/catkin_tools-completion.bash" >> /etc/bash.bashrc

# A few more tools (optional)
pip install seaborn
apt-get install htop

# https://stackoverflow.com/questions/27384725/ssh-x-warning-untrusted-x11-forwarding-setup-failed-xauth-key-data-not-gener
# https://stackoverflow.com/questions/38961495/x11-forwarding-request-failed-on-channel-0
apt-get install xauth

# change group of the default dl workspace and set access rights
chgrp -R adm /opt/deeplearning/workspace
chmod -R g+sw /opt/deeplearning/workspace
