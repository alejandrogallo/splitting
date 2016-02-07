/*******************/
/* MAIN PARAMETERS */
/*******************/

real OBERKANTE           = 100;
real UNTERKANTE          = 0;
real IMG_WIDTH           = 100;
real KANTEN_HEIGHT       = 20;

string UNEXCITED_TITLE   = "A";
real UNEXCITED_VALUE_1   = 20;
string UNEXCITED_LABEL_1 = "$m_s = 0$";
real UNEXCITED_VALUE_2   = 22;
string UNEXCITED_LABEL_2 = "$m_s = 1$";
real UNEXCITED_VALUE_3   = 28;
string UNEXCITED_LABEL_3 = "$m_s = -1$";

string EXCITED_TITLE     = "C";
real EXCITED_VALUE_1     = 51;
string EXCITED_LABEL_1   = "$m_s = 0$";
real EXCITED_VALUE_2     = 56;
string EXCITED_LABEL_2   = "$m_s = 1$";
real EXCITED_VALUE_3     = 59;
string EXCITED_LABEL_3   = "$m_s = -1$";

//size(5cm,5cm);
unitsize(.2cm);


struct state {
  real value;
  string label;
  real DASH_WIDTH  = 50;
  real DASH_HEIGHT = 1;
  real X_COORD     = 10;
  pair getMiddlePoint (  ){
    real x,y;
    x = X_COORD+(DASH_WIDTH)/2;
    y = value + (DASH_HEIGHT)/2;
    return (x,y);
  };
  void draw (){
    filldraw(box((X_COORD,value),(X_COORD+DASH_WIDTH,value+DASH_HEIGHT)),red);
    label(label, (X_COORD+DASH_WIDTH,value), E);
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
  void draw (){
    for ( state s : states ) {
      s.draw();
    }
  };
};


state unex_state1, unex_state2, unex_state3;
state[] unex_group = {unex_state1, unex_state2, unex_state3};
states unexcited_triplet;
unex_state1.value = UNEXCITED_VALUE_1;
unex_state1.label = UNEXCITED_LABEL_1;
unex_state2.value = UNEXCITED_VALUE_2;
unex_state2.label = UNEXCITED_LABEL_2;
unex_state3.value = UNEXCITED_VALUE_3;
unex_state3.label = UNEXCITED_LABEL_3;
unexcited_triplet.states = unex_group;


state ex_state1, ex_state2, ex_state3;
state[] ex_group = {ex_state1, ex_state2, ex_state3};
states excited_triplet;
ex_state1.value = EXCITED_VALUE_1;
ex_state1.label = EXCITED_LABEL_1;
ex_state2.value = EXCITED_VALUE_2;
ex_state2.label = EXCITED_LABEL_2;
ex_state3.value = EXCITED_VALUE_3;
ex_state3.label = EXCITED_LABEL_3;
excited_triplet.states = ex_group;


states[] all_states = {unexcited_triplet, excited_triplet};
for ( states group : all_states ) {
  group.draw();
  //for ( state s : group.states ) {
    //dot(s.getMiddlePoint());
  //}
  //dot(group.getMiddlePoint());
}


label("Leitungsband", (IMG_WIDTH/2, OBERKANTE+(KANTEN_HEIGHT)/2));
label("Valenzband", (IMG_WIDTH/2, (UNTERKANTE-KANTEN_HEIGHT)/2));

path UNTERKANTE_BOX = box((0,UNTERKANTE), (IMG_WIDTH, UNTERKANTE - KANTEN_HEIGHT));
path OBERKANTE_BOX  = box((0,OBERKANTE), (IMG_WIDTH,  OBERKANTE + KANTEN_HEIGHT));

filldraw(OBERKANTE_BOX, .5*white);
filldraw(UNTERKANTE_BOX, .5*white);



