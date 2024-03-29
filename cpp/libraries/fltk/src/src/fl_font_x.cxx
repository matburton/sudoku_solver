//
// "$Id: fl_font_x.cxx 6779 2009-04-24 09:28:30Z yuri $"
//
// Standard X11 font selection code for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2009 by Bill Spitzak and others.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA.
//
// Please report all bugs and problems on the following page:
//
//     http://www.fltk.org/str.php
//
#ifndef FL_DOXYGEN

Fl_Font_Descriptor::Fl_Font_Descriptor(const char* name) {
  font = XCreateUtf8FontStruct(fl_display, name);
  if (!font) {
    Fl::warning("bad font: %s", name);
    font = XCreateUtf8FontStruct(fl_display, "fixed");
  }
#  if HAVE_GL
  listbase = 0;
  for (int u = 0; u < 64; u++) glok[u] = 0;
#  endif
}

Fl_Font_Descriptor* fl_fontsize;

Fl_Font_Descriptor::~Fl_Font_Descriptor() {
#  if HAVE_GL
// Delete list created by gl_draw().  This is not done by this code
// as it will link in GL unnecessarily.  There should be some kind
// of "free" routine pointer, or a subclass?
// if (listbase) {
//  int base = font->min_char_or_byte2;
//  int size = font->max_char_or_byte2-base+1;
//  int base = 0; int size = 256;
//  glDeleteLists(listbase+base,size);
// }
#  endif
  if (this == fl_fontsize) fl_fontsize = 0;
  XFreeUtf8FontStruct(fl_display, font);
}

////////////////////////////////////////////////////////////////

// WARNING: if you add to this table, you must redefine FL_FREE_FONT
// in Enumerations.H & recompile!!
static Fl_Fontdesc built_in_table[] = {
{"-*-helvetica-medium-r-normal--*"},
{"-*-helvetica-bold-r-normal--*"},
{"-*-helvetica-medium-o-normal--*"},
{"-*-helvetica-bold-o-normal--*"},
{"-*-courier-medium-r-normal--*"},
{"-*-courier-bold-r-normal--*"},
{"-*-courier-medium-o-normal--*"},
{"-*-courier-bold-o-normal--*"},
{"-*-times-medium-r-normal--*"},
{"-*-times-bold-r-normal--*"},
{"-*-times-medium-i-normal--*"},
{"-*-times-bold-i-normal--*"},
{"-*-symbol-*"},
{"-*-lucidatypewriter-medium-r-normal-sans-*"},
{"-*-lucidatypewriter-bold-r-normal-sans-*"},
{"-*-*zapf dingbats-*"}
};

Fl_Fontdesc* fl_fonts = built_in_table;

#define MAXSIZE 32767

// return dash number N, or pointer to ending null if none:
const char* fl_font_word(const char* p, int n) {
  while (*p) {if (*p=='-') {if (!--n) break;} p++;}
  return p;
}

// return a pointer to a number we think is "point size":
char* fl_find_fontsize(char* name) {
  char* c = name;
  // for standard x font names, try after 7th dash:
  if (*c == '-') {
    c = (char*)fl_font_word(c,7);
    if (*c++ && isdigit(*c)) return c;
    return 0; // malformed x font name?
  }
  char* r = 0;
  // find last set of digits:
  for (c++;* c; c++)
    if (isdigit(*c) && !isdigit(*(c-1))) r = c;
  return r;
}

const char* fl_encoding = "iso8859-1";

// return true if this matches fl_encoding:
int fl_correct_encoding(const char* name) {
  if (*name != '-') return 0;
  const char* c = fl_font_word(name,13);
  return (*c++ && !strcmp(c,fl_encoding));
}

static const char *find_best_font(const char *fname, int size) {
  int cnt;
  static char **list = NULL;
// locate or create an Fl_Font_Descriptor for a given Fl_Fontdesc and size:
  if (list) XFreeFontNames(list);
  list = XListFonts(fl_display, fname, 100, &cnt);
  if (!list) return "fixed";

  // search for largest <= font size:
  char* name = list[0]; int ptsize = 0;     // best one found so far
  int matchedlength = 32767;
  char namebuffer[1024];        // holds scalable font name
  int found_encoding = 0;
  int m = cnt; if (m<0) m = -m;
  for (int n=0; n < m; n++) {
    char* thisname = list[n];
    if (fl_correct_encoding(thisname)) {
      if (!found_encoding) ptsize = 0; // force it to choose this
      found_encoding = 1;
    } else {
      if (found_encoding) continue;
    }
    char* c = (char*)fl_find_fontsize(thisname);
    int thissize = c ? atoi(c) : MAXSIZE;
    int thislength = strlen(thisname);
    if (thissize == size && thislength < matchedlength) {
      // exact match, use it:
      name = thisname;
      ptsize = size;
      matchedlength = thislength;
    } else if (!thissize && ptsize!=size) {
      // whoa!  A scalable font!  Use unless exact match found:
      int l = c-thisname;
      memcpy(namebuffer,thisname,l);
      l += sprintf(namebuffer+l,"%d",size);
      while (*c == '0') c++;
      strcpy(namebuffer+l,c);
      name = namebuffer;
      ptsize = size;
    } else if (!ptsize ||	// no fonts yet
	       thissize < ptsize && ptsize > size || // current font too big
	       thissize > ptsize && thissize <= size // current too small
      ) {
      name = thisname;
      ptsize = thissize;
      matchedlength = thislength;
    }
  }

//  if (ptsize != size) { // see if we already found this unscalable font:
//    for (f = s->first; f; f = f->next) {
//      if (f->minsize <= ptsize && f->maxsize >= ptsize) {
//	if (f->minsize > size) f->minsize = size;
//	if (f->maxsize < size) f->maxsize = size;
//	return f;
//      }
//    }
//  }
//
//  // okay, we definately have some name, make the font:
//  f = new Fl_Font_Descriptor(name);
//  if (ptsize < size) {f->minsize = ptsize; f->maxsize = size;}
//  else {f->minsize = size; f->maxsize = ptsize;}
//  f->next = s->first;
//  s->first = f;
//  return f;

  return name;
}

