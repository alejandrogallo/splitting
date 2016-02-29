/*******************/
/* MAIN PARAMETERS */
/*******************/

import graph;

string ABCD_TITLE = "A-B-C-D 128";

real A_ENERGIE = -1120.67114704;
real B_ENERGIE = -1119.06633370;
real C_ENERGIE = -1119.28629462;
real D_ENERGIE = -1120.47021189;

real[] ENERGIES={A_ENERGIE, B_ENERGIE, C_ENERGIE, D_ENERGIE};

real MAX = max(ENERGIES);
real MIN = min(ENERGIES);

size(10cm,10cm);
//unitsize(.2cm);



struct state {
  real energy;
  real value;
  string title     = "";
  real spin        = 0;
  real VB          = MIN;
  real LB          = MAX;
  real DASH_WIDTH  = 25;
  real DASH_HEIGHT = 1;
  real X_COORD     = 0;
  real getPlottingValue ( ){
    real val = 100*(energy - VB)/(LB-VB);
    return val;
  };
  void init(real e, real s=0, string ttl=""){
    energy = e;
    spin   = s;
    title  = ttl;
    value  = getPlottingValue();
  };
  pair getMiddlePoint (  ){
    real x,y;
    x = X_COORD+(DASH_WIDTH)/2;
    y = value + (DASH_HEIGHT)/2;
    return (x,y);
  };
  void draw_spin(){
    pair middle = getMiddlePoint();
    path ar;
    real x_deviation = 0.25*DASH_WIDTH;
    real height = 5*DASH_HEIGHT;
    if ( spin == 1 ) {
      ar = (middle - (-x_deviation,height))..(middle + (x_deviation,height));
    } else {
      ar = (middle + (-x_deviation,height))..(middle - (x_deviation,height));
    }
    draw(ar, linewidth(1),Arrow());
  };
  void draw (bool draw_state=true, bool draw_label=true){
    if (draw_state)
      filldraw(box((X_COORD,value),(X_COORD+DASH_WIDTH,value+DASH_HEIGHT)),red);
    if (draw_label)
      label(title, (X_COORD+DASH_WIDTH,value), E, Fill(white));
    //label((string)energy, (X_COORD+DASH_WIDTH,value), E);
    if ( spin != 0 ) {
      draw_spin();
    }
  };
};

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
}



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
void draw_distance ( state s, state t , real x_offset=0, real lbl_y_offset=0, string lbl="", string pre_lbl=""){
  pair mid1, mid2;
  real energy;
  energy = abs(s.energy - t.energy);
  if ( lbl=="" ) {
    lbl = pre_lbl+format("%#.3f", energy)+" eV";
  } else {
    lbl = pre_lbl+lbl;
  }
  mid1 = s.getMiddlePoint();
  mid2 = t.getMiddlePoint();
  path p = (x_offset+mid1.x, mid1.y)--(x_offset+mid1.x,mid2.y);
  draw(p, 0.5*white+dashed, Arrows());
  label(lbl, (mid1.x + x_offset, (mid1.y+mid2.y)/2 + lbl_y_offset), Fill(white*0.9));
};



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
