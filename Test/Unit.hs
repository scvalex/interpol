module Main where

import System.Exit ( exitFailure )
import Test.HUnit
import Text.Interpol

main :: IO ()
main = do
  runCounts <- runTestTT $ test [ toStringTests ]
  if failures runCounts + errors runCounts == 0
    then
      putStrLn "All unit tests pass :)"
    else do
      putStrLn "Failures or errors occured :'("
      exitFailure

toStringTests :: Test
toStringTests =
    test [ "string" ~: TestCase $ do
             assertEqual "" "I have apples" ("I " ^-^ "have " ^-^ "apples")
         , "char" ~: TestCase $ do
             assertEqual "" "Triple 'X'" ("Triple " ^-^ 'X')
         , "number" ~: TestCase $ do
             assertEqual "" "Am 21 years old" ("Am " ^-^ (21 :: Int) ^-^
                                               " years old")
         ]
