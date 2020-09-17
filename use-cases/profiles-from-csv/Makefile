SHELL := /bin/bash
MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

jackson:
	make -f Makefile-jnld-advisor upload
	make -f Makefile-jnld-seminar upload
	make -f Makefile-jnld-wholesaler upload
