#!/bin/bash

set -euo pipefail

### This script is intended to be run in the cdrx/pyinstaller-windows:python2 Docker image


[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image! Use the Makefile" && exit 1

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

# Update pip (so that compiled packages are used if rust is required)
python -m pip install --upgrade pip

# Install impacket
cd /impacket/impacket
pip install .

# Create standalone executables
for i in /impacket/impacket/examples/*.py
do 
    pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F $i
done

# Rename binaries and move
mkdir -p /impacket/dist
for f in /tmp/out/*.exe; do mv "$f" "${f%.*}_windows.${f##*.}"; done
mv /tmp/out/* /impacket/dist/
