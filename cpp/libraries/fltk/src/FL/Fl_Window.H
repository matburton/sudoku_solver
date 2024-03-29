//
// "$Id: Fl_Window.H 6841 2009-08-03 06:26:32Z AlbrechtS $"
//
// Window header file for the Fast Light Tool Kit (FLTK).
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

/* \file
   Fl_Window widget . */

#ifndef Fl_Window_H
#define Fl_Window_H

#include "Fl_Group.H"

#define FL_WINDOW 0xF0		///< window type id all subclasses have type() >= this
#define FL_DOUBLE_WINDOW 0xF1   ///< double window type id

class Fl_X;

/**
  This widget produces an actual window.  This can either be a main
  window, with a border and title and all the window management controls,
  or a "subwindow" inside a window.  This is controlled by whether or not
  the window has a parent().
  <P>Once you create a window, you usually add children Fl_Widget
  's to it by using window-&gt;add(child) for each new widget.  See Fl_Group for more information
  on how to add and remove children. </P>
  <P>There are several subclasses of Fl_Window that provide
  double-buffering, overlay, menu, and OpenGL support. </P>
  <P>The window's callback is done if the user tries to close a window
  using the window manager and 
  Fl::modal() is zero or equal to the window. Fl_Window
  has a default callback that calls Fl_Window::hide().
*/
class FL_EXPORT Fl_Window : public Fl_Group {

  friend class Fl_X;
  Fl_X *i; // points at the system-specific stuff

  const char* iconlabel_;
  const char* xclass_;
  const void* icon_;
  // size_range stuff:
  int minw, minh, maxw, maxh;
  int dw, dh, aspect;
  uchar size_range_set;
  // cursor stuff
  Fl_Cursor cursor_default;
  Fl_Color cursor_fg, cursor_bg;
  void size_range_();
  // values for flags():
  enum {
    FL_MODAL = 64,
    FL_NOBORDER = 8,
    FL_FORCE_POSITION = 16,
    FL_NON_MODAL = 32,
    FL_OVERRIDE = 256,
    FL_MENU_WINDOW = 4096,
    FL_TOOLTIP_WINDOW = 8192
  };
  void _Fl_Window(); // constructor innards

  // unimplemented copy ctor and assignment operator
  Fl_Window(const Fl_Window&);
  Fl_Window& operator=(const Fl_Window&);

protected:

 /**  Stores the last window that was made current. See current() const */
  static Fl_Window *current_;
  virtual void draw();
  /** Forces the window to be drawn, this window is also made current and calls draw(). */
  virtual void flush();

public:

  /**
    Creates a window from the given size and title. 
    If Fl_Group::current() is not NULL, the window is created as a 
    subwindow of the parent window.</p>
    
    <p>The first form of the constructor creates a top-level window
    and asks the window manager to position the window. The second
    form of the constructor either creates a subwindow or a
    top-level window at the specified location (x,y) , subject to window
    manager configuration. If you do not specify the position of the
    window, the window manager will pick a place to show the window
    or allow the user to pick a location. Use position(x,y)
    or hotspot() before calling show() to request a
    position on the screen. See Fl_Window::resize() 
    for some more details on positioning windows.</p>
    
    <p>Top-level windows initially have visible() set to 0
    and parent() set to NULL. Subwindows initially
    have visible() set to 1 and parent() set to
    the parent window pointer.</p>
    
    <P>Fl_Widget::box() defaults to FL_FLAT_BOX. If you
    plan to completely fill the window with children widgets you should
    change this to FL_NO_BOX. If you turn the window border off
    you may want to change this to FL_UP_BOX.
  */
    Fl_Window(int w, int h, const char* title= 0);
  /** Creates a window from the given position, size and title. 
    See Fl_Window::Fl_Window(int w, int h, const char *title = 0)
  */
    Fl_Window(int x, int y, int w, int h, const char* title = 0);
  /**
    The destructor <I>also deletes all the children</I>. This allows a
    whole tree to be deleted at once, without having to keep a pointer to
    all the children in the user code. A kludge has been done so the 
    Fl_Window and all of it's children can be automatic (local)
    variables, but you must declare the Fl_Window <I>first</I> so
    that it is destroyed last.
  */
    virtual ~Fl_Window();

  virtual int handle(int);

