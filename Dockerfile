from debian

#env username=john
#env home=/home/$username

run apt-get update \ 
    && apt-get install -y x11vnc xvfb openssh-server

run mkdir /var/run/sshd 

#workdir $home

cmd bash -c '{ id -u $username &>/dev/null || useradd -m -d /home/$username $username; } && su $username -c "x11vnc -forever -usepw -create -localhost" & /usr/sbin/sshd -D'
