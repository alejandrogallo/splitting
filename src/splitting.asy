/*******************/
/* MAIN PARAMETERS */
/*******************/

string SPLITTING_TITLE = "128";

string UNEXCITED_TITLE = "A";
real UNEXCITED_VALUE_x   = 861.633166667   ;
string UNEXCITED_LABEL_x  = "$x$ ";
real UNEXCITED_VALUE_y   = 130.272166667   ;
string UNEXCITED_LABEL_y  = "$y$ ";
real UNEXCITED_VALUE_z   = -991.905333333   ;
string UNEXCITED_LABEL_z  = "$z$ ";

string EXCITED_TITLE = "C";
real EXCITED_VALUE_x     = 1008.983     ;
string EXCITED_LABEL_x    = "$x$   ";
real EXCITED_VALUE_y     = -184.719     ;
string EXCITED_LABEL_y    = "$y$   ";
real EXCITED_VALUE_z     = -824.264     ;
string EXCITED_LABEL_z    = "$z$   ";


real[] ALL_VALUES={ UNEXCITED_VALUE_x, UNEXCITED_VALUE_y, UNEXCITED_VALUE_z, EXCITED_VALUE_x, EXCITED_VALUE_y, EXCITED_VALUE_z};
real mi, ma, MIN, MAX;

mi = min(ALL_VALUES);
ma = max(ALL_VALUES);
if ( mi<0 ) {
  MAX = max(abs(mi), abs(ma));
  MIN = -MAX;
} else {
  MAX = ma;
  MIN = mi;
}

//size(5cm,5cm);
unitsize(.2cm);


struct state {
  real energy;
  string title;
  real value;
  real VB          = MIN;
  real LB          = MAX;
  real DASH_WIDTH  = 25;
  real DASH_HEIGHT = 1;
  real X_COORD     = 25;
  string label_orientation = "right";
  real getPlottingValue ( ){
    real val = 100*(energy - VB)/(LB-VB);
    return val;
  };
  void init(real e, string l){
    energy = e;
    title = l;
    value = getPlottingValue();
  };
  pair getMiddlePoint (  ){
    real x,y;
    x = X_COORD+(DASH_WIDTH)/2;
    y = value + (DASH_HEIGHT)/2;
    return (x,y);
  };
  void draw (){
    filldraw(box((X_COORD,value),(X_COORD+DASH_WIDTH,value+DASH_HEIGHT)),red);
    if ( label_orientation == "right" ) {
      label(title, (X_COORD+DASH_WIDTH,value), E);
    } else {
      label(title, (X_COORD,value), W);
    }
  };
};
struct states {
  state[] states;
  string title     = "";
  pair getMiddlePoint (  ){
    real x,y;
    real[] Y,X;
    pair middle_point;
    for ( state s : states ) {
      middle_point = s.getMiddlePoint();
      Y.push(middle_point.y);
      X.push(middle_point.x);
    };
    x = sum(X)/X.length;
    y = sum(Y)/Y.length;
    return (x,y);
  };
  void setX ( real x ){
    for ( state s : states ) {
      s.X_COORD = x;
    }
  };
  void draw (){
    for ( state s : states ) {
      s.draw();
    }
  };
};
void draw_distance ( state s, state t , real label_offset=0){
  pair mid1, mid2;
  real energy;
  energy = abs(s.energy - t.energy);
  mid1 = s.getMiddlePoint();
  mid2 = t.getMiddlePoint();
  path p = (mid1.x, mid1.y)--(mid1.x,mid2.y);
  draw(p, 0.5*white+dashed, Arrows());
  label((string)energy, (mid1.x, label_offset+(mid1.y+mid2.y)/2), Fill(white));
};


draw((0,50)--(100,50),dashed+0.5*white);
state CENTER;
CENTER.value = 50;

state unex_state1, unex_state2, unex_state3;
states unexcited_triplet;
state[] unex_group       = {unex_state1, unex_state2, unex_state3};
unex_state1.init(UNEXCITED_VALUE_x, UNEXCITED_LABEL_x);
unex_state2.init(UNEXCITED_VALUE_y, UNEXCITED_LABEL_y);
unex_state3.init(UNEXCITED_VALUE_z, UNEXCITED_LABEL_z);
unex_state1.label_orientation = "right";
unex_state2.label_orientation = "left";
unexcited_triplet.states = unex_group;
unexcited_triplet.setX(12.5);
unexcited_triplet.draw();

//DISTANCES
CENTER.X_COORD=unex_state1.X_COORD - CENTER.DASH_WIDTH/4;
draw_distance(CENTER, unex_state1, 2);
CENTER.X_COORD=unex_state2.X_COORD + CENTER.DASH_WIDTH/4;
draw_distance(CENTER, unex_state2, -2);
CENTER.X_COORD=unex_state3.X_COORD ;
draw_distance(CENTER, unex_state3);


state ex_state1, ex_state2, ex_state3;
states excited_triplet;
state[] ex_group       = {ex_state1, ex_state2, ex_state3};
ex_state1.init(EXCITED_VALUE_x, EXCITED_LABEL_x);
ex_state2.init(EXCITED_VALUE_y, EXCITED_LABEL_y);
ex_state3.init(EXCITED_VALUE_z, EXCITED_LABEL_z);
ex_state1.label_orientation = "right";
ex_state2.label_orientation = "left";
excited_triplet.states = ex_group;
excited_triplet.setX(62.5);
excited_triplet.draw();

//DISTANCES
CENTER.X_COORD=ex_state1.X_COORD - CENTER.DASH_WIDTH/4;
draw_distance(CENTER, ex_state1, 2);
CENTER.X_COORD=ex_state2.X_COORD + CENTER.DASH_WIDTH/4;
draw_distance(CENTER, ex_state2, -2);
CENTER.X_COORD=ex_state3.X_COORD ;
draw_distance(CENTER, ex_state3);


draw(box((0,0),(100,100)), invisible);

label(SPLITTING_TITLE, (50,50), Fill(white));
label(UNEXCITED_TITLE, (12.5/2,50), Fill(white));
label(EXCITED_TITLE, (100-12.5/2,50), Fill(white));

