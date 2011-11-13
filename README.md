interpol
========

> variable interpolations


Examples
--------

The `interpol` preprocessor parses Haskell source file *before* GHC
and performs variable interpolation statically.  Concretely, it
replaces `{identifier}` patterns in literal strings with `show
identifier`.  For instance,

    okVal = 23
    "I have {okVal} apples."

becomes

    "I have 23 apples."

This works on any type that has a `Show` instance and is safe, in the
sense that it does not disable any of GHC's normal checks
(i.e. interpolating a non-existing identifier or one whose type does
not have a `Show` instance will result in the appropriate error).


Installation
------------

This package is on
[Hackage](http://hackage.haskell.org/package/interpol).  To install
it, run:

    cabal update
    cabal install interpol


Usage
-----

To use `interpol`, install the cabal package (and/or make sure that
the `interpol` executable is in your path), and compile with the `"-F
-pgmF interpol"` GHC options.  For instance, one of the tests for this
package is compiled with:

    ghc -F -pgmF interpol Test/One.hs

Alternatively, you may specify the options in a `GHC_OPTIONS` pragma
at the top of the file:

    {-# OPTIONS_GHC -F -pgmF interpol #-}

Note that, unless you use this latter pragma,
[ghc-mod](http://www.mew.org/~kazu/proj/ghc-mod/en/) and other
`flymake`-based Emacs modes will probably complain about unused
variables.

Operation
---------

The `interpol` preprocessor effectively does two things:

 1. it adds an import declaration for `Text.Interpol`, in order to
     bring the `(^-^)` operator into scope, and

 1. it replaces any occurrence of `"\\{[A-z_][A-z0-9_]*}"` in string
    literals with `"^-^ <ident> ^-^"`.

So,

    "I have {okVal} apples."

actually becomes

    ("I have " ^-^ okVal ^-^ " apples.")

The `(^-^)` operator is a smarter version of `(++)`: it shows its
second argument before appending, but only if it is not already a
`String` (i.e. it does not quote `String` values when interpolating).

Run the preprocessor manually and check out the source for details
(seriously now, this README is longer than the source).
