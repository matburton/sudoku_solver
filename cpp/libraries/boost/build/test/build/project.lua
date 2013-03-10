
project  "boost_test"
language "C++"
kind     "StaticLib"

headerLinks{"boost"}

local boostPath = "../../../src"

files{"init_unit_test_suite.cpp",
      boostPath .. "/boost/test/**.hpp",
      boostPath .. "/libs/test/src/**.cpp"}

excludes{boostPath .. "/libs/test/src/test_main.cpp",
         boostPath .. "/libs/test/src/cpp_main.cpp"}