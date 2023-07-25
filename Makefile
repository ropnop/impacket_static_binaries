.PHONY: all linux musl windows help cleanspec clean

help:	## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: linux musl windows ## (Build everything)

linux: ## Build linux_x64 Binaries in Docker
	@docker run --rm \
		-v "${PWD}:/impacket" \
		-w "/impacket" \
		rflathers/centos5_python27 \
		build_scripts/build_linux.sh

musl: ## Build linux_x64 binaries against musl in Alpine Linux Docker
	@docker run --rm \
		-v "${PWD}:/impacket" \
		-w "/impacket" \
		rflathers/alpine34_pyinstaller \
		build_scripts/build_musl.sh

windows: ## Build Windows_x64 binaries
	@docker run --rm \
		-v "${PWD}:/impacket" \
		-w "/impacket" \
		--entrypoint="/impacket/build_scripts/build_windows.sh" \
		cdrx/pyinstaller-windows:python3

clean: cleanspec ## Remove all build artifacts
	rm -rf dist/* build/*

cleanspec: ## Remove spec files
	rm -f *.spec
	rm -rf spec/

