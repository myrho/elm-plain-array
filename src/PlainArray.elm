module PlainArray exposing
  ( Array
  , empty, repeat, initialize, fromList
  , isEmpty, length, push, append
  , get, set
  , slice, toList, toIndexedList
  , map, indexedMap, filter, foldl, foldr
  , resizelRepeat, splitAt, removeAt
  )

{-| A library for immutable arrays. The elements in an array must have the
same type. It's intended as a quick replacement of the buggy elm-lang/core's 
Array implementation and uses plain JS arrays under the hood. This API mirrors 
the original API.  

# Arrays
@docs Array

# Creating Arrays 
@docs empty, repeat, initialize, fromList

# Basics
@docs isEmpty, length, push, append

# Get and Set
@docs get, set

# Taking Arrays Apart
@docs slice, toList, toIndexedList

# Mapping, Filtering, and Folding
@docs map, indexedMap, filter, foldl, foldr

# Extra
@docs resizelRepeat, splitAt, removeAt
-}

import Native.PlainArray
import Basics exposing (..)
import Maybe exposing (..)
import List


{-| Representation of fast immutable arrays. You can create arrays of integers
(`Array Int`) or strings (`Array String`) or any other type of value you can
dream up.
-}
type Array a = Array


{-| Initialize an array. `initialize n f` creates an array of length `n` with
the element at index `i` initialized to the result of `(f i)`.

    initialize 4 identity    == fromList [0,1,2,3]
    initialize 4 (\n -> n*n) == fromList [0,1,4,9]
    initialize 4 (always 0)  == fromList [0,0,0,0]
-}
initialize : Int -> (Int -> a) -> Array a
initialize =
  Native.PlainArray.initialize


{-| Creates an array with a given length, filled with a default element.

    repeat 5 0     == fromList [0,0,0,0,0]
    repeat 3 "cat" == fromList ["cat","cat","cat"]

Notice that `repeat 3 x` is the same as `initialize 3 (always x)`.
-}
repeat : Int -> a -> Array a
repeat n e =
  initialize n (always e)


{-| Create an array from a list.
-}
fromList : List a -> Array a
fromList =
  Native.PlainArray.fromList


{-| Create a list of elements from an array.

    toList (fromList [3,5,8]) == [3,5,8]
-}
toList : Array a -> List a
toList =
  Native.PlainArray.toList


-- TODO: make this a native function.
{-| Create an indexed list from an array. Each element of the array will be
paired with its index.

    toIndexedList (fromList ["cat","dog"]) == [(0,"cat"), (1,"dog")]
-}
toIndexedList : Array a -> List (Int, a)
toIndexedList array =
  List.map2
    (,)
    (List.range 0 (Native.PlainArray.length array - 1))
    (Native.PlainArray.toList array)


{-| Apply a function on every element in an array.

    map sqrt (fromList [1,4,9]) == fromList [1,2,3]
-}
map : (a -> b) -> Array a -> Array b
map =
  Native.PlainArray.map


{-| Apply a function on every element with its index as first argument.

    indexedMap (*) (fromList [5,5,5]) == fromList [0,5,10]
-}
indexedMap : (Int -> a -> b) -> Array a -> Array b
indexedMap =
  Native.PlainArray.indexedMap


{-| Reduce an array from the left. Read `foldl` as &ldquo;fold from the left&rdquo;.

    foldl (::) [] (fromList [1,2,3]) == [3,2,1]
-}
foldl : (a -> b -> b) -> b -> Array a -> b
foldl =
  Native.PlainArray.foldl


{-| Reduce an array from the right. Read `foldr` as &ldquo;fold from the right&rdquo;.

    foldr (+) 0 (repeat 3 5) == 15
-}
foldr : (a -> b -> b) -> b -> Array a -> b
foldr =
  Native.PlainArray.foldr


