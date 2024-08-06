FROM systemlabor/bsys:pocketlabui


ENV RUSTUP_HOME=/usr/local/rustup \
    RUST_VERSION=1.71.0

#---------------------------------------------------------------------
#install cross-platform tools and libraries
#---------------------------------------------------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    uml-utilities libssl-dev libelf-dev flex bison qemu-system-x86-xen \
    shellcheck unzip gnupg2\
    libncurses-dev qemu\
    libcurses-ocaml-dev\
    zlib1g\
    gcc-aarch64-linux-gnu\
    gdb-multiarch\
    libnotify4\
    qemu-user-static \
    libc6-dev-arm64-cross \
    gcc-aarch64-linux-gnu\
    cmake\
    lsb-release
#---------------------------------------------------------------------
# install rust
#---------------------------------------------------------------------
RUN set -x && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    cmake

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init";; \
        arm64) url="https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-gnu/rustup-init";; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Add the script to set DISPLAY variable
COPY set_display.sh /usr/local/bin/set_display.sh
RUN chmod +x /usr/local/bin/set_display.sh

# Modify the .bashrc file for the pocketlab user
RUN echo 'if [ -f /usr/local/bin/set_display.sh ]; then source /usr/local/bin/set_display.sh; fi' >> /home/pocketlab/.bashrc

CMD ["/entrypoint.sh"]