/*******************/
/* MAIN PARAMETERS */
/*******************/

string ABCD_TITLE = "A-B-C-D 128";

real A_ENERGIE = 12;
real B_ENERGIE = 15;
real C_ENERGIE = 14;
real D_ENERGIE = 13;

real[] ENERGIES={A_ENERGIE, B_ENERGIE, C_ENERGIE, D_ENERGIE};

real MAX = max(ENERGIES)*1.05;
real MIN = min(ENERGIES)*.95;

//size(5cm,5cm);
unitsize(.2cm);


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
  void draw (){
    filldraw(box((X_COORD,value),(X_COORD+DASH_WIDTH,value+DASH_HEIGHT)),red);
    label(title, (X_COORD+DASH_WIDTH,value), E);
    //label((string)energy, (X_COORD+DASH_WIDTH,value), E);
    if ( spin != 0 ) {
      draw_spin();
    }
  };
};



/*******************/
/* DRAW DECORATION */
/*******************/
real pointsToEnergy ( real point ){
  return (MAX-MIN)*point/100 + MIN;
};
label(ABCD_TITLE, (30, 95), 0.8*blue);
//draw((50,0)--(50,100),dashed, Arrows);

//draw(box((0,0),(100,100)));



//int steps = 10;
//real width = 100/steps;
//draw((0,0)--(0,100), linewidth(1));
//for ( int i = 0; i <= steps; i+=1 ) {
  //draw((0,width*i)--(2,width*i));
  //label(scale(0.7)*(string)pointsToEnergy(width*i), (1,width*i), E, Fill(white));
//}


/***************/
/* DRAW STATES */
/***************/
void draw_distance ( state s, state t ){
  pair mid1, mid2;
  real energy;
  energy = abs(s.energy - t.energy);
  mid1 = s.getMiddlePoint();
  mid2 = t.getMiddlePoint();
  path p = (mid1.x, mid1.y)--(mid1.x,mid2.y);
  draw(p, 0.5*white+dashed, Arrows());
  label((string)energy+" eV", (mid1.x, (mid1.y+mid2.y)/2), Fill(white));
};
state A, B, C, D;

A.init(A_ENERGIE, 0, "A");
A.X_COORD=0*A.DASH_WIDTH;
A.draw();

B.init(B_ENERGIE, 0, "B");
B.X_COORD=1*B.DASH_WIDTH;
B.draw();

C.init(C_ENERGIE, 0, "C");
C.X_COORD = 2*C.DASH_WIDTH;
C.draw();

D.init(D_ENERGIE, 0, "D");
D.X_COORD = 3*D.DASH_WIDTH;
D.draw();

draw_distance(A,B);
draw_distance(B,C);
draw_distance(C,D);
draw_distance(D,A);

