{-# OPTIONS_GHC -F -pgmF interpol #-}

module Main where

okVal :: Int
okVal = 23

main :: IO ()
main = putStrLn "I have {okVal} apples."
