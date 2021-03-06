module Data.CRF.Chain2.Tiers.DP
( table
, flexible2
, flexible3
) where

import qualified Data.Array as A
import Data.Array ((!))
import Data.Ix (range)

table :: A.Ix i => (i, i) -> ((i -> e) -> i -> e) -> A.Array i e
table bounds f = table' where
    table' = A.listArray bounds
           $ map (f (table' !)) 
           $ range bounds

down1 :: A.Ix i => (i, i) -> (i -> e) -> i -> e
down1 bounds f = (!) down' where
    down' = A.listArray bounds
          $ map f
          $ range bounds

down2 :: (A.Ix i, A.Ix j) => (j, j) -> (j -> (i, i)) -> (j -> i -> e)
      -> j -> i -> e
down2 bounds1 bounds2 f = (!) down' where
    down' = A.listArray bounds1
        [ down1 (bounds2 i) (f i)
        | i <- range bounds1 ]

flexible2 :: (A.Ix i, A.Ix j) => (j, j) -> (j -> (i, i))  
          -> ((j -> i -> e) -> j -> i -> e) -> j -> i -> e
flexible2 bounds1 bounds2 f = (!) flex where
    flex = A.listArray bounds1
        [ down1 (bounds2 i) (f (flex !) i)
        | i <- range bounds1 ]

flexible3 :: (A.Ix j, A.Ix i, A.Ix k) => (k, k) -> (k -> (j, j))
          -> (k -> j -> (i, i)) -> ((k -> j -> i -> e) -> k -> j -> i -> e)
           -> k -> j -> i -> e
flexible3 bounds1 bounds2 bounds3 f = (!) flex where
    flex = A.listArray bounds1
        [ down2 (bounds2 i) (bounds3 i) (f (flex !) i)
        | i <- range bounds1 ]
