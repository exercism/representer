{-# LANGUAGE ScopedTypeVariables #-}
module Matrix (saddlePoints) where

import Data.Array (Array, bounds, assocs, listArray, (!))
import Data.Ix (Ix)
import Data.List (groupBy, sortBy)
import Data.Function (on)

saddlePoints :: forall ri ci e. (Ix ri, Ix ci, Ord e) => Array (ri, ci) e -> [(ri,ci)]
saddlePoints matrix = let
  is_saddle = is_saddle' (rows_maxima, cols_minima)
  in map fst $ filter is_saddle $ assocs matrix

  where
    is_saddle' :: (Array ri e, Array ci e) -> ((ri, ci), e) -> Bool
    is_saddle' (rmax, cmin) ((r,c), v) = v == rmax ! r && v == cmin ! c

    rows_maxima :: Array ri e
    rows_maxima = to_arr $ maximums $ groupBy same_row row_vals
      where
        row_vals :: [(ri, e)]
        row_vals = [(r,v) | ((r,_),v) <- assocs matrix]

        same_row :: (ri,e) -> (ri,e) -> Bool
        same_row = (==) `on` fst

        maximums :: [[(ri,e)]] -> [e]
        maximums = map (maximum . map snd)

        to_arr :: [e] -> Array ri e
        to_arr = listArray row_bounds
          where
            row_bounds :: (ri, ri)
            row_bounds = let ((rmin,_), (rmax,_)) = bounds matrix in (rmin, rmax)

    cols_minima :: Array ci e
    cols_minima = to_arr $ minimums $ groupBy same_col $ sortBy by_column col_vals
      where
        col_vals :: [(ci,e)]
        col_vals = [(c,v) | ((_,c),v) <- assocs matrix]

        by_column :: (ci,e) -> (ci,e) -> Ordering
        by_column = compare `on` fst

        same_col :: (ci,e) -> (ci,e) -> Bool
        same_col = (==) `on` fst

        minimums :: [[(ci,e)]] -> [e]
        minimums = map (minimum . map snd)

        to_arr :: [e] -> Array ci e
        to_arr = listArray col_bounds
          where
            col_bounds :: (ci, ci)
            col_bounds = let ((_,cmin), (_,cmax)) = bounds matrix in (cmin, cmax)

     


    