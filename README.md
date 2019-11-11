# vncdocker

This script will help you securily run GUI application 
as normal user inside of docker container.

As display server used `xvfb`.
As vnc server used `x11vnc`.
VNC connection secured by ssh.


This script use VNC with SSH for the connection to the gui application
inside of docker, which should be anyway more secure then 
sharing X display server with docker.

Run gui applications with docker over VNC with SSH.

	configure       : generate needed files used by script
	build           : build docker image
	run             : run docker image
	connect         : connect to the docker image

	clean           : clean generated files

	run_debug       : run docker container as 
	disconect       : stop and delete docker container

EXAMPLE
	./vncdocker configure
	./vncdocker build
	./vncdocker run
	./vncdocker connect

