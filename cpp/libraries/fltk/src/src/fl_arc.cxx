//
// "$Id: fl_arc.cxx 6716 2009-03-24 01:40:44Z fabien $"
//
// Arc functions for the Fast Light Tool Kit (FLTK).
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

/**
  \file fl_arc.cxx
  \brief Utility functions for drawing arcs and circles.
*/

// Utility for drawing arcs and circles.  They are added to
// the current fl_begin/fl_vertex/fl_end path.
// Incremental math implementation:

#include <FL/fl_draw.H>
#include <FL/math.h>

// avoid problems with some platforms that don't 
// implement hypot.
static double _fl_hypot(double x, double y) {
  return sqrt(x*x + y*y);
}

/**
  Add a series of points to the current path on the arc of a circle; you
  can get elliptical paths by using scale and rotate before calling fl_arc().
  \param[in] x,y,r center and radius of circular arc
  \param[in] start,end angles of start and end of arc measured in degrees
             counter-clockwise from 3 o'clock. If \p end is less than \p start
	     then it draws the arc in a clockwise direction.
*/
void fl_arc(double x, double y, double r, double start, double end) {

  // draw start point accurately:
  
  double A = start*(M_PI/180);		// Initial angle (radians)
  double X =  r*cos(A);			// Initial displacement, (X,Y)
  double Y = -r*sin(A);			//   from center to initial point
  fl_vertex(x+X,y+Y);			// Insert initial point

  // Maximum arc length to approximate with chord with error <= 0.125
  
  double epsilon; {
    double r1 = _fl_hypot(fl_transform_dx(r,0), // Horizontal "radius"
		          fl_transform_dy(r,0));
    double r2 = _fl_hypot(fl_transform_dx(0,r), // Vertical "radius"
		          fl_transform_dy(0,r));
		      
    if (r1 > r2) r1 = r2;		// r1 = minimum "radius"
    if (r1 < 2.) r1 = 2.;		// radius for circa 9 chords/circle
    
    epsilon = 2*acos(1.0 - 0.125/r1);	// Maximum arc angle
  }
  A = end*(M_PI/180) - A;		// Displacement angle (radians)
  int i = int(ceil(fabs(A)/epsilon));	// Segments in approximation
  
  if (i) {
    epsilon = A/i;			// Arc length for equal-size steps
    double cos_e = cos(epsilon);	// Rotation coefficients
    double sin_e = sin(epsilon);
    do {
      double Xnew =  cos_e*X + sin_e*Y;
		Y = -sin_e*X + cos_e*Y;
      fl_vertex(x + (X=Xnew), y + Y);
    } while (--i);
  }
}

#if 0 // portable version.  X-specific one in fl_vertex.cxx
void fl_circle(double x,double y,double r) {
  _fl_arc(x, y, r, r, 0, 360);
}
#endif

//
// End of "$Id: fl_arc.cxx 6716 2009-03-24 01:40:44Z fabien $".
//
