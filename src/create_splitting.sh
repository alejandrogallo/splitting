#!/bin/bash

NUMBER=128
EXCITED_FOLDER=C
UNEXCITED_FOLDER=A
BANDGAP_OUTCAR="../pristine/$NUMBER/A/OUCAR"
OUTPUT_FOLDER=splitting_plot
OUTPUT_NAME=splitting_$EXCITED_FOLDER_$UNEXCITED_FOLDER

#################
#  GET BANDGAP  #
#################

#test -e $BANDGAP_OUTCAR || (echo -e "\033[0;91m$BANDGAP_OUTCAR file does not exist....\033[0m"; exit 1)

#ENERGIE_VB=$(show-me-your-electrons -g BANDGAP_OUTCAR | grep VB | cut -d " " -f 2)
#ENERGIE_LB=$(show-me-your-electrons -g BANDGAP_OUTCAR | grep LB | cut -d " " -f 2)



########################################################################
##                              SPLITTING                              #
########################################################################

#UNEXCITED_OUTCAR=$UNEXCITED_FOLDER/OUTCAR
#UNEXCITED_VALUE_x=$(d2E -f $UNEXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
#UNEXCITED_VALUE_y=$(d2E -f $UNEXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
#UNEXCITED_VALUE_z=$(d2E -f $UNEXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

#UNEXCITED_LABEL_x="\$x\$";
#UNEXCITED_LABEL_y="\$y\$";
#UNEXCITED_LABEL_z="\$z\$";

#EXCITED_OUTCAR=$EXCITED_FOLDER/OUTCAR
#EXCITED_VALUE_x=$(d2E -f $EXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
#EXCITED_VALUE_y=$(d2E -f $EXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
#EXCITED_VALUE_z=$(d2E -f $EXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

#EXCITED_LABEL_x="\$x\$";
#EXCITED_LABEL_y="\$y\$";
#EXCITED_LABEL_z="\$z\$";



ENERGIE_LB=17230;
ENERGIE_VB=12300;
UNEXCITED_TITLE="A";
UNEXCITED_VALUE_x=13000;
UNEXCITED_LABEL_x="\$m_s = 1230\$";
UNEXCITED_VALUE_y=13234;
UNEXCITED_LABEL_y="\$m_s = 1\$";
UNEXCITED_VALUE_z=13245;
UNEXCITED_LABEL_z="\$m_s = -1\$";
EXCITED_TITLE="C";
EXCITED_VALUE_x=14204;
EXCITED_LABEL_x="\$m_s = 0\$";
EXCITED_VALUE_y=14245;
EXCITED_LABEL_y="\$m_s = 1\$";
EXCITED_VALUE_z=17000;
EXCITED_LABEL_z="\$m_s = -1\$";


test -d $OUTPUT_FOLDER || mkdir $OUTPUT_FOLDER



cat > $OUTPUT_FOLDER/Makefile <<EOF
all:
asy -f pdf $OUTPUT_NAME
EOF


cat > $OUTPUT_FOLDER/$OUTPUT_NAME <<EOF
/*******************/
/* MAIN PARAMETERS */
/*******************/

real ENERGIE_LB    = $ENERGIE_LB;
real ENERGIE_VB    = $ENERGIE_VB;

real OBERKANTE     = 100;
real UNTERKANTE    = 0;
real IMG_WIDTH     = 100;
real KANTEN_HEIGHT = 20;

string UNEXCITED_TITLE   = "A";
real UNEXCITED_VALUE_x   = $UNEXCITED_VALUE_x;
string UNEXCITED_LABEL_x = "$UNEXCITED_LABEL_x";
real UNEXCITED_VALUE_y   = $UNEXCITED_VALUE_y;
string UNEXCITED_LABEL_y = "$UNEXCITED_LABEL_y";
real UNEXCITED_VALUE_z   = $UNEXCITED_VALUE_z;
string UNEXCITED_LABEL_z = "$UNEXCITED_LABEL_z";

