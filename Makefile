TESTS := Test/Simple

all: build

build: dist/setup-config
	cabal build

install: build
	cabal install

clean: clean-tests
	cabal clean

clean-tests:
	rm -f $(TESTS) Test/*.{hi,o}

define \n


endef

test: install clean-tests
	$(foreach t,$(TESTS),ghc -pgmF interpol $(t)${\n})
	$(foreach t,$(TESTS),[ `$(t)` = "Ok" ])

.PHONY: all build install clean clean-tests test

dist/setup-config: interpol.cabal
	cabal configure
