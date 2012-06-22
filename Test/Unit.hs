module Main where

import Data.Monoid

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.HUnit

import Text.Interpol

main :: IO ()
main = defaultMainWithOpts
       [ testCase "toString" testToString
       ] mempty

testToString :: Assertion
testToString = do
    ("I " ^-^ "have " ^-^ "apples") @?= "I have apples"
    ("Triple " ^-^ 'X') @?= "Triple 'X'"
    ("Am " ^-^ (21 :: Int) ^-^ " years old") @?= "Am 21 years old"
    ((21 :: Int) ^-^ " is my age") @?= "21 is my age"
    ("Umlaut: " ^-^ 'ü') @?= "Umlaut: 'ü'"
