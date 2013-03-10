
project  "fltk"
language "C++"
kind     "StaticLib"

local src = "../../../src"

files{src .. "/FL/*.H",
      src .. "/src/*.cxx",
      src .. "/src/*.c"}

excludes{src .. "/src/fl_color_mac.cxx",
         src .. "/src/fl_dnd_mac.cxx",
         src .. "/src/fl_dnd_x.cxx",
         src .. "/src/fl_draw_image_mac.cxx",
         src .. "/src/fl_font_mac.cxx",
         src .. "/src/fl_font_win32.cxx",
         src .. "/src/fl_font_x.cxx",
         src .. "/src/fl_font_xft.cxx",
         src .. "/src/Fl_get_key_mac.cxx",
         src .. "/src/Fl_mac.cxx",
         src .. "/src/fl_read_image_mac.cxx",
         src .. "/src/fl_read_image_win32.cxx",
         src .. "/src/fl_set_fonts_mac.cxx",
         src .. "/src/fl_set_fonts_win32.cxx",
         src .. "/src/fl_set_fonts_x.cxx",
         src .. "/src/fl_set_fonts_xft.cxx",
         src .. "/src/Fl_win32.cxx",
         src .. "/src/scandir_win32.c",
         src .. "/src/Fl_get_key_win32.cxx",
         src .. "/src/fl_draw_image_win32.cxx",
         src .. "/src/fl_dnd_win32.cxx",
         src .. "/src/fl_color_win32.cxx",
         src .. "/src/cmap.cxx",
         src .. "/src/dump_compose.c"}

headerLinks{"fltk_xutf8"}

if os.is "windows" then

   links{"comctl32"}

else

   links{"Xft", "Xinerama", "X11"}

   includedirs{"/usr/include/freetype2"}
end

onLink(function()

   if os.is "windows" then

      defines{"WIN32",
              "_CRT_SECURE_NO_DEPRECATE",
              "_WINDOWS",
              "WIN32_LEAN_AND_MEAN",
              "VC_EXTRA_LEAN",
              "WIN32_EXTRA_LEAN"}

      includedirs{src .. "/zlib",
                  src .. "/png",
                  src .. "/jpeg"}
   end
end)