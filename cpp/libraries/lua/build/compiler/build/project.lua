
project  "lua_compiler"
language "C"
kind     "ConsoleApp"

local luaPath = "../../../src/src"

files{luaPath .. "/luac.c",
      luaPath .. "/print.c"}

links{"lua_library"}