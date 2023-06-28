FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -E -i 's/(archive|security).ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list
RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  apt-get install -y ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison \
  build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext \
  gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev \
  libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev \
  libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip libpython3-dev \
  qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev

COPY entrypoint.sh /
COPY build /build

ARG UID=1000
ARG GID=1000

WORKDIR /lede

ENTRYPOINT ["/entrypoint.sh"]
CMD /build/build.sh