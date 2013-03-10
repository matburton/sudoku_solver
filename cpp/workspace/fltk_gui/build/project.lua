
project  "sudoku_fltk_gui"
language "C++"
kind     "WindowedApp"
links   {"sudoku_lib",
         "fltk"}
files   {"../src/**.hpp",
         "../src/**.cpp"}

if os.is "windows" then

   files{"../resources/**.rc"}

   resincludedirs{"../resources"}
end

includedirs{"../src"}