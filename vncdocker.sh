#!/bin/bash

_random(){
	< /dev/urandom tr -dc A-Za-z0-9 | head -c$1
}
_randomForDocker(){
	< /dev/urandom tr -dc a-z0-9 | head -c$1
}
_checkBin(){
	type $1 >/dev/null 2>&1 || { echo "`$1` not installed. Abording." exit 1;}
}


# HERE you can predefine global variables 
_init(){
	username=$(cat tmp/username)
	containername=$(cat tmp/containername)
	imagename=$(cat tmp/imagename)
}

clean(){
	rm -rf tmp
}

configure(){
	clean
	##
	_checkBin docker
	_checkBin vncpasswd
	_checkBin vncviewer
	[ ! -f ~/.ssh/authorized_keys ]  && \
		{ echo "~/.ssh/authorized_keys not exists. Run ssh-keygen to generate it" exit 1; }
	##
	mkdir -p tmp/share
	mkdir -p tmp/share/.ssh
	cp ~/.ssh/id_rsa.pub tmp/share/.ssh/authorized_keys
	mkdir -p tmp/share/.vnc
	_random 8 | vncpasswd -f > tmp/share/.vnc/passwd
	##
	_random 16 > tmp/username
	_randomForDocker 16 > tmp/imagename
	_randomForDocker 16 > tmp/containername
}

build(){
	_init
	docker build --build-arg username=$username -t $imagename .
}

run(){
	_init
	docker run -d -e username=$username --name $containername $imagename
}

run_debug(){
	_init
	docker run -ti --name $containername $imagename /bin/bash
}

connect(){
	_init
	ipaddress=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containername)
	vncviewer -via $username@$ipaddress -passwd tmp/share/.vnc/passwd localhost
}

disconect(){
	_init
	docker stop $containername
	docker container rm $containername
}

help(){
	cat << EOF

Run gui applications with docker over VNC with SSH.

	configure       : generate needed files used by script
	build           : build docker image
	run             : run docker image
	connect         : connect to the docker image

	clean           : clean generated files

	run_debug       : run docker container as `root`
	disconect	: stop and delete docker container

EXAMPLE
	./vncdocker configure
	./vncdocker build
	./vncdocker run
	./vncdocker connect

EOF
}

#-->
$1
