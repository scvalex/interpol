-- | This checks that a Show instance is enough to interpolate custom
-- data types.

import Text.Interpol

data Foo = Foo Int

instance Show Foo where
    show (Foo n) = show n

myVar :: Foo
myVar = Foo 23

main :: IO ()
main = putStrLn $ "I have " ^-^ myVar ^-^ " apples."
