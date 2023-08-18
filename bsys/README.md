# Host System
Install [Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview) with [Docker](https://docs.docker.com/engine/install/ubuntu/) and build the Docker-Image.

# base image
## use
### AMD64 Architecture
Building is not necessary. The image can be pulled from DockerHub. 
```
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:base
```

### ARM64 Arhcitecture

TODO

## login (shown with AMD64 Architecture)
Get your RSA from the logs, the user is default set to bsys.
```
docker logs bsys |sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p'
```
Copy this key into a new file, e.g. **.ssh/id_rsa_bsyslab.key** :
```
docker logs bsys |sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > .ssh/id_rsa_bsyslab.key
```
The **.ssh/id_rsa_bsyslab.key** file should be only readable by you (the owner).

Login to running docker image:
```
ssh -p40404 -i path/to/rsa bsys@localhost
```
with above **.ssh/id_rsa_bsyslab.key** file e.g.:
```
ssh -p40404 -i  .ssh/id_rsa_bsyslab.key bsys@localhost
```

## .ssh/config 

TODO

## Build base image
### amd64 Architecture
```
cd base
docker build --tag bsys:base .
cd -
```

### arm64 Architecture
```
cd base
docker build --tag bsys-arm:base .
cd -
```
# ui image

## use
TODO

## build ui image
### amd64 Architecture
```
cd ui
docker build --tag bsys:ui .
cd -
```

### arm64 Architecture
```
cd ui
docker build --tag bsys-arm:ui-arm .
cd -
```

