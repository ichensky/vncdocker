# vncdocker

Run gui applications like `firefox` as normal user with `docker` over `VNC with SSH`.

As display server used `xvfb`.

As vnc server used `x11vnc`.

VNC connection secured by ssh.

Sharing X display server with gui application over VNC with SSH should be more secure then sharing X display server from host OS with docker.

![Documentation](doc/doc.txt)

## How to use.
For ex. for launching firefox.
* Downlod vncdocker.sh script 
```
$ git clone https://github.com/ichensky/vncdocker
```
* Add `vncdocker.sh` to the PATH (not required)
* Go to the `vncdocker/examples` directory
or copy from it `Dockerfile` somewhere else and 
run instruction to build, run and connect to the docker container. 
```
$ cd vncdocker/examples
$ vncdocker.sh configure firefox
$ vncdocker.sh buid
$ vncdocker.sh run
$ vncdocker.sh connect
```
 
![example](doc/img.png)
