/*******************/
/* MAIN PARAMETERS */
/*******************/

import graph;
import resources;

string ABCD_TITLE = "A-B-C-D 128";

real A_ENERGIE = -1120.67114704;
real B_ENERGIE = -1119.06633370;
real C_ENERGIE = -1119.28629462;
real D_ENERGIE = -1120.47021189;

real[] ENERGIES={A_ENERGIE, B_ENERGIE, C_ENERGIE, D_ENERGIE};

MAX = max(ENERGIES);
MIN = min(ENERGIES);

size(10cm,10cm);
//unitsize(.2cm);



struct potential_well {
  pair bottom;
  real width;
  real height;
  pair value ( real r ){
    //Here t goes from x to 100
    real a = height*(4/width**2);
    real y = a*(r - bottom.x)**2 + bottom.y;
    return (r,y);
  };
  real getParam ( real y ){
    if ( y<bottom.y || y> bottom.y + height ) {
      write("ERROR: Energy out of range!");
      return -1;
    } else {
      real a = height*(4/width**2);
      return sqrt((y-bottom.y)/a)+bottom.x;
    }
  };
  path getPath (  ){
    return graph(value, bottom.x - width/2, bottom.x + width/2);
  };
  void draw_vibronic ( real energy , pen style=black){
    real x = getParam(energy);
    if ( x!=-1 ) {
      path g = (2*bottom.x-x, energy)--(x, energy);
      draw(g, style);
    }
  };
  void draw_vibronic_between( state s, state t, int number , pen style=black) {
    real bottom = min(s.getMiddlePoint().y, t.getMiddlePoint().y);
    real delta = abs(s.getMiddlePoint().y - t.getMiddlePoint().y )/number;
    for ( int i = 1; i < number; i+=1 ) {
      real energy = bottom + delta*i;
      write("Drawing vibronic at "+string(energy));
      draw_vibronic(energy, style);
    }
  };
  void draw ( ){
    draw(getPath());
  };
};



/*******************/
/* DRAW DECORATION */
/*******************/

real pointsToEnergy ( real point ){
  return (MAX-MIN)*point/100 + MIN;
};

//label(ABCD_TITLE, (30, 50), 0.8*blue);



/***************/
/* DRAW STATES */
/***************/


//state definitions
state A, B, C, D;

A.init(A_ENERGIE, 0, "A");
A.X_COORD=0*A.DASH_WIDTH;

B.init(B_ENERGIE, 0, "B");
B.X_COORD=1*B.DASH_WIDTH;

C.init(C_ENERGIE, 0, "C");
C.X_COORD = 1*C.DASH_WIDTH;

D.init(D_ENERGIE, 0, "D");
D.X_COORD = 0*D.DASH_WIDTH;


/////////////////////
//  DRAW Potentials
/////////////////////

potential_well potential_left;
potential_left.width=40.0;
potential_left.height=(D.getMiddlePoint()-A.getMiddlePoint()).y+10;
potential_left.bottom=A.getMiddlePoint()-(0,5);

potential_left.draw();

potential_left.draw_vibronic(A.getMiddlePoint().y);
potential_left.draw_vibronic(D.getMiddlePoint().y);

potential_well potential_right;
potential_right.width=40.0;
potential_right.height=(B.getMiddlePoint()-C.getMiddlePoint()).y+10;
potential_right.bottom=C.getMiddlePoint()-(0,5);

potential_right.draw();

potential_right.draw_vibronic(B.getMiddlePoint().y);
potential_right.draw_vibronic(C.getMiddlePoint().y);

A.draw(draw_state=false);
B.draw(draw_state=false);
C.draw(draw_state=false);
D.draw(draw_state=false);

potential_left.draw_vibronic_between(A,D,2, white*0.8);
potential_right.draw_vibronic_between(C,B,2, white*0.8);


draw_distance(A,B, lbl_y_offset=20);
draw_distance(C,D, lbl_y_offset=10);
draw_distance(B,C, x_offset=B.DASH_WIDTH/2.1, pre_lbl="\it S = ");
draw_distance(D,A, x_offset = -10, pre_lbl="\it AS = ");
draw_distance(A,C, x_offset=A.DASH_WIDTH/2, pre_lbl="\it ZPL = ");
