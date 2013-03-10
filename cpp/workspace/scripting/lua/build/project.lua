
project      "sudoku_scripting_lua"
language     "C++"
kind         "SharedLib"
targetname   "sudoku"
targetprefix ""

generatedFiles{"sudoku_wrapper.cpp"}

links{"sudoku_scripting_lib", "lua_library"}

preBuild("swig", function()

   projects = solution().projects

   swigBase = projects.swig.basedir

   thisBase = projects["sudoku_scripting_lua"].basedir

   libBase  = projects["sudoku_scripting_lib"].basedir

   swigPath = "../../" .. path.getrelative(thisBase, swigBase .. "/..")

   libPath  = "../../" .. path.getrelative(thisBase, libBase .. "/..")

   return " -I" .. swigPath .. "/src/Lib" ..
          " -I" .. swigPath .. "/src/Lib/lua" ..
          " -I" .. swigPath .. "/build -c++ -lua" ..
          " -o ../../../bin/sudoku_wrapper.cpp " ..
          libPath .. "/include/sudoku.i"
end)