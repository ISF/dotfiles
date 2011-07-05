# simple makefile to zsh's functions
ZC=zcompile
SHELL=/bin/zsh

FUNCTIONS=$(shell find . -name '*[^.zwc]' | grep -v makefile | xargs -e)
COMPILED_FUNCTIONS=$(FUNCTIONS:%=%.zwc)

.PHONY : all

all : $(COMPILED_FUNCTIONS)

%.zwc : %
	$(ZC) $<
