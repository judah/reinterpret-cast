{-# LANGUAGE FlexibleContexts #-}

-- | This is the 'array' approach.
--
-- Implements casting via a 1-elemnt STUArray, as described in
-- <http://stackoverflow.com/a/7002812/263061>.
module Data.ReinterpretCast.Internal.ImplArray
  ( wordToFloat
  , floatToWord
  , wordToDouble
  , doubleToWord
  ) where

import Data.Word (Word32, Word64)
import Data.Array.ST (newArray, readArray, MArray, STUArray)
import Data.Array.Unsafe (castSTUArray)
import GHC.ST (runST, ST)


-- | Reinterpret-casts a `Word32` to a `Float`.
wordToFloat :: Word32 -> Float
wordToFloat x = runST (cast x)

{-# INLINEABLE wordToFloat #-}


-- | Reinterpret-casts a `Float` to a `Word32`.
floatToWord :: Float -> Word32
floatToWord x = runST (cast x)

{-# INLINEABLE floatToWord #-}


-- | Reinterpret-casts a `Word64` to a `Double`.
wordToDouble :: Word64 -> Double
wordToDouble x = runST (cast x)

{-# INLINEABLE wordToDouble #-}


-- | Reinterpret-casts a `Double` to a `Word64`.
doubleToWord :: Double -> Word64
doubleToWord x = runST (cast x)

{-# INLINEABLE doubleToWord #-}


{-# INLINE cast #-}
cast :: (MArray (STUArray s) a (ST s),
         MArray (STUArray s) b (ST s)) => a -> ST s b
cast x = newArray (0 :: Int, 0) x >>= castSTUArray >>= flip readArray 0
