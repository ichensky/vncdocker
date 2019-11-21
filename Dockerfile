from debian

run apt-get update \ 
    && apt-get install -y x11vnc xvfb openssh-server x11-xserver-utils

run mkdir /var/run/sshd 
