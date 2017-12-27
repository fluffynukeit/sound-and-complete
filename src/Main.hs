module Main where

import Pretty
import Types
import Infer
import Data.Text.Prettyprint.Doc.Util (putDocW)

main :: IO ()
main = do
  pprs [mapExpr, fstExpr, sndExpr, swapExpr]

pprs es = let
  pprPlain n e = do
    putDocW n (ppr e)
    putStrLn ""
  pprGrouped n e = do
    putStrLn ""
    putDocW n (runPprM (group (pprM e)))
    putStrLn ""
  in do
    putStrLn "\nPlain 40:"
    mapM_ (pprPlain 40) es
    putStrLn "\nGrouped 40:"
    mapM_ (pprGrouped 40) es
    putStrLn "\nGrouped 80:"
    mapM_ (pprGrouped 80) es

expr :: E
expr = Const 1 :+: Const 2 :*: ((Const 3 :+: Const 4) :/: Const 6)

data E =
  Const Int |
  E :+: E |
  E :-: E |
  E :*: E |
  E :/: E

infixl 6 :+:
infixl 6 :-:
infixl 7 :*:
infixl 7 :/:

instance Show E where
  showsPrec p e0 =
    case e0 of
     Const n -> showParen (p > 10) $ showString "Const " . showsPrec 11 n
     x :+: y -> showParen (p > 6) $ showsPrec 6 x . showString " :+: " . showsPrec 7 y
     x :-: y -> showParen (p > 6) $ showsPrec 6 x . showString " :-: " . showsPrec 7 y
     x :*: y -> showParen (p > 7) $ showsPrec 7 x . showString " :*: " . showsPrec 8 y
     x :/: y -> showParen (p > 7) $ showsPrec 7 x . showString " :/: " . showsPrec 8 y
