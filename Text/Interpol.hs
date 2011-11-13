{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances #-}

-- | Support module for the @interpol@ preprocessor.
module Text.Interpol (
        (^-^)
    ) where

infixl 3 ^-^

-- | Append a showable value to a 'String' in a smart way.  In
-- particular, do /not/ 'show' a 'String', as this encloses it in
-- \"quotes\".  So, depending on the type of the second parameter,
-- '^-^' is equivalent to one of the following
--
-- @
--   x ^-^ y = x ++ y
--   x ^-^ y = x ++ show y
-- @
--
-- For all intents and purposes, the 'Interpol' type-class is a
-- wrapper around 'Show', so any type that has an instance for 'Show'
-- will also have an instance for 'Interpol'.
(^-^) :: Interpol a => String -> a -> String
(^-^) = interpol

class Interpol a where
    interpol :: String -> a -> String

instance Interpol [Char] where
    interpol s x = s ++ x

instance Show a => Interpol a where
    interpol s x = s ++ show x
