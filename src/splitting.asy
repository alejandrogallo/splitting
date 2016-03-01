
import resources;

size(10cm,10cm);
//unitsize(.2cm);

/*******************/
/* MAIN PARAMETERS */
/*******************/

string SPLITTING_TITLE = "128";

string UNEXCITED_TITLE = "A";
real UNEXCITED_VALUE_x   = 1276.745   ;
string UNEXCITED_LABEL_x   = "$x$  ";
real UNEXCITED_VALUE_y   = 1276.745   ;
string UNEXCITED_LABEL_y   = "$y$  ";
real UNEXCITED_VALUE_z   = -2553.49   ;
string UNEXCITED_LABEL_z   = "$z$  ";

string EXCITED_TITLE = "C";
real EXCITED_VALUE_x     = 609.807666667     ;
string EXCITED_LABEL_x     = "$x$    ";
real EXCITED_VALUE_y     = 609.807666667     ;
string EXCITED_LABEL_y     = "$y$    ";
real EXCITED_VALUE_z     = -1219.61533333     ;
string EXCITED_LABEL_z     = "$z$    ";


real[] ALL_VALUES={ UNEXCITED_VALUE_x, UNEXCITED_VALUE_y, UNEXCITED_VALUE_z, EXCITED_VALUE_x, EXCITED_VALUE_y, EXCITED_VALUE_z};
real mi, ma;

mi = min(ALL_VALUES);
ma = max(ALL_VALUES);
if ( mi<0 ) {
  MAX = max(abs(mi), abs(ma));
  MIN = -MAX;
} else {
  MAX = ma;
  MIN = mi;
}

string ENERGY_FORMAT = "%#.1f";


//center dash and center state
real center_length  = 25+25+5;
draw((0,50)--(center_length,50),dashed+0.5*red+linewidth(2));
state CENTER;
CENTER.energy = MIN + (MAX-MIN)/2;


//UNEXCITET_STATE
state unex_state1, unex_state2, unex_state3;

unex_state1.init(UNEXCITED_VALUE_x, ttl=UNEXCITED_LABEL_x);
unex_state2.init(UNEXCITED_VALUE_y, ttl=UNEXCITED_LABEL_y);
unex_state3.init(UNEXCITED_VALUE_z, ttl=UNEXCITED_LABEL_z);

unex_state2.label_orientation = "l";

unex_state1.draw();
unex_state2.draw();
unex_state3.draw();


//UNEXCITET_STATE DISTANCES
CENTER.X_COORD=unex_state1.X_COORD - CENTER.DASH_WIDTH/4;
CENTER.X_COORD=unex_state2.X_COORD + CENTER.DASH_WIDTH/4;
CENTER.X_COORD=unex_state3.X_COORD ;

draw_distance(CENTER, unex_state1, units="MHz", energy_format=ENERGY_FORMAT);
draw_distance(CENTER, unex_state2, units="MHz", energy_format=ENERGY_FORMAT);
draw_distance(CENTER, unex_state3, units="MHz", energy_format=ENERGY_FORMAT);


//EXCITET_STATE
state ex_state1, ex_state2, ex_state3;

ex_state1.init(EXCITED_VALUE_x, ttl=EXCITED_LABEL_x);
ex_state2.init(EXCITED_VALUE_y, ttl=EXCITED_LABEL_y);
ex_state3.init(EXCITED_VALUE_z, ttl=EXCITED_LABEL_z);

ex_state2.label_orientation = "l";

ex_state1.X_COORD=30;
ex_state2.X_COORD=30;
ex_state3.X_COORD=30;

ex_state1.draw();
ex_state2.draw();
ex_state3.draw();


//EXCITET_STATE DISTANCES
CENTER.X_COORD=ex_state1.X_COORD - CENTER.DASH_WIDTH/4;
CENTER.X_COORD=ex_state2.X_COORD + CENTER.DASH_WIDTH/4;
CENTER.X_COORD=ex_state3.X_COORD ;

draw_distance(CENTER, ex_state1, units="MHz", energy_format=ENERGY_FORMAT);
draw_distance(CENTER, ex_state2, units="MHz", energy_format=ENERGY_FORMAT);
draw_distance(CENTER, ex_state3, units="MHz", energy_format=ENERGY_FORMAT);

//draw states titles
//label(UNEXCITED_TITLE, (12.5/2,50), Fill(white));
//label(EXCITED_TITLE, (100-12.5/2,50), Fill(white));


//draw a frame
//draw(box((0,0),(100,100)), invisible);
//draw title
//label(SPLITTING_TITLE, (50,50), Fill(white));
