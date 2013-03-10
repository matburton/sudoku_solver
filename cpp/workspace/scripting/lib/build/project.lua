
project  "sudoku_scripting_lib"
language "C++"
kind     "StaticLib"

files{"../include/**.hpp",
      "../include/**.i",
      "../src/**pp"}

includedirs{"../src"}

onLink(function()

   includedirs{"../include"}
end)

links{"sudoku_lib"}