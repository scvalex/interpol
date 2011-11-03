interpol
========

> variable interpolations


Examples
--------

The `interpol` pre-processor parses Haskell source file *before* GHC
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


Operation
---------

The `interpol` pre-processor effectively replaces
`"\\{[A-z_][A-z0-9_]*}"` with `"++ show *<ident>* ++"`.  So,

    "I have {okVal} apples."

actually becomes

    ("I have " ++ show okVal ++ " apples.")

Run the pre-processor manually and check out the source for details
(seriously now, this README is longer than the source).
