module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Test.PlainArray


all : Test
all =
  Test.PlainArray.tests
