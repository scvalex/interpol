module Main (
        main
    ) where

import Data.Generics ( mkT, everywhere )
import Language.Haskell.Exts ( prettyPrint
                             , ParseResult(..), parseFileWithExts
                             , Module(..), Exp(..), QOp(..)
                             , QName(..), Name(..), Literal(..) )
import System.Environment ( getArgs )
import Text.Printf ( printf )
import Text.Regex.Posix ( (=~) )

main :: IO ()
main = do
  [_, fin, fout] <- getArgs
  res <- parseFileWithExts [] fin
  case res of
    ParseFailed loc reason -> do
        printf "%s:%s: Parse Failed: %s" fin (show loc) reason
        writeFile fout =<< readFile fin
    ParseOk m -> do
        writeFile fout . prettyPrint $ transform m

transform :: Module -> Module
transform = everywhere (mkT trans)
    where
      trans :: Exp -> Exp
      trans (Lit (String s)) = interpol s
      trans e                = e

      identRE = "\\{[A-z_][A-z0-9_]*}"

      interpol :: String -> Exp
      interpol s
          | s =~ identRE = Paren $ go s
          | otherwise    = Lit (String s)

      go :: String -> Exp
      go s = let (before, ident, after) = s =~ identRE
                 e =  InfixApp (Lit (String before))
                               appendOp
                               (App (Var (UnQual (Ident "show")))
                                    (Var (UnQual (Ident $ ti ident))))
             in case ident of
               "" -> (Lit (String before))
               _  -> InfixApp e appendOp $ go after

      appendOp :: QOp
      appendOp = QVarOp (UnQual (Symbol "++"))

      ti = tail . init
