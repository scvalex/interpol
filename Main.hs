module Main (
        main
    ) where

import Data.Generics ( mkT, everywhere )
import Data.Monoid ( Monoid(..) )
import Language.Haskell.Preprocessor ( Extension(..)
                                     , Ast(..), Token(..), Tag(..)
                                     , transform, base )
import System.Environment ( getArgs )
import Text.Regex.Posix ( (=~) )

extension :: Extension
extension = interpolExt `mappend` base

interpolExt :: Extension
interpolExt = mempty { transformer = everywhere (mkT trans) }
    where
      trans :: Ast -> Ast
      trans Single{item = tok@Token{tag = StringLit, val = s}} =
          let s' = '(' : concat (unsafeInterpol $ ti s) ++ ")"
          in Single tok{ val = s' }
      trans ast = ast

      ti = tail . init
      identRE = "\\{[A-z_][A-z0-9_]*}"

      unsafeInterpol :: String -> [String]
      unsafeInterpol s =
          let (before, ident, after) = s =~ identRE
          in case ident of
               "" -> [norm before]
               _  -> norm before : showIdent ident : unsafeInterpol after

      showIdent "" = ""
      showIdent i  = concat [" ++ show ", ti i, " ++ "]

      norm "" = "\"\""
      norm s  = '"' : s ++ "\""

main :: IO ()
main = transform extension =<< getArgs
