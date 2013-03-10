
project  "lua_library"
language "C"
kind     "StaticLib"

local luaPath = "../../../src"

files    {luaPath .. "/src/*.h",
          luaPath .. "/src/*.c"}
excludes {luaPath .. "/src/lua.*",
          luaPath .. "/src/luac.c",
          luaPath .. "/src/print.c"}

if not os.is "windows" then

   links{"m"}
end

onLink(function()

   includedirs{luaPath .. "/src",
               luaPath .. "/etc"}
end)