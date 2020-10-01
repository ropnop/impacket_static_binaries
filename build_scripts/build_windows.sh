#!/bin/bash

set -euo pipefail

### This script is intended to be run in the cdrx/pyinstaller-windows:python2 Docker image

[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image! Use the Makefile" && exit 1

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

# Install impacket
pip install .

# Create hook directory
mkdir /tmp/custom-hooks

# Create hook file
echo "from PyInstaller.utils.hooks import copy_metadata" >> /tmp/custom-hooks/hook-impacket.py
echo "datas = copy_metadata('impacket')" >> /tmp/custom-hooks/hook-impacket.py

# Create standalone executables
for i in examples/*.py
do
    pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean --additional-hooks-dir /tmp/custom-hooks -F $i
done

# Rename binaries and move
mkdir -p dist
for f in /tmp/out/*.exe; do mv "$f" "${f%.*}_windows.${f##*.}"; done
mv /tmp/out/* ./dist/
