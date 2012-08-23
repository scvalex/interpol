{-# OPTIONS_GHC -F -pgmF interpol #-}

-- | Checks what happens if Interpol is
-- already imported when using the preprocessor.

module Main where

import Text.Interpol

myVar :: Int
myVar = 23

main :: IO ()
main = putStrLn $ "I have " ^-^ myVar ^-^ " apples."
