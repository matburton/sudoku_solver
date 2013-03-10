
project  "sqlite"
language "C"
kind     "StaticLib"
files    {"../src/*.h",
          "../src/*.c"}
excludes {"../src/shell.c"}
defines  {"SQLITE_OMIT_LOAD_EXTENSION=1"}

onLink(function()

   defines{"SQLITE_THREADSAFE=0"}

   includedirs{"../src"}
end)