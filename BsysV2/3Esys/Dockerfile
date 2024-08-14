FROM tanguylemo/pocketlabtest:ui


ENV RUSTUP_HOME=/usr/local/rustup \
    RUST_VERSION=1.71.0 \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

#---------------------------------------------------------------------
#install cross-platform tools and libraries
#---------------------------------------------------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    uml-utilities\
    libssl-dev \
    libelf-dev \
    flex \
    bison \
    shellcheck \
    unzip \
    gnupg2 \
    libncurses-dev \
    libcurses-ocaml-dev \
    zlib1g \
    lsb-release \
    dos2unix \
    cmake \
    libnotify4

    RUN dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        arm64) \
            packages="qemu-system-arm" \
            ;; \
        amd64) \
            packages="gcc-aarch64-linux-gnu \
                      gdb-multiarch \
                      qemu \
                      qemu-system-x86 \
                      qemu-user-static \
                      libc6-dev-arm64-cross \
                      gcc-aarch64-linux-gnu" \
            ;; \
        *) \
            echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 \
            ;; \
    esac; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y $packages


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
    rustup default stable; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Add the script to set DISPLAY variable
COPY set_display.sh /usr/local/bin/set_display.sh
RUN dos2unix /usr/local/bin/set_display.sh ; chmod +x /usr/local/bin/set_display.sh

# Make entrypoint.sh executable on every Platfrom
RUN dos2unix entrypoint.sh ; chmod +x entrypoint.sh

# Modify the .bashrc file for the pocketlab user
RUN echo 'if [ -f /usr/local/bin/set_display.sh ]; then source /usr/local/bin/set_display.sh; fi' >> /home/pocketlab/.bashrc;\
    echo 'if [ -d "/usr/local/cargo/bin" ]; then export PATH="/usr/local/cargo/bin:$PATH"; fi' >> /home/pocketlab/.bashrc ; \
    echo 'rustup default stable' >> /home/pocketlab/.bashrc ;

CMD ["/entrypoint.sh"]