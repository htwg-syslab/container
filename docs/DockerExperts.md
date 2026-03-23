# Host System

Install [Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview) with [Docker](https://docs.docker.com/engine/install/ubuntu/) and build the Docker-Image.

### Container starten

Local building is not necessary. The image can be pulled from ghcr.io (Multi-Arch, works on amd64 and arm64):

BSYS:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=bsyslab ghcr.io/htwg-syslab/container/bsyslab:latest
```

ESYS:

```bash
docker run -d -p 127.0.0.1:40407:22 -v esyslab-home:/home/pocketlab --name=esyslab ghcr.io/htwg-syslab/container/esyslab:latest
```

## login

Get your RSA from the logs, the user is default set to pocketlab.
Copy this key into a new file, e.g. **.ssh/id_rsa_bsyslab.key** :

```text
docker logs bsyslab |sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > .ssh/id_rsa_bsyslab.key
```

The **.ssh/id_rsa_bsyslab.key** file should be only readable by you (the owner).

Login to running docker image:

```text
ssh -p40405 -i .ssh/id_rsa_bsyslab.key pocketlab@localhost
```

## .ssh/config

```text
Host bsyslab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_bsyslab.key
    ForwardX11 yes
    ForwardX11Trusted yes

Host esyslab
    HostName localhost
    User pocketlab
    Port 40407
    IdentityFile ~/.ssh/id_rsa_esyslab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```

## Install X Server

### Windows

install Xming, basic configuration with installation wizard

### MacOS

Install Xquartz, with basic configuration, X11 forward to be configured!

### Linux

natively installed

## access

via Browser to http://localhost:40001

```text
username: pocketlab
password: pocketlab
```
