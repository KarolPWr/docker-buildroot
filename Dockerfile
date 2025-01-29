FROM ubuntu:22.04

# Set build arguments with defaults
ARG USR=developer
ARG UID=1000
ARG GID=1000

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Warsaw \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Update and install necessary packages
RUN apt update && apt install -y --no-install-recommends \
    sudo gawk wget git-core diffstat unzip gcc-multilib build-essential chrpath socat cpio \
    libsqlite3-dev sqlite3 python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint xterm bmap-tools git cmake autoconf \
    texinfo openjdk-8-jdk openjdk-8-jre m4 libtool libtool-bin curl pkg-config lib32z1 doxygen vim \
    openssh-client openssh-server locales gobject-introspection python3-gi gir1.2-gtk-3.0 xvfb tmux \
    libncurses5-dev libncursesw5-dev quilt automake qemu qemu-kvm libvirt-clients libvirt-daemon-system \
    virtinst bridge-utils ebtables cscope libgpgme-dev libgpgme11 gdb strace libssl-dev rsync flex bc \
    dos2unix locate bison ccache ecj fastjar file g++ gettext java-propose-classpath libelf-dev \
    python3-distutils python3-setuptools python3-dev time xsltproc zlib1g-dev device-tree-compiler zstd libgnutls28-dev help2man && \
    rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen "en_US.UTF-8"

# Create user and configure shell
RUN groupadd -g $GID $USR && \
    useradd -rm -d /home/${USR} -s /bin/bash -g $GID -G sudo -u $UID $USR && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    curl -o /bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo && \
    chmod a+x /bin/repo && \
    ln -sf /bin/bash /bin/sh

# Switch to the newly created user
USER $USR
WORKDIR /home/$USR
