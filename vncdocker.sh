#!/bin/bash
	
source .vncdockerrc

_checkBin(){
	type $1 >/dev/null 2>&1 || { echo "`$1` not installed. Abording." exit 1;}
}

configure(){
	_checkBin docker
	_checkBin vncviewer
	[ ! -f ~/.ssh/id_rsa.pub ]  && \
		{ echo "~/.ssh/id_rsa.pub not exists. Run ssh-keygen to generate it" exit 1; }
	##

	rm -rf share/
	mkdir -p share/.ssh
	echo "$start" > share/.bashrc

	cp ~/.ssh/id_rsa.pub share/.ssh/authorized_keys
	chmod 700 share/.ssh
	chmod 600 share/.ssh/*
}

build(){
	sudo docker build -t $imagename .
}

run(){
	sudo docker run -d -v $PWD/share:/home/$username -w=/home/$username -e username=$username --name $containername $imagename
}
start(){
	sudo docker start $containername
}

connect(){
	ipaddress=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containername)
	vncviewer -via $username@$ipaddress localhost
}

exec_debug(){
	sudo docker exec -ti $containername /bin/bash
}
stop(){
	sudo docker container stop $containername
}

disconnect(){
	stop
	sudo docker container rm $containername
}

load(){
	sudo docker pull $imagename
}

help(){
	cat $(dirname $(realpath -s $0))/doc/doc.txt
}

#-->
$1
