from debian

run apt-get update \ 
    && apt-get install -y x11vnc xvfb openssh-server x11-xserver-utils

run mkdir /var/run/sshd 

cmd bash -c '{ id -u $username &>/dev/null || useradd -m -d /home/$username -s /bin/bash $username; } && su $username -c "x11vnc -forever -usepw -create -localhost" & /usr/sbin/sshd -D'
