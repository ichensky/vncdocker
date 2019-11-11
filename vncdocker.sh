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
	[ -z "$1" ] && { echo "Error. Use like: vncdocker configure 'gui_app_name'" exit 1; }
	##
	
	mkdir -p tmp/share tmp/share/.ssh tmp/share/.vnc
	echo "$1" > tmp/share/.xstartup
	cp ~/.ssh/id_rsa.pub tmp/share/.ssh/authorized_keys
	_random 8 | vncpasswd -f > tmp/share/.vnc/passwd

	chmod 700 tmp/share/.ssh tmp/share/.vnc
	chmod 600 tmp/share/.ssh/* tmp/share/.vnc/*
	##
	_random 16 > tmp/username
	_randomForDocker 16 > tmp/imagename
	_randomForDocker 16 > tmp/containername
}

build(){
	_init
	docker build -t $imagename .
}

run(){
	_init
	echo $PWD
	echo "xxx--->> user name: $username"
	docker run -d -v $PWD/tmp/share:/home/$username -w=/home/$username -e username=$username --name $containername $imagename
}

run_debug(){
	_init
	docker run -ti --name $containername $imagename /bin/bash
}

connect(){
	_init
	ipaddress=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containername)
	echo "xxx--->> user name: $username@$ipaddress"
	vncviewer -via $username@$ipaddress -passwd $PWD/tmp/share/.vnc/passwd localhost
}

connect_debug(){
	_init
	docker exec -ti $containername /bin/bash
}

disconnect(){
	_init
	docker stop $containername
	docker container rm $containername
}

help(){
	cat << EOF

Run gui applications with docker over VNC with SSH.

	configure       : generate needed files used by script
	build           : build docker image
	run             : run docker container
	connect         : connect to the docker container

	clean           : clean generated files

	run_debug       : run docker container as `root`
	connect_debug   : connect to the docker container as `root`
	disconnect	: stop and delete docker container

EXAMPLE
	./vncdocker configure
	./vncdocker build
	./vncdocker run
	./vncdocker connect

EOF
}

#-->
$1 $2
