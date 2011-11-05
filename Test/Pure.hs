import Text.Interpol

myVar :: Int
myVar = 23

main :: IO ()
main = putStrLn $ "I have " ^-^ myVar ^-^ " apples."
