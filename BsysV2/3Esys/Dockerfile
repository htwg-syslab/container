FROM systemlabor/bsys:pocketlabbase

ARG INSTALL_RUST=false
ARG KEEP_OSTEP=false
ENV RUSTUP_HOME=/usr/local/rustup \
    RUST_VERSION=stable \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN if [ "$KEEP_OSTEP" != "true" ]; then rm -rf /home/pocketlab/ostep-homework; fi

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
    libnotify4 \
    bc \
    expect \
    cpio \
    curl

# Install act (run GitHub Actions locally)
# Uses the GitHub releases redirect (always latest) to download a pre-built
# binary instead of piping a remote script to bash, reducing supply-chain risk.
RUN ARCH="$(dpkg --print-architecture)" && \
    case "$ARCH" in \
        amd64) ACT_ARCH="x86_64" ;; \
        arm64) ACT_ARCH="arm64" ;; \
        *) echo "unsupported architecture: $ARCH"; exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/nektos/act/releases/latest/download/act_Linux_${ACT_ARCH}.tar.gz" | tar xz -C /usr/local/bin act

RUN dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        arm64) \
            packages="qemu-system-x86" \
            ;; \
        amd64) \
            packages="gcc-aarch64-linux-gnu \
                      gdb-multiarch \
                      qemu-system-x86 \
                      qemu-system-arm \
                      qemu-user-static \
                      libc6-dev-arm64-cross" \
            ;; \
        *) \
            echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 \
            ;; \
    esac; \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $packages


#---------------------------------------------------------------------
# install rust (optional: docker build --build-arg INSTALL_RUST=true)
#---------------------------------------------------------------------
RUN if [ "$INSTALL_RUST" = "true" ]; then \
    set -eux; \
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
    chown -R pocketlab:pocketlab $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    echo 'if [ -d "/usr/local/cargo/bin" ]; then export PATH="/usr/local/cargo/bin:$PATH"; fi' >> /home/pocketlab/.bashrc; \
    fi

# Add the script to set DISPLAY variable
COPY set_display.sh /usr/local/bin/set_display.sh
RUN dos2unix /usr/local/bin/set_display.sh ; chmod +x /usr/local/bin/set_display.sh

# Make entrypoint.sh executable on every Platfrom
RUN dos2unix entrypoint.sh ; chmod +x entrypoint.sh

# Modify the .bashrc file for the pocketlab user
RUN echo 'if [ -f /usr/local/bin/set_display.sh ]; then source /usr/local/bin/set_display.sh; fi' >> /home/pocketlab/.bashrc;

CMD ["/entrypoint.sh"]