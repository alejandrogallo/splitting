/*******************/
/* MAIN PARAMETERS */
/*******************/

real ENERGIE_LB_PRISTINE  = 17230;
real ENERGIE_VB_PRISTINE  = 12300;
real ENERGIE_VB_EXCITED   = 14290;
real ENERGIE_VB_UNEXCITED = 15123;

real OBERKANTE     = 100;
real UNTERKANTE    = 0;
real IMG_WIDTH     = 100;
real KANTEN_HEIGHT = 20;

string UNEXCITED_TITLE   = "A";
real UNEXCITED_VALUE_x   = 123;
string UNEXCITED_LABEL_x = "$m_s = 1230$";
real UNEXCITED_VALUE_y   = 142;
string UNEXCITED_LABEL_y = "$m_s = 1$";
real UNEXCITED_VALUE_z   = 124;
string UNEXCITED_LABEL_z = "$m_s = -1$";

string EXCITED_TITLE     = "C";
real EXCITED_VALUE_x     = 123;
string EXCITED_LABEL_x   = "$m_s = 0$";
real EXCITED_VALUE_y     = 123;
string EXCITED_LABEL_y   = "$m_s = 1$";
real EXCITED_VALUE_z     = 523;
string EXCITED_LABEL_z   = "$m_s = -1$";

//size(5cm,5cm);
unitsize(.2cm);


struct state {
  real energy;
  string title;
  real value;
  real VB          = ENERGIE_VB_PRISTINE;
  real LB          = ENERGIE_LB_PRISTINE;
  real DASH_WIDTH  = 50;
  real DASH_HEIGHT = 1;
  real X_COORD     = 25;
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
    label(title, (X_COORD+DASH_WIDTH,value), E);
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


state unex_state1, unex_state2, unex_state3;
states unexcited_triplet;
state[] unex_group       = {unex_state1, unex_state2, unex_state3};
unex_state1.init(ENERGIE_VB_UNEXCITED+UNEXCITED_VALUE_x, UNEXCITED_LABEL_x);
unex_state2.init(ENERGIE_VB_UNEXCITED+UNEXCITED_VALUE_y, UNEXCITED_LABEL_y);
unex_state3.init(ENERGIE_VB_UNEXCITED+UNEXCITED_VALUE_z, UNEXCITED_LABEL_z);
unexcited_triplet.states = unex_group;


state ex_state1, ex_state2, ex_state3;
states excited_triplet;
state[] ex_group       = {ex_state1, ex_state2, ex_state3};
ex_state1.init(ENERGIE_VB_EXCITED+EXCITED_VALUE_x, EXCITED_LABEL_x);
ex_state2.init(ENERGIE_VB_EXCITED+EXCITED_VALUE_y, EXCITED_LABEL_y);
ex_state3.init(ENERGIE_VB_EXCITED+EXCITED_VALUE_z, EXCITED_LABEL_z);
excited_triplet.states = ex_group;


states[] all_states = {unexcited_triplet, excited_triplet};
for ( states group : all_states ) {
  group.draw();
  for ( state s : group.states ) {
    dot(s.getMiddlePoint());
    write(s.value);
  }
  dot(group.getMiddlePoint());
}


label("Leitungsband" , (IMG_WIDTH/2 , OBERKANTE+(KANTEN_HEIGHT)/2));
label("Valenzband"   , (IMG_WIDTH/2 , (UNTERKANTE-KANTEN_HEIGHT)/2));

path UNTERKANTE_BOX = box((0 , UNTERKANTE) , (IMG_WIDTH , UNTERKANTE - KANTEN_HEIGHT));
path OBERKANTE_BOX  = box((0 , OBERKANTE)  , (IMG_WIDTH , OBERKANTE + KANTEN_HEIGHT));

filldraw(OBERKANTE_BOX  , .8*white);
filldraw(UNTERKANTE_BOX , .8*white);



