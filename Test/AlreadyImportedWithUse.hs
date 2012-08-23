{-# OPTIONS_GHC -F -pgmF interpol #-}

-- | Checks what happens if Interpol is already imported
-- when the the preprocessor is imported and used.

module Main where

import Text.Interpol

myVar :: Int
myVar = 23

have :: String
have = "have"

main :: IO ()
main = putStrLn $ "I #{have} " ^-^ myVar ^-^ " apples."
