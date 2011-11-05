module Text.Interpol (
        (^-^)
    ) where

import Data.Typeable ( Typeable, cast )

infixl 3 ^-^

(^-^) :: (Typeable a, Show a) => String -> a -> String
s ^-^ st = case cast st of
             Just s' -> s ++ s'
             Nothing -> s ++ show st
