{-# OPTIONS_GHC -F -pgmF interpol #-}

-- | The idea here is to check that @foo n@ will not result in an
-- "unused variable" warning.  Of course, it doesn't really work
-- unless you open the file in Emacs or something.

module Main where

main :: IO ()
main = foo 23

foo :: Int -> IO ()
foo n = putStrLn "I have {n} apples."