  /**
    Changes the size and position of the window.  If shown() is
    true, these changes are communicated to the window server (which may
    refuse that size and cause a further resize).  If shown() is
    false, the size and position are used when show() is called.
    See Fl_Group for the effect
    of resizing on the child widgets.
    <P>You can also call the Fl_Widget methods size(x,y)
    and position(w,h), which are inline wrappers for this virtual
    function. </P>
    <P>A top-level window can not force, but merely suggest a position and 
    size to the operating system. The window manager may not be willing or 
    able to display a window at the desired position or with the given 
    dimensions. It is up to the application developer to verify window 
    parameters after the resize request.
  */
  virtual void resize(int,int,int,int);
  /**
    Gets or sets whether or not the window manager border is around the
    window.  The default value is true. border(n) can be used to
    turn the border on and off, and returns non-zero if the value has been
    changed. <I>Under most X window managers this does not work after 
    show() has been called, although SGI's 4DWM does work.</I>
  */
  void border(int b);
  /**
    Fast inline function to turn the border
    off. It only works before show() is called.
  */
  void clear_border()	{set_flag(FL_NOBORDER);}
  /** See int Fl_Window::border(int) */
  int border() const	{return !(flags() & FL_NOBORDER);}
  /** Activate the flags FL_NOBORDER|FL_OVERRIDE */
  void set_override()	{set_flag(FL_NOBORDER|FL_OVERRIDE);}
  /** Returns non zero if FL_OVERRIDE flag is set, 0 otherwise. */
  int override() const  { return flags()&FL_OVERRIDE; }
  /**
    A "modal" window, when shown(), will prevent any events from
    being delivered to other windows in the same program, and will also
    remain on top of the other windows (if the X window manager supports
    the "transient for" property).  Several modal windows may be shown at
    once, in which case only the last one shown gets events.  You can see
    which window (if any) is modal by calling 
    Fl::modal().
  */
  void set_modal()	{set_flag(FL_MODAL);}
  /**  Returns true if this window is modal.  */
  int modal() const	{return flags() & FL_MODAL;}
  /**
    A "non-modal" window (terminology borrowed from Microsoft Windows)
    acts like a modal() one in that it remains on top, but it has
    no effect on event delivery.  There are <I>three</I> states for a
    window: modal, non-modal, and normal.
  */
  void set_non_modal()	{set_flag(FL_NON_MODAL);}
  /**  Returns true if this window is modal or non-modal. */
  int non_modal() const {return flags() & (FL_NON_MODAL|FL_MODAL);}

  /**
    Marks the window as a menu window.
    
    This is intended for internal use, but it can also be used if you
    write your own menu handling. However, this is not recommended.

    This flag is used for correct "parenting" of windows in communication
    with the windowing system. Modern X window managers can use different
    flags to distinguish menu and tooltip windows from normal windows.
    
    This must be called before the window is shown and cannot be changed
    later.
  */
  void set_menu_window()	{set_flag(FL_MENU_WINDOW);}

  /**  Returns true if this window is a menu window. */
  int menu_window() const {return flags() & FL_MENU_WINDOW;}

  /**
    Marks the window as a tooltip window.
    
    This is intended for internal use, but it can also be used if you
    write your own tooltip handling. However, this is not recommended.

    This flag is used for correct "parenting" of windows in communication
    with the windowing system. Modern X window managers can use different
    flags to distinguish menu and tooltip windows from normal windows.
    
    This must be called before the window is shown and cannot be changed
    later.

    \note Since Fl_Tooltip_Window is derived from Fl_Menu_Window, this
    also \b clears the menu_window() state.
  */
  void set_tooltip_window()	{ set_flag(FL_TOOLTIP_WINDOW);
				  clear_flag(FL_MENU_WINDOW); }
  /**  Returns true if this window is a tooltip window. */
  int tooltip_window() const {return flags() & FL_TOOLTIP_WINDOW;}

  /**
    Position the window so that the mouse is pointing at the
    given position, or at the center of the given widget, which may be the
    window itself.  If the optional offscreen parameter is
    non-zero, then the window is allowed to extend off the screen (this
    does not work with some X window managers). \see position()
  */
  void hotspot(int x, int y, int offscreen = 0);
  /** See void Fl_Window::hotspot(int x, int y, int offscreen = 0) */
  void hotspot(const Fl_Widget*, int offscreen = 0);
  /** See void Fl_Window::hotspot(int x, int y, int offscreen = 0) */
  void hotspot(const Fl_Widget& p, int offscreen = 0) {hotspot(&p,offscreen);}
  /**
    Undoes the effect of a previous resize() or show()
    so that the next time show() is called the window manager is
    free to position the window.
  */
  void free_position()	{clear_flag(FL_FORCE_POSITION);}
  /**
    Set the allowable range the user can resize this window to.  This only
    works for top-level windows.
    <UL>
    <LI>minw and minh are the smallest the window  can
    be. Either value must be greater than 0.</LI>
    <LI>maxw and maxh are the largest the window  can be.
    If either is <I>equal</I> to the minimum then you  cannot resize in
    that direction.  If either is zero  then FLTK picks a maximum size in
    that direction such that the  window will fill the screen. </LI>
    <LI>dw and dh are size increments.  The  window will
    be constrained to widths of minw + N * dw,  where N
    is any non-negative integer.  If these are  less or equal to 1 they
    are ignored.  (this is ignored on WIN32)</LI>
    <LI>aspect is a flag that indicates that the window should
    preserve it's aspect ratio.  This only works if both the maximum and
    minimum have the same aspect ratio.  (ignored on WIN32 and by many X
    window managers)</LI>
    </UL>
    If this function is not called, FLTK tries to figure out the range
    from the setting of resizable():
    <UL>
    <LI>If resizable() is NULL (this is the  default)
    then the window cannot be resized and the resize  border and max-size
    control will not be displayed for the  window. </LI>
    <LI>If either dimension of resizable() is less than  100,
    then that is considered the minimum size.  Otherwise the 
    resizable() has a minimum size of 100. </LI>
    <LI>If either dimension of resizable() is zero, then  that is
    also the maximum size (so the window cannot resize in  that direction). </LI>
    </UL>
    It is undefined what happens if the current size does not fit in the
    constraints passed to size_range().
  */
  void size_range(int a, int b, int c=0, int d=0, int e=0, int f=0, int g=0) {
    minw=a; minh=b; maxw=c; maxh=d; dw=e; dh=f; aspect=g; size_range_();}

