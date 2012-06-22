TESTS1 := Simple One String NoImport
TESTS2 := Standalone Pure PureString NoWarn JustShow
GHC := ghc -Wall -Werror

.PHONY: all build dist install clean clean-tests test doc

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
	rm -f Test/*.{hi,o}
	$(foreach t,$(TESTS1) $(TESTS2),rm -f Test/$(t)${\n})

define \n


endef

test: build clean-tests
	cabal test
	make install
	$(foreach t,$(TESTS1),cd Test && $(GHC) -F -pgmF interpol $(t)${\n})
	$(foreach t,$(TESTS2),cd Test && $(GHC) $(t)${\n})
	$(foreach t,$(TESTS1) $(TESTS2),cd Test && [ "`./$(t)`" = "I have 23 apples." ]${\n})

dist/setup-config: interpol.cabal
	cabal configure --enable-tests

doc: build
	cabal haddock
