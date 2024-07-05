FROM ubuntu:24.04

ARG my_user="bsys"
ARG my_password="bsys"


# args
ENV PATH=/usr/local/cargo/bin:$PATH \
    TZ=Europe/Berlin


# install software
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	apt-transport-https ca-certificates \
	openssh-server \
	locales \
	software-properties-common
	apt-transport-https \
	wget \
	python3-pip \
	hunspell-de-de \
	vim \
	nano \
 	manpages \
	manpages-dev \
	htop \
	curl \
	tmux \
	zsh \
	netcat \
	tree \
	git \
	indent \
	gist \
	bats \
	shellcheck \
	gcc \
	clang \
	cmake \
	lldb \
	xsel \
	gdb \
	gpg-agent \
	ddd \
	valgrind \
	meld \
	strace \
	python3-matplotlib \
	python-tk \
	gpg dirmngr gnupg \
	build-essential \
	sudo \
	supervisor \
	libcurses-ocaml-dev \
	zlib1g-dev \
	libc6-dev-arm64-cross \
	gcc-aarch64-linux-gnu \
	gdb-multiarch \
	gnupg lsb-release \
	libnotify4 \
	tzdata


# user
RUN useradd --create-home --shell /bin/bash "$my_user"
RUN echo "$my_user:$my_password" | chpasswd
RUN usermod -aG systemd-journal "$my_user"
RUN usermod -aG sudo "$my_user"
RUN chown -R "$my_user":"$my_user" "/home/$my_user"

## ssh
## genkey @entrypoint
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir /run/sshd

# set timezone to Europe/Berlin
RUN apt-get upgrade

# env
RUN echo "PATH=$PATH" > /etc/environment
RUN echo "TZ=$TZ" >> /etc/environment

# set locale / env
RUN locale-gen de_DE de_DE.UTF-8
RUN update-locale LC_ALL=de_DE.UTF-8 LANG=de_DE.UTF-8
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"
ENV LC_MESSAGES="en_US.UTF-8"

ENV LC_MONETARY="de_DE.UTF-8"
ENV LC_NUMERIC="de_DE.UTF-8"
ENV LC_TIME="de_DE.UTF-8"
ENV LC_COLLATE="de_DE.UTF-8"
ENV LC_MONETARY="de_DE.UTF-8"
ENV LC_PAPER="de_DE.UTF-8"
ENV LC_NAME="de_DE.UTF-8"
ENV LC_ADDRESS="de_DE.UTF-8"
ENV LC_TELEPHONE="de_DE.UTF-8"
ENV LC_MEASUREMENT="de_DE.UTF-8"
ENV LC_IDENTIFICATION="de_DE.UTF-8"




# ssh:22
EXPOSE 22


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