  /** See void Fl_Window::label(const char*)   */
  const char* label() const	{return Fl_Widget::label();}
  /**  See void Fl_Window::iconlabel(const char*)   */
  const char* iconlabel() const	{return iconlabel_;}
  /** Sets the window title bar label.  */
  void label(const char*);
  /** Sets the icon label. */
  void iconlabel(const char*);
  /** Gets or sets the icon label. */
  void label(const char* label, const char* iconlabel); // platform dependent 
  void copy_label(const char* a);
  /** See void Fl_Window::xclass(const char*) */
  const char* xclass() const	{return xclass_;}
  /**
    A string used to tell the system what type of window this is. Mostly
    this identifies the picture to draw in the icon. <I>Under X, this is
    turned into a XA_WM_CLASS pair by truncating at the first
    non-alphanumeric character and capitalizing the first character, and
    the second one if the first is 'x'.  Thus "foo" turns into "foo, Foo",
    and "xprog.1" turns into "xprog, XProg".</I> This only works if called <I>
    before</I> calling show().
    <P>Under Microsoft Windows this string is used as the name of the
    WNDCLASS structure, though it is not clear if this can have any
    visible effect. The passed pointer is stored unchanged. The string 
    is not copied.
  */
  void xclass(const char* c)	{xclass_ = c;}
  /** Gets the current icon window target dependent data */
  const void* icon() const	{return icon_;}
  /** Sets the current icon window target dependent data */
  void icon(const void * ic)	{icon_ = ic;}

  /**
    Returns non-zero if show() has been called (but not hide()
    ). You can tell if a window is iconified with (w-&gt;shown()
    &!w-&gt;visible()).
  */
  int shown() {return i != 0;}
  /**
    Put the window on the screen.  Usually this has the side effect of
    opening the display. The second form is used for top-level
    windows and allow standard arguments to be parsed from the
    command-line.
    <P>If the window is already shown then it is restored and raised to the
    top.  This is really convenient because your program can call show()
    at any time, even if the window is already up.  It also means that 
    show() serves the purpose of raise() in other toolkits.
  */
  virtual void show();
  /**
    Remove the window from the screen.  If the window is already hidden or
    has not been shown then this does nothing and is harmless.
  */
  virtual void hide();
  /**
    See virtual void Fl_Window::show() 
  */
  void show(int, char**);
  /**
    Makes the window completely fill the screen, without any window
    manager border visible.  You must use fullscreen_off() to undo
    this. This may not work with all window managers.
  */
  void fullscreen();
  /**
    Turns off any side effects of fullscreen() and does 
    resize(x,y,w,h).
  */
  void fullscreen_off(int,int,int,int);
  /**
    Iconifies the window.  If you call this when shown() is false
    it will show() it as an icon.  If the window is already
    iconified this does nothing.
    <P>Call show() to restore the window. </P>
    <P>When a window is iconified/restored (either by these calls or by the
    user) the handle() method is called with FL_HIDE and 
    FL_SHOW events and visible() is turned on and off. </P>
    <P>There is no way to control what is drawn in the icon except with the
    string passed to Fl_Window::xclass().  You should not rely on
    window managers displaying the icons.
  */
  void iconize();

  int x_root() const ;
  int y_root() const ;

 static Fl_Window *current();
  /**
    Sets things up so that the drawing functions in &lt;FL/fl_draw.H&gt; will go into this
    window. This is useful for incremental update of windows, such as in an
    idle callback, which will make your program behave much better if it
    draws a slow graphic. <B>Danger: incremental update is very hard to
    debug and maintain!</B>
    <P>This method only works for the Fl_Window and 
    Fl_Gl_Window derived classes.
  */
  void make_current();

  // for back-compatibility only:
  /**
    Changes the cursor for this window.  This always calls the system, if
    you are changing the cursor a lot you may want to keep track of how
    you set it in a static varaible and call this only if the new cursor
    is different. 

    <P>The type Fl_Cursor is an enumeration defined in  &lt;Enumerations.H&gt;.
    (Under X you can get any XC_cursor value by passing 
    Fl_Cursor((XC_foo/2)+1)).  The colors only work on X, they are
    not implemented on WIN32.
    <P> For back compatibility only. 
  */
  void cursor(Fl_Cursor, Fl_Color=FL_BLACK, Fl_Color=FL_WHITE); // platform dependent
  void default_cursor(Fl_Cursor, Fl_Color=FL_BLACK, Fl_Color=FL_WHITE);
  static void default_callback(Fl_Window*, void* v);

};

#endif

//
// End of "$Id: Fl_Window.H 6841 2009-08-03 06:26:32Z AlbrechtS $".
//
