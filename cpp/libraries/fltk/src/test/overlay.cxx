//
// "$Id: overlay.cxx 6615 2009-01-01 16:35:13Z matt $"
//
// Overlay window test program for the Fast Light Tool Kit (FLTK).
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

#include <stdlib.h>
#include <stdio.h>
#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Overlay_Window.H>
#include <FL/Fl_Button.H>
#include <FL/fl_draw.H>

int width=10,height=10;

class overlay : public Fl_Overlay_Window {
public:
  overlay(int w,int h) : Fl_Overlay_Window(w,h) {}
  void draw_overlay();
};

void overlay::draw_overlay() {
  fl_color(FL_RED); fl_rect((w()-width)/2,(h()-height)/2,width,height);
}

overlay *ovl;

void bcb1(Fl_Widget *,void *) {width+=20; ovl->redraw_overlay();}
void bcb2(Fl_Widget *,void *) {width-=20; ovl->redraw_overlay();}
void bcb3(Fl_Widget *,void *) {height+=20; ovl->redraw_overlay();}
void bcb4(Fl_Widget *,void *) {height-=20; ovl->redraw_overlay();}

int arg(int, char **argv, int& i) {
  Fl_Color n = (Fl_Color)atoi(argv[i]);
  if (n<=0) return 0;
  i++;
  uchar r,g,b;
  Fl::get_color(n,r,g,b);
  Fl::set_color(FL_RED,r,g,b);
  return i;
}

int main(int argc, char **argv) {
  int i=0; Fl::args(argc,argv,i,arg);
  ovl = new overlay(400,400);
  Fl_Button *b;
  b = new Fl_Button(50,50,100,100,"wider\n(a)");
  b->callback(bcb1); b->shortcut('a');
  b = new Fl_Button(250,50,100,100,"narrower\n(b)");
  b->callback(bcb2); b->shortcut('b');
  b = new Fl_Button(50,250,100,100,"taller\n(c)");
  b->callback(bcb3); b->shortcut('c');
  b = new Fl_Button(250,250,100,100,"shorter\n(d)");
  b->callback(bcb4); b->shortcut('d');
  ovl->resizable(ovl);
  ovl->end();
  ovl->show(argc,argv);
  ovl->redraw_overlay();
  return Fl::run();
}

//
// End of "$Id: overlay.cxx 6615 2009-01-01 16:35:13Z matt $".
//
