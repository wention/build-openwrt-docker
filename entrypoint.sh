#!/bin/bash
set -xe

# check user
FUID=$(stat --format %u /lede/Makefile)
FGID=$(stat --format %g /lede/Makefile)

if [ "$UID:$GID" != "$FUID:$FGID" ];then
    if getent passwd builder >/dev/null 2>&1; then
        userdel -f builder
    fi
    if getent group builder > /dev/null 2>&1; then
        groupdel -f builder
    fi
    groupadd --gid $FGID builder
    useradd -M --gid $FGID --uid $FUID -s /bin/bash builder
fi

#echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

su --pty builder -c "exec $@"