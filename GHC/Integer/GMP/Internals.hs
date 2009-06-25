{-# LANGUAGE ForeignFunctionInterface, GHCForeignImportPrim,
             MagicHash, UnboxedTuples, UnliftedFFITypes #-}
{-# OPTIONS_GHC -XNoImplicitPrelude #-}
{-# OPTIONS_HADDOCK hide #-}

#include "MachDeps.h"
module GHC.Integer.GMP.Internals (
    Integer(..),

    cmpInteger#,
    cmpIntegerInt#,

    plusInteger#,
    minusInteger#,
    timesInteger#,

    quotRemInteger#,
    quotInteger#,
    remInteger#,
    divModInteger#,
    divExactInteger#,

    gcdInteger#,
    gcdIntegerInt#,
    gcdInt#,

    decodeDouble#,

    int2Integer#,
    integer2Int#,

    word2Integer#,
    integer2Word#,

    andInteger#,
    orInteger#,
    xorInteger#,
    complementInteger#,

#if WORD_SIZE_IN_BITS < 64
    int64ToInteger#,  integerToInt64#,
    word64ToInteger#, integerToWord64#,
#endif

#ifndef WORD_SIZE_IN_BITS
#error WORD_SIZE_IN_BITS not defined!!!
#endif

  ) where

import GHC.Prim (Int#, Word#, Double#, ByteArray#)

#if WORD_SIZE_IN_BITS < 64
import GHC.Prim (Int64#, Word64#)
#endif

-- Double isn't available yet, and we shouldn't be using defaults anyway:
default ()

-- | Arbitrary-precision integers.
data Integer
   = S# Int#                            -- small integers
#ifndef ILX
   | J# Int# ByteArray#                 -- large integers
#else
   | J# Void BigInteger                 -- .NET big ints

foreign type dotnet "BigInteger" BigInteger
#endif


-- | Returns -1,0,1 according as first argument is less than, equal to, or greater than second argument.
--
foreign import prim "integer_cmm_cmpIntegerzh" cmpInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> Int#

-- | Returns -1,0,1 according as first argument is less than, equal to, or greater than second argument, which
--   is an ordinary Int\#.
foreign import prim "integer_cmm_cmpIntegerIntzh" cmpIntegerInt#
  :: Int# -> ByteArray# -> Int# -> Int#

-- |
--
foreign import prim "integer_cmm_plusIntegerzh" plusInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_minusIntegerzh" minusInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_timesIntegerzh" timesInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- | Compute div and mod simultaneously, where div rounds towards negative
-- infinity and\ @(q,r) = divModInteger#(x,y)@ implies
-- @plusInteger# (timesInteger# q y) r = x@.
--
foreign import prim "integer_cmm_quotRemIntegerzh" quotRemInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray#, Int#, ByteArray# #)

-- | Rounds towards zero.
--
foreign import prim "integer_cmm_quotIntegerzh" quotInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- | Satisfies \texttt{plusInteger\# (timesInteger\# (quotInteger\# x y) y) (remInteger\# x y) == x}.
--
foreign import prim "integer_cmm_remIntegerzh" remInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- | Compute div and mod simultaneously, where div rounds towards negative infinity
-- and\texttt{(q,r) = divModInteger\#(x,y)} implies \texttt{plusInteger\# (timesInteger\# q y) r = x}.
--
foreign import prim "integer_cmm_divModIntegerzh" divModInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray#, Int#, ByteArray# #)

-- | Divisor is guaranteed to be a factor of dividend.
--
foreign import prim "integer_cmm_divExactIntegerzh" divExactInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- | Greatest common divisor.
--
foreign import prim "integer_cmm_gcdIntegerzh" gcdInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- | Greatest common divisor, where second argument is an ordinary {\tt Int\#}.
--
foreign import prim "integer_cmm_gcdIntegerIntzh" gcdIntegerInt#
  :: Int# -> ByteArray# -> Int# -> Int#

-- |
--
foreign import prim "integer_cmm_gcdIntzh" gcdInt#
  :: Int# -> Int# -> Int#

-- | Convert to arbitrary-precision integer.
--    First {\tt Int\#} in result is the exponent; second {\tt Int\#} and {\tt ByteArray\#}
--  represent an {\tt Integer\#} holding the mantissa.
--
foreign import prim "integer_cmm_decodeDoublezh" decodeDouble#
  :: Double# -> (# Int#, Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_int2Integerzh" int2Integer#
  :: Int# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_integer2Intzh" integer2Int#
  :: Int# -> ByteArray# -> Int#

-- |
--
foreign import prim "integer_cmm_word2Integerzh" word2Integer#
  :: Word# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_integer2Wordzh" integer2Word#
  :: Int# -> ByteArray# -> Word#

-- |
--
foreign import prim "integer_cmm_andIntegerzh" andInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_orIntegerzh" orInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_xorIntegerzh" xorInteger#
  :: Int# -> ByteArray# -> Int# -> ByteArray# -> (# Int#, ByteArray# #)

-- |
--
foreign import prim "integer_cmm_complementIntegerzh" complementInteger#
  :: Int# -> ByteArray# -> (# Int#, ByteArray# #)

#if WORD_SIZE_IN_BITS < 64
foreign import prim "integer_cmm_int64ToIntegerzh" int64ToInteger#
  :: Int64# -> (# Int#, ByteArray# #)

foreign import prim "integer_cmm_word64ToIntegerzh" word64ToInteger#
  :: Word64# -> (# Int#, ByteArray# #)

foreign import ccall unsafe "hs_integerToInt64"
    integerToInt64#  :: Int# -> ByteArray# -> Int64#

foreign import ccall unsafe "hs_integerToWord64"
    integerToWord64# :: Int# -> ByteArray# -> Word64#
#endif