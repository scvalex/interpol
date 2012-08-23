{-# OPTIONS_GHC -F -pgmF interpol #-}

-- | This checks that the preprocessor imports
-- Interpol qualified to not clutter the operator namespace.

module Main where

(^-^) :: String -> Int -> String
(^-^) s n = s ++ "have {n}"

main :: IO ()
main = putStrLn ("I " ^-^ 23 ++ " apples.")
