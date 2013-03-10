
project  "sudoku_lib"
language "C++"
kind     "StaticLib"

files{"../include/sudoku_lib/**.hpp",
      "../src/**pp",
      "../src/**.lua"}
      
headerLinks{"boost"}

links{"lua_library", "sqlite"}

onLink(function()

   includedirs{"../include"}
end)

includedirs{"../bin"}

luapath = "../../../src/worker/lua"

-- The order of these files is important
luafiles = {luapath .. "/disable_require.lua",
            luapath .. "/submodule.lua",
            luapath .. "/square.lua",
            luapath .. "/iterators.lua",
            luapath .. "/grid.lua",
            luapath .. "/deductions.lua",
            luapath .. "/solvers.lua",
            luapath .. "/interop.lua",
            luapath .. "/enable_require.lua"}

luabytecode = "../../../bin/sudoku.bytecode"

preBuild("lua_compiler",
         "-s -o " .. luabytecode .. " "
         .. table.concat(luafiles, " "))

preBuild("bin2c", "-c " .. luabytecode ..
                    " " .. luabytecode .. ".c")