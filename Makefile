TESTS := Test/Simple Test/One

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
	$(foreach t,$(TESTS),ghc -F -pgmF interpol $(t)${\n})
	$(foreach t,$(TESTS),[ "`$(t)`" = "I have 23 apples." ]${\n})

.PHONY: all build install clean clean-tests test

dist/setup-config: interpol.cabal
	cabal configure
