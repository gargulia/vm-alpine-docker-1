#!/bin/bash
pkg install qemu-utils
pkg install qemu-common
pkg install qemu-system-x86_64-headless
apt install wget
mkdir alpine && cd $_
wget http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-virt-3.12.3-x86_64.iso
qemu-img create -f qcow2 alpine.img 4G
qemu-system-x86_64 -machine q35 -m 1024 -smp cpus=2 -cpu qemu64 \
  -drive if=pflash,format=raw,read-only,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
  -cdrom alpine-virt-3.12.3-x86_64.iso \
  -nographic alpine.img
