
project  "swig"
language "C++"
kind     "ConsoleApp"

files{"../src/Source/**.h",
      "../src/Source/**.c",
      "../src/Source/**.cxx"}

includedirs{".",
            "../src/Source/CParse",
            "../src/Source/DOH",
            "../src/Source/Include",
            "../src/Source/Modules",
            "../src/Source/Preprocessor",
            "../src/Source/Swig"}