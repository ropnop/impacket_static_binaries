#!/bin/bash

set -euo pipefail

### This script is intended to be run in the rflathers/alpine34_pyinstaller Docker image

[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image! Use the Makefile" && exit 1

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

# Install dependencies
pip install pip==18.1
pip install setuptools==40.6.3
pip install pyinstaller==3.4

# Install impacket
cd /impacket/impacket
pip install .

# Hardcode UTF-8 in shells
sed -r -i.bak 's/sys\.std(in|out)\.encoding/"UTF-8"/g' examples/*exec.py  

# Create standalone executables
for i in /impacket/impacket/examples/*.py
do 
    pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F $i
done

# Rename binaries
mkdir -p /impacket/dist
ARCH=$(uname -m)
find /tmp/out/ -type f -exec mv {} {}_musl_$ARCH \;
mv /tmp/out/* /impacket/dist/

# Restore backup file
for fn in examples/*.bak; do mv -f "${fn}" "${fn%%.bak}"; done
