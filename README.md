	What is vm-alpine-docker-1 for:
	
This program creates an Alpine Linux virtual machine
that can be used to run Docker x86 containers on
your Android device using the Termux terminal emulator.

* Note: It is recommended to use SSH or an external
keyboard to execute the following commands, unless
you want to hurt yourself.
(See https://wiki.termux.com/wiki/Remote_Access#SSH)

* Note: vm-alpine-docker is an old version. I will put the list of
changes at the end of this README.md

Required dependencies:

proot(recomended), git, wget, qemu-utils, qemu-common,
qemu-system-x86_64-headless,
alpine-virt-3.12.3-x86_64.iso.

Installation:

1. Download files from repository:

```
git clone https://github.com/gargulia/vm-alpine-docker-1.git
cd vm-alpine-docker-1
```

2. Perform:

```
./vm-alpine-install.sh
```


3. Log in as root (no password) into the running Alpine virtual machine.

4. Network setup (press Enter to use default settings):

```
 localhost:~# setup-interfaces
 Available interfaces are: eth0.
 Enter '?' for help on bridges, bonding and vlans.
 Which one do you want to initialize? (or '?' or 'done') [eth0] 
 Ip address for eth0? (or 'dhcp', 'none', '?') [dhcp] 
 Do you want to do any manual network configuration? [no] 
 localhost:~# ifup eth0
```
* Note: You need to enter setup-interfaces,
then press Enter until local_host:~# is displayed
Then enter the command ifup eth0

#The output should match the above.

5. Create a response file to speed up the installation:

```
localhost:~# wget https://gist.githubusercontent.com/oofnikj/e79aef095cd08756f7f26ed244355d62/raw/answerfile
```

6. Patch setup-disk to enable serial console output on boot:

```
localhost:~# sed -i -E 's/(local kernel_opts)=.*/\1="console=ttyS0"/' /sbin/setup-disk
```

7. Run the setup to install to disk:

```
localhost:~# setup-alpine -f answerfile
```

8. Once the installation is complete, shut down
the virtual machine and boot it again without the CD-ROM:

```
localhost:~# poweroff

qemu-system-x86_64 -machine q35 -m 1024 -smp cpus=2 -cpu qemu64 \
  -drive if=pflash,format=raw,read-only,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
  -nographic alpine.img
```

* Note: When in a different directory,
the error 'no such file or directory' occurs. I recommend
to boot the virtual machine while in the ~/alpine directory. This helps to avoid the error.

* Note: Use ./run.sh for subsequent VM
starts (one of the changes  in vm-alpine-docker-1).

9. Install Docker and enable it when booting
the installed alpine-virt:

```
alpine:~# apk update && apk add docker
alpine:~# service docker start
alpine:~# rc-update add docker
```

* Note: Useful keyboard shortcuts in the qemu-session:

Ctrl+ax: exit emulation
Ctrl+ah: switch console QEMU

Usage:

```
./run.sh
```

Changes: 

 - Added run.sh (previously vm-alpine-run.sh) to simplify starting alpine-virt with Doker Daemon;
 - The README file has been revised and supplemented.
