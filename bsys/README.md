# Host System
Install [Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview) with [Docker](https://docs.docker.com/engine/install/ubuntu/) and build the Docker-Image.

# base image
## use
Building is not necessary. The image can be pulled from DockerHub. 
```
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:base
```
## login
Get your RSA from the logs, the user is default set to bsys.
```
docker logs bsys |sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p'
```

## build
cd base
docker build --tag bsys:base .
cd -

# Under construction!
# ui image
cd ui
docker build --tag bsys:ui .
cd -
```


