
project  "fltk_xutf8"
language "C"
kind     "StaticLib"

local src = "../../../src"

files{src .. "/src/xutf8/case.c",
      src .. "/src/xutf8/is_right2left.c",
      src .. "/src/xutf8/is_spacing.c"}

if not os.is "windows" then

   files{src .. "/src/xutf8/keysym2Ucs.c",
         src .. "/src/xutf8/utf8Input.c",
         src .. "/src/xutf8/utf8Utils.c",
         src .. "/src/xutf8/utf8Wrap.c"}
end

onLink(function()

   includedirs{src}

   if os.is "windows" then

      includedirs{src .. "/ide/vc2005"}

   else

      includedirs{"../.."}
   end
end)