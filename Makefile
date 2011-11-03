TESTS := Test/Simple Test/One

.PHONY: all build dist install clean clean-tests test

all: build

build: dist/setup-config
	cabal build

dist: test
	cabal sdist

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

dist/setup-config: interpol.cabal
	cabal configure