static char *put_font_size(const char *n, int size)
{
        int i = 0;
        char *buf;
        const char *ptr;
        const char *f;
        char *name;
        int nbf = 1;
        name = strdup(n);
        while (name[i]) {
                if (name[i] == ',') {nbf++; name[i] = '\0';}
                i++;
        }

        buf = (char*) malloc(nbf * 256);
        buf[0] = '\0';
        ptr = name;
        i = 0;
        while (ptr && nbf > 0) {
                f = find_best_font(ptr, size);
                while (*f) {
                        buf[i] = *f;
                        f++; i++;
                }
                nbf--;
                while (*ptr) ptr++;
                if (nbf) {
                        ptr++;
                        buf[i] = ',';
                        i++;
                }
                while(isspace(*ptr)) ptr++;
        }
        buf[i] = '\0';
        free(name);
        return buf;
}


char *fl_get_font_xfld(int fnum, int size) {
  Fl_Fontdesc* s = fl_fonts+fnum;
  if (!s->name) s = fl_fonts; // use font 0 if still undefined
  fl_open_display();
  return put_font_size(s->name, size);
}

// locate or create an Fl_Font_Descriptor for a given Fl_Fontdesc and size:
static Fl_Font_Descriptor* find(int fnum, int size) {
  char *name;
  Fl_Fontdesc* s = fl_fonts+fnum;
  if (!s->name) s = fl_fonts; // use font 0 if still undefined
  Fl_Font_Descriptor* f;
  for (f = s->first; f; f = f->next)
    if (f->minsize <= size && f->maxsize >= size) return f;
  fl_open_display();

  name = put_font_size(s->name, size);
  f = new Fl_Font_Descriptor(name);
  f->minsize = size;
  f->maxsize = size;
  f->next = s->first;
  s->first = f;
  free(name);
  return f;
}


////////////////////////////////////////////////////////////////
// Public interface:

Fl_Font fl_font_ = 0;
Fl_Fontsize fl_size_ = 0;
//XFontStruct* fl_xfont = 0;
XUtf8FontStruct* fl_xfont;
void *fl_xftfont = 0;
static GC font_gc;

void fl_font(Fl_Font fnum, Fl_Fontsize size) {
  if (fnum==-1) {
    fl_font_ = 0; fl_size_ = 0;
    return;
  }
  if (fnum == fl_font_ && size == fl_size_) return;
  fl_font_ = fnum; fl_size_ = size;
  Fl_Font_Descriptor* f = find(fnum, size);
  if (f != fl_fontsize) {
    fl_fontsize = f;
    fl_xfont = f->font;
    font_gc = 0;
  }
}

int fl_height() {
  if (fl_xfont) return (fl_xfont->ascent + fl_xfont->descent);
  else return -1;
}

int fl_descent() {
  if (fl_xfont) return fl_xfont->descent;
  else return -1;
}

double fl_width(const char* c, int n) {
  if (fl_xfont) return (double) XUtf8TextWidth(fl_xfont, c, n);
  else return -1;
}

double fl_width(unsigned int c) {
  if (fl_xfont) return (double) XUtf8UcsWidth(fl_xfont, c);
  else return -1;
}


void fl_text_extents(const char *c, int n, int &dx, int &dy, int &W, int &H) {

#if defined(__GNUC__)
#warning fl_text_extents is only a test stub in Xlib build at present
#endif /*__GNUC__*/

  W = 0; H = 0;
  fl_measure(c, W, H, 0);
  dx = 0;
  dy = fl_descent() - H;
} // fl_text_extents


void fl_draw(const char* c, int n, int x, int y) {
  if (font_gc != fl_gc) {
    if (!fl_xfont) fl_font(FL_HELVETICA, 14);
    font_gc = fl_gc;
    XSetFont(fl_display, fl_gc, fl_xfont->fid);
  }
//  XDrawString(fl_display, fl_window, fl_gc, x, y, c, n);
  XUtf8DrawString(fl_display, fl_window, fl_xfont, fl_gc, x, y, c, n);
}
void fl_draw(int angle, const char *str, int n, int x, int y) {
  fprintf(stderr,"ROTATING TEXT NOT IMPLIMENTED\n");
  fl_draw(str, n, (int)x, (int)y);
}
//void fl_draw(const char* str, int n, float x, float y) {
//  fl_draw(str, n, (int)x, (int)y);
//}

void fl_rtl_draw(const char* c, int n, int x, int y) {
  if (font_gc != fl_gc) {
    if (!fl_xfont) fl_font(FL_HELVETICA, 12);
    font_gc = fl_gc;
  }
  XUtf8DrawRtlString(fl_display, fl_window, fl_xfont, fl_gc, x, y, c, n);
}
#endif // FL_DOXYGEN
//
// End of "$Id: fl_font_x.cxx 6779 2009-04-24 09:28:30Z yuri $".
//
