SHELL = /bin/sh

# all: deps install [X, Y, Z...] clean

eg_var ?=
config_file := envvars.json

$(eval current_dir=$(shell pwd))
$(eval program=$(shell jq '.Parameters.Program' ${config_file}))

installations: deps install clean

.PHONY: deps
deps:
	$(info [+] Download the relevant dependencies)
	pip install virtualenv
	virtualenv -p python3 venv
	. venv/bin/activate
	pip install jq
	pip install great_expectations

.PHONY: install
install:
	$(info [+] Install the relevant dependencies)
	great_expectations init

.PHONY: clean
clean:
	$(info [+] Remove any redundant files, e.g. downloads)
