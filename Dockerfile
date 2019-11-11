from debian

arg username=bob
env home=/home/$username

run echo username=$username
run echo home=$home
run apt-get update

# installing gui app
run apt-get install -y x11vnc xvfb openssh-server \
	vim mc \
	firefox-esr
#

run mkdir /var/run/sshd 

run useradd -m -d $home -s /bin/bash $username
workdir $home
copy tmp/share $home/
run ls -a $home/
run chmod 700 .ssh .vnc
run chmod 600 .ssh/* .vnc/*

# starting gui app as normal user:
run echo firefox >> .bashrc
#
run chown $username:$username . -R 

cmd bash -c 'su $username -c "x11vnc -forever -usepw -create -localhost" & /usr/sbin/sshd -D'
