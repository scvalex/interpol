-- | This checks that 'String's do not get unnecessarily quoted.

import Text.Interpol

myVar :: String
myVar = "23"

main :: IO ()
main = putStrLn $ "I have " ^-^ myVar ^-^ " apples."
