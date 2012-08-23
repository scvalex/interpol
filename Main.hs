-- | The Interpol pre-processor.
module Main (
        main
    ) where

import Data.Generics ( mkT, everywhere, mkQ, gcount, GenericQ )
import Data.List ( isPrefixOf, tails )
import Language.Haskell.Exts ( prettyPrint
                             , ParseResult(..), parseFileWithExts
                             , Module(..), Exp(..), QOp(..)
                             , QName(..), Name(..), Literal(..)
                             , ImportDecl(..), ModuleName(..), SrcLoc(..) )
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
             let magicLine = "{-# LINE 1 \"" ++ fin ++ "\" #-}\n"
             writeFile fout $ magicLine ++ prettyPrint (transform m)

transform :: Module -> Module
transform = addNecessaryImports . transformed
    where
      -- Replace strings by interpol operator
      transformed = everywhere (mkT trans)

      -- How many interpol operates are present in the module
      countInterpolUses :: GenericQ Int
      countInterpolUses = gcount (mkQ False usesInterpol)

      addNecessaryImports m@(Module _ _ _ _ _ importDecls _)
          | usesInterpol && not alreadyImported = addDecl m
          | otherwise                           = m
          where
            usesInterpol    = countInterpolUses m > 0
            alreadyImported = any isInterpolImport importDecls

      isInterpolImport ImportDecl { importModule = ModuleName name
                                  , importQualified = isQualified } =
          isQualified && name == "Text.Interpol"

      qualifiedInterpolImport = ImportDecl {
            importLoc = SrcLoc { srcFilename = ""
                               , srcLine = 0
                               , srcColumn = 0 }
          , importModule = ModuleName "Text.Interpol"
          , importQualified = True
          , importSrc = False
          , importPkg = Nothing
          , importAs = Nothing
          , importSpecs = Nothing }

      addDecl :: Module -> Module
      addDecl (Module sl mn mps mwt mes ids ds) =
          let ids' = qualifiedInterpolImport : ids
          in Module sl mn mps mwt mes ids' ds

      trans :: Exp -> Exp
      trans (Lit (String s)) = interpol s
      trans e                = e

      identRE = "\\{[A-z_][A-z0-9_]*}"

      interpolOperator = Symbol "Text.Interpol.^-^"

      usesInterpol :: Name -> Bool
      usesInterpol n = n == interpolOperator

      interpol :: String -> Exp
      interpol s
          | s =~ identRE = Paren $ go s
          | otherwise    = Lit (String s)

      go :: String -> Exp
      go s = let (before, ident, after) = s =~ identRE
                 e =  InfixApp (Lit (String before))
                               appendOp
                               (Var (UnQual (Ident $ ti ident)))
             in case ident of
               "" -> Lit (String before)
               _  -> InfixApp e appendOp $ go after

      appendOp :: QOp
      appendOp = QVarOp (UnQual interpolOperator)

      ti = tail . init
