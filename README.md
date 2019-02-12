# Impacket Static Binaries
[![CircleCI](https://circleci.com/gh/ropnop/impacket_static_binaries.svg?style=svg)](https://circleci.com/gh/ropnop/impacket_static_binaries)   [Get Latest Binaries Here](https://github.com/ropnop/impacket_static_binaries/releases/latest)

## Description
This repository is a fork of the amazing Impacket project available here: https://github.com/SecureAuthCorp/impacket

This fork has a CircleCI pipeline to create stand-alone executables for both Windows and Linux x64 of all the Impacket example scripts and upload the binaries to this project's github releases.

It's using [PyInstaller](http://www.pyinstaller.org/) to create both the Windows and Linux executables. The Windows binaries are built with Wine using cdrx's docker image: https://github.com/cdrx/docker-pyinstaller

For maximum compatibility, the Linux binaries are built with the oldest version of glibc I could find - CentOS 5 running Glibc 2.5: https://github.com/ropnop/centos5_python27_docker. These binaries should work with any version of glibc newer than 2.5. 

I've also compiled all the Linux binaries against [musl](https://www.musl-libc.org/) instead of glibc in case you land in a lightweight container (e.g. Alpine) that doesn't use glibc. These are all bundled up in a file on the releases page called `impacket_musl_binaries.tar.gz`.

## Usage
If you are operating in a restricted environment that either doesn't have Python (or you don't want to disturb any existing python packages), you should be able to download and execute the Impacket examples from the releases page.

For example, it's possible to run `wmiexec.py` inside a barebones Ubuntu container that doesn't even have Python installed:

```
$ python
bash: python: command not found
$ curl -s -o wmiexec -L https://github.com/ropnop/impacket_static_binaries/releases/download/0.9.19-dev-binaries/wmiexec_linux_x86_64
$ chmod +x wmiexec
$ ./wmiexec LAB/agreen@192.168.98.161
Impacket v0.9.19-dev - Copyright 2018 SecureAuth Corporation

Password:
[*] SMBv2.1 dialect used
[!] Launching semi-interactive shell - Careful what you execute
[!] Press help for extra shell commands
C:\>whoami
lab\agreen
```

### Building
If you'd like to build the binaries locally, I've included a Makefile and build scripts that essentially do the exact same thing CircleCI does. You need to run the build scripts inside the correct Dockerimage (the make targets take care of that for you).

```
$ make help
help:	 Show this help
all: linux musl windows  (Build everything)
linux:  Build linux_x64 Binaries in Docker
musl:  Build linux_x64 binaries against musl in Alpine Linux Docker
windows:  Build Windows_x64 binaries
clean: cleanspec  Remove all build artifacts
cleanspec:  Remove spec files
```

To build all the Linux binaries for example: `make linux`. This will output all the binaries in the `./dist` directory for you.

## Known issues
`ntlmrelayx` and `smbrelayx` aren't working properly yet. They do some custom loading that PyInstaller doesn't like. Still working on that...

Currently, `wmiexec.py`, `psexec.py` and `dcomexec.py` are hardcoded to use UTF-8 in the built binaries. There's some issues with Pyinstaller and calling `sys.stdout.encoding`. If you need something other than UTF-8, you'll have to rebuild on your own for now. Still working on this....

Currently glibc >= 2.5 is required. Eventually I'd like to look at building against musl (so they could work in Alpine linux for example)

I also haven't fully tested every example, so no guarantees. If you discover something that's not working as intended, please file an issue and let me know.

Enjoy!
-ropnop

PS shout out to maaaaz for the inspiration! https://github.com/maaaaz/impacket-examples-windows
