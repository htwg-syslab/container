# Host System
Install [Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview) with [Docker](https://docs.docker.com/engine/install/ubuntu/) and build the Docker-Image.

### Intel/amd64 Architecture
Local building is not necessary. The image can be pulled from DockerHub.

UI:

```bash
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:pocketlabui
```

Base:

```bash
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:pocketlabbase
```

### Apple arm64 Architecture

UI:

```bash
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:pocketlabui-ARM64
```

Or Base:

```bash
docker run -d -p 127.0.0.1:40404:22 --name=bsys systemlabor/bsys:pocketlabbase-ARM64
```

## login (shown with Intel/amd64 Architecture)

Get your RSA from the logs, the user is default set to pocketlab.
Copy this key into a new file, e.g. **.ssh/id_rsa_pocketlab.key** :

```text
docker logs bsys |sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > .ssh/id_rsa_pocketlab.key
```

The **.ssh/id_rsa_pocketlab.key** file should be only readable by you (the owner).

Login to running docker image:

```text
ssh -p40404 -i path/to/rsa pocketlab@localhost
```

with above **.ssh/id_rsa_pocketlab.key** file e.g.:

```text
ssh -p40404 -i  .ssh/id_rsa_pocketlab.key bsys@localhost
```

## .ssh/config

```text
Host pocketbsys
    HostName localhost
    User bsys
    Port 40405
    IdentityFile ~/.ssh/id_rsa_pocketlab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```


## Install X Server

### Windows

install Xming, basic configuration with installation wizard

### MacOS

Install Xquartz, with basic configuration, X11 forward to be configured!

### Linux

nativly installed

## access

via Browser to http://localhost:40001

```text
username: pocketlab
password: pocketlab
```

in case of problems try:

```text
username: syslab
password: syslab
```
