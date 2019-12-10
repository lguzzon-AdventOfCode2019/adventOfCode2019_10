
import unittest

import adventOfCode2019_10
import adventOfCode2019_10/consts


suite "unit-test suite":
    test "getMessage":
        assert(cHelloWorld == getMessage())