string EXCITED_TITLE     = $EXCITED_TITLE;
real EXCITED_VALUE_x     = $EXCITED_VALUE_x;
string EXCITED_LABEL_x   = "$EXCITED_LABEL_x";
real EXCITED_VALUE_y     = $EXCITED_VALUE_y;
string EXCITED_LABEL_y   = "$EXCITED_LABEL_y";
real EXCITED_VALUE_z     = $EXCITED_VALUE_z;
string EXCITED_LABEL_z   = "$EXCITED_LABEL_z";

//size(5cm,5cm);
unitsize(.2cm);


struct state {
real energy;
string title;
real value;
real VB          = ENERGIE_VB;
real LB          = ENERGIE_LB;
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
unex_state1.init(UNEXCITED_VALUE_x, UNEXCITED_LABEL_x);
unex_state2.init(UNEXCITED_VALUE_y, UNEXCITED_LABEL_y);
unex_state3.init(UNEXCITED_VALUE_z, UNEXCITED_LABEL_z);
unexcited_triplet.states = unex_group;


state ex_state1, ex_state2, ex_state3;
states excited_triplet;
state[] ex_group       = {ex_state1, ex_state2, ex_state3};
ex_state1.init(EXCITED_VALUE_x, EXCITED_LABEL_x);
ex_state2.init(EXCITED_VALUE_y, EXCITED_LABEL_y);
ex_state3.init(EXCITED_VALUE_z, EXCITED_LABEL_z);
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
EOF
cat > $OUTPUT_FOLDER/$OUTPUT_NAME <<EOF
/*******************/
/* MAIN PARAMETERS */
/*******************/

real ENERGIE_LB    = 17230;
real ENERGIE_VB    = 12300;

real OBERKANTE     = 100;
real UNTERKANTE    = 0;
real IMG_WIDTH     = 100;
real KANTEN_HEIGHT = 20;

string UNEXCITED_TITLE   = "$UNEXCITED_TITLE  ";
real UNEXCITED_VALUE_x   =$UNEXCITED_VALUE_x   ;
string UNEXCITED_LABEL_x = "$UNEXCITED_LABEL_x";
real UNEXCITED_VALUE_y   =$UNEXCITED_VALUE_y   ;
string UNEXCITED_LABEL_y = "$UNEXCITED_LABEL_y";
real UNEXCITED_VALUE_z   =$UNEXCITED_VALUE_z   ;
string UNEXCITED_LABEL_z = "$UNEXCITED_LABEL_z";

string EXCITED_TITLE     = "$EXCITED_TITLE    ";
real EXCITED_VALUE_x     =$EXCITED_VALUE_x     ;
string EXCITED_LABEL_x   = "$EXCITED_LABEL_x  ";
real EXCITED_VALUE_y     =$EXCITED_VALUE_y     ;
string EXCITED_LABEL_y   = "$EXCITED_LABEL_y  ";
real EXCITED_VALUE_z     =$EXCITED_VALUE_z     ;
string EXCITED_LABEL_z   = "$EXCITED_LABEL_z  ";

//size(5cm,5cm);
unitsize(.2cm);


struct state {
  real energy;
  string title;
  real value;
  real VB          = ENERGIE_VB;
  real LB          = ENERGIE_LB;
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
unex_state1.init(UNEXCITED_VALUE_x, UNEXCITED_LABEL_x);
unex_state2.init(UNEXCITED_VALUE_y, UNEXCITED_LABEL_y);
unex_state3.init(UNEXCITED_VALUE_z, UNEXCITED_LABEL_z);
unexcited_triplet.states = unex_group;


state ex_state1, ex_state2, ex_state3;
states excited_triplet;
state[] ex_group       = {ex_state1, ex_state2, ex_state3};
ex_state1.init(EXCITED_VALUE_x, EXCITED_LABEL_x);
ex_state2.init(EXCITED_VALUE_y, EXCITED_LABEL_y);
ex_state3.init(EXCITED_VALUE_z, EXCITED_LABEL_z);
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



EOF
