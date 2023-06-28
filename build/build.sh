#!/bin/bash
set -xe

if [ "$EUID" -eq 0 ];then
  echo "do not run as root"
  exit 1
fi

cd /lede

export http_proxy=http://10.1.1.178:7890
export https_proxy=http://10.1.1.178:7890
export all_proxy=socks5://10.1.1.178:7890

time_start=$(date +"%s")

cp -f feeds.conf.default feeds.conf
sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf
echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> ./feeds.conf

./scripts/feeds update -a
./scripts/feeds install -a

if [ ! -e .config ];then
  make defconfig
fi

make download -j16

# ionice -c 3 chrt --idle 0 nice -n19 make -j$(nproc)
make -j$(nproc) || make -j1 V=s

echo "======================="
echo "Space usage:"
echo "======================="
df -h
echo "======================="
du -h --max-depth=1 ./ --exclude=build_dir --exclude=bin
du -h --max-depth=1 ./build_dir
du -h --max-depth=1 ./bin

time_end=$(date +"%s")

duration=$(date -u -d "@$(($time_end - $time_start))" +"%H hours, %M min, %S seconds")

echo "time: $duration"
