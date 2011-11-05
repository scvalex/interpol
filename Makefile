TESTS1 := Test/Simple Test/One
TESTS2 := Test/Standalone Test/Pure

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
	rm -f $(TESTS1) $(TESTS2) Test/*.{hi,o}

define \n


endef

test: install clean-tests
	$(foreach t,$(TESTS1),ghc -F -pgmF interpol $(t)${\n})
	$(foreach t,$(TESTS2),ghc $(t)${\n})
	$(foreach t,$(TESTS1) $(TESTS2),[ "`$(t)`" = "I have 23 apples." ]${\n})

dist/setup-config: interpol.cabal
	cabal configure
