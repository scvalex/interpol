module Main (
        main
    ) where

import Data.Monoid ( Monoid(..) )
import Language.Haskell.Preprocessor ( Extension(..), transform, base )
import System.Environment ( getArgs )

extension :: Extension
extension = interpolExt `mappend` base

interpolExt :: Extension
interpolExt = mempty

main :: IO ()
main = transform extension =<< getArgs
