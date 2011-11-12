{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances #-}
-- | Support module for the @interpol@ preprocessor.
module Text.Interpol (
        (^-^)
    ) where

infixl 3 ^-^

(^-^) :: Interpol a => String -> a -> String
(^-^) = interpol

class Interpol a where
  -- | Append a showable value to a 'String' in a smart way.  In
  -- particular, do /not/ 'show' a 'String', as this encloses it in
  -- \"quotes\".  So, depending on the type of the second parameter,
  -- '^-^' is equivalent to one of the following
  --
  -- @
  --   x ^-^ y = x ++ y
  --   x ^-^ y = x ++ show y
  -- @
  interpol :: String -> a -> String

instance Interpol [Char] where
  interpol s x = s ++ x

instance Show a => Interpol a where
  interpol s x = s ++ show x