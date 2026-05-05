FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG TOOLCHAIN_NAME=mipsel-linux-uclibc.tar.xz
ARG TOOLCHAIN_URL=https://github.com/hanwckf/padavan-toolchain/releases/download/v1.1/${TOOLCHAIN_NAME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        automake \
        autopoint \
        bash \
        bison \
        build-essential \
        ca-certificates \
        cmake \
        cpio \
        curl \
        fakeroot \
        flex \
        gawk \
        gettext \
        git \
        gperf \
        help2man \
        kmod \
        libgmp-dev \
        libltdl-dev \
        libmpc-dev \
        libmpfr-dev \
        libncurses-dev \
        libtool \
        libtool-bin \
        locales \
        p7zip-full \
        pkg-config \
        python3-docutils \
        shellcheck \
        sudo \
        texinfo \
        unzip \
        wget \
        xxd \
        xz-utils \
        zlib1g-dev && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/rt-n56u/toolchain-mipsel/toolchain-3.4.x && \
    curl -fL --retry 3 --retry-delay 5 "${TOOLCHAIN_URL}" -o /tmp/toolchain.tar.xz && \
    tar -xJf /tmp/toolchain.tar.xz -C /opt/rt-n56u/toolchain-mipsel/toolchain-3.4.x && \
    rm -f /tmp/toolchain.tar.xz

WORKDIR /workdir
