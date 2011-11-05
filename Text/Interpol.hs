-- | Support module for the @interpol@ preprocessor.
module Text.Interpol (
        (^-^)
    ) where

import Data.Typeable ( Typeable, cast )

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
(^-^) :: (Typeable a, Show a) => String -> a -> String
s ^-^ st = case cast st of
             Just s' -> s ++ s'
             Nothing -> s ++ show st
