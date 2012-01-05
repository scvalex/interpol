{-# LANGUAGE FlexibleInstances, UndecidableInstances, OverlappingInstances #-}

-- | Support module for the @interpol@ preprocessor.
module Text.Interpol (
        (^-^)
      , interpol
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
-- For all intents and purposes, the 'ToString' type-class is a
-- wrapper around 'Show', so any type that has an instance for 'Show'
-- will also have an instance for 'Interpol'.
(^-^), interpol :: (ToString a, ToString b) => a -> b -> String
(^-^) = interpol
interpol a b = toString a ++ toString b

class ToString a where
    toString :: a -> String

instance ToString [Char] where
    toString = id

instance ToString Char where
    toString c = '\'' : c : "'"

instance Show a => ToString a where
    toString = show
