real MIN = 0;
real MAX = 100;


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
  real Y_OFFSET    = 0;
  real getPlottingValue ( ){
    real val = 100*(energy - VB)/(LB-VB);
    return val + Y_OFFSET;
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
  label(lbl, (mid1.x + x_offset, (mid1.y+mid2.y)/2 + lbl_y_offset), Fill(white*0.95));
};
