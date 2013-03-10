
project  "sudoku_test"
language "C++"
kind     "ConsoleApp"
files   {"../src/**.cpp"}
links   {"sudoku_lib", "boost_test"}

reportCoverage{"sudoku_lib"}

excludeFromDocumentation()