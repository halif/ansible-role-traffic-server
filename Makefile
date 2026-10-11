SHELL := /bin/bash

.PHONY: help lint yamllint ansible-lint molecule clean

help:
	@echo "Available targets:"
	@echo "  make lint          Run all linters"
	@echo "  make yamllint      Run yamllint"
	@echo "  make ansible-lint  Run ansible-lint"
	@echo "  make molecule      Run Molecule tests"
	@echo "  make clean         Remove Molecule artifacts"

lint: yamllint ansible-lint

yamllint:
	yamllint -c .config/yamllint.yml .

ansible-lint:
	ansible-lint -c .config/.ansible-lint.yml .

molecule:
	molecule test

clean:
	rm -rf .molecule molecule/default/.molecule
	find . -type d -name "__pycache__" -prune -exec rm -rf {} +
	find . -type f -name "*.retry" -delete