{-| Keep only elements that satisfy the predicate:

    filter isEven (fromList [1,2,3,4,5,6]) == (fromList [2,4,6])
-}
filter : (a -> Bool) -> Array a -> Array a
filter isOkay arr =
  let
    update x xs =
      if isOkay x then
        Native.PlainArray.push x xs
      else
        xs
  in
    Native.PlainArray.foldl update (empty ()) arr

{-| Return an empty array.

    length empty == 0
-}
empty : () -> Array a
empty _ =
  fromList []


{-| Push an element to the end of an array.

    push 3 (fromList [1,2]) == fromList [1,2,3]
-}
push : a -> Array a -> Array a
push =
  Native.PlainArray.push


{-| Return Just the element at the index or Nothing if the index is out of range.

    get  0 (fromList [0,5,3]) == Just 0
    get  2 (fromList [0,5,3]) == Just 3
    get  5 (fromList [0,5,3]) == Nothing
    get -1 (fromList [0,5,3]) == Nothing

-}
get : Int -> Array a -> Maybe a
get i array =
  if 0 <= i && i < Native.PlainArray.length array then
    Just (Native.PlainArray.get i array)
  else
    Nothing


{-| Set the element at a particular index. Returns an updated array.
If the index is out of range, the array is unaltered.

    set 1 7 (fromList [1,2,3]) == fromList [1,7,3]
-}
set : Int -> a -> Array a -> Array a
set =
  Native.PlainArray.set


{-| Get a sub-section of an array: `(slice start end array)`. The `start` is a
zero-based index where we will start our slice. The `end` is a zero-based index
that indicates the end of the slice. The slice extracts up to but not including
`end`.

    slice  0  3 (fromList [0,1,2,3,4]) == fromList [0,1,2]
    slice  1  4 (fromList [0,1,2,3,4]) == fromList [1,2,3]

Both the `start` and `end` indexes can be negative, indicating an offset from
the end of the array.

    slice  1 -1 (fromList [0,1,2,3,4]) == fromList [1,2,3]
    slice -2  5 (fromList [0,1,2,3,4]) == fromList [3,4]

This makes it pretty easy to `pop` the last element off of an array: `slice 0 -1 array`
-}
slice : Int -> Int -> Array a -> Array a
slice =
  Native.PlainArray.slice


{-| Return the length of an array.

    length (fromList [1,2,3]) == 3
-}
length : Array a -> Int
length =
  Native.PlainArray.length


{-| Determine if an array is empty.

    isEmpty empty == True
-}
isEmpty : Array a -> Bool
isEmpty array =
    length array == 0


{-| Append two arrays to a new one.

    append (repeat 2 42) (repeat 3 81) == fromList [42,42,81,81,81]
-}
append : Array a -> Array a -> Array a
append =
  Native.PlainArray.append


{-| Resize an array from the left, padding the right-hand side with the given value.
-}
resizelRepeat : Int -> a -> Array a -> Array a
resizelRepeat n val xs =
    let
        l =
            length xs
    in
        if l > n then
            slice 0 n xs
        else if l < n then
            append xs (repeat (n - l) val)
        else
            xs



{-| Split an array into two arrays, the first ending at and the second starting at the given index
-}
splitAt : Int -> Array a -> ( Array a, Array a )
splitAt index xs =
    -- TODO: refactor (written this way to help avoid Array bugs)
    let
        len =
            length xs
    in
        case ( index > 0, index < len ) of
            ( True, True ) ->
                ( slice 0 index xs, slice index len xs )

            ( True, False ) ->
                ( xs, empty ())

            ( False, True ) ->
                ( empty (), xs )

            ( False, False ) ->
                ( empty (), empty () )


{-| Remove the element at the given index
-}
removeAt : Int -> Array a -> Array a
removeAt index xs =
    -- TODO: refactor (written this way to help avoid Array bugs)
    let
        ( xs0, xs1 ) =
            splitAt index xs

        len1 =
            length xs1
    in
        if len1 == 0 then
            xs0
        else
            append xs0 (slice 1 len1 xs1)

