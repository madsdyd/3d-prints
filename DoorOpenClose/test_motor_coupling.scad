
include <gear.scad>


$fn=200;


motor_shaft_length    = 3;
motor_shaft_diameter  = 2.3;  // Raw measure
motor_shaft_d_reminan = 0.55; // From center of shaft to no more material - shortest distance.
motor_print_pad       = 0.2;  // Pad for inner hole shrinkage. This is "diameter"

pressure_angle = 25;


// Make a d-shaft
// @length The length of the shaft
// @diameter The diameter of the shaft
// @remain The amount of material left on one side, after cutting it flat
// @pad Padding for printing, recommended 0.05-0.1
module D_shaft(height, diameter, remain, pad) {
    difference() {
        cylinder(h=height, r=diameter/2+pad/2, center = true);
        translate([0,diameter/2+pad/2+remain+pad,0])
        cube([diameter+pad,diameter+pad,height*2], center=true);
    }
}

// Make a test gear for the motor shaft.
circular_pitch=9;

// Motor, and we go for 1:5
motor_shaft_gear_num_teeth = 10;
motor_shaft_gear_radius    = pitch_radius(num_teeth=motor_shaft_gear_num_teeth, circular_pitch=circular_pitch);
echo(str("motor_shaft_gear_num_teeth = ", motor_shaft_gear_num_teeth));
echo(str("motor_shaft_gear_radius = ", motor_shaft_gear_radius));

// Ratio - get as close to 5 as possibly
driver_gear_num_teeth = motor_shaft_gear_num_teeth * 5; // Ints only... 
driver_gear_radius    = pitch_radius(num_teeth=driver_gear_num_teeth, circular_pitch=circular_pitch);
echo(str("driver_gear_num_teeth = ", driver_gear_num_teeth));
echo(str("driver_gear_radius = ", driver_gear_radius));
echo(pitch_radius(num_teeth=10, circular_pitch = 9));



difference() {
    difference() {
        translate([0,0,-1.5])
        linear_extrude(height=3)
        gear(num_teeth=motor_shaft_gear_num_teeth, circular_pitch=circular_pitch);
        
        D_shaft(6, 2.3, 0.55, 0.2);
    }
    // Circular pitch
    translate([-2,3,1])
    linear_extrude(height = 4) {
        text(str(circular_pitch), size = 6);
    }
    // Radius
    translate([-6,-7.5,1])
    linear_extrude(height = 4) {
        text(str(floor(motor_shaft_gear_radius*10)/10), size = 5);
    }
 
    
}

// Second gear, testing
/*
translate([-driver_gear_radius-motor_shaft_gear_radius,0,0])
linear_extrude(height=3)
gear(num_teeth=driver_gear_num_teeth, circular_pitch=circular_pitch);
*/

