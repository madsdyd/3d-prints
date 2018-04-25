
include <gear.scad>


$fn=200;


motor_shaft_length   = 3;
motor_shaft_diameter = 2.3;  // Raw measure
motor_shaft_d_remain = 0.55; // From center of shaft to no more material - shortest distance.
motor_print_pad      = 0.2;  // Pad for inner hole shrinkage. This is "diameter"
// 0.2 for white filament, something else for black... 

motor_star_fitting_inner_diameter = 2.5;
motor_star_fitting_outer_diameter = 4.7;
star_print_pad = 1.2; // Seems to depend somewhat on filament.

pressure_angle = 25;


////////////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////
// Copied from https://gist.github.com/anoved/9622826
// points = number of points (minimum 3)
// outer  = radius to outer points
// inner  = radius to inner points
module Star(points, outer, inner) {
    
    // polar to cartesian: radius/angle to x/y
    function x(r, a) = r * cos(a);
    function y(r, a) = r * sin(a);
    
    // angular width of each pie slice of the star
    increment = 360/points;
    
    union() {
        for (p = [0 : points-1]) {
            
            // outer is outer point p
            // inner is inner point following p
            // next is next outer point following p

            assign(     x_outer = x(outer, increment * p),
                y_outer = y(outer, increment * p),
                x_inner = x(inner, (increment * p) + (increment/2)),
                y_inner = y(inner, (increment * p) + (increment/2)),
                x_next  = x(outer, increment * (p+1)),
                y_next  = y(outer, increment * (p+1))) {
                polygon(points = [[x_outer, y_outer], [x_inner, y_inner], [x_next, y_next], [0, 0]], paths  = [[0, 1, 2, 3]]);
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Make a star shaft.
// @length The length of the shaft
// @diameter The diameter of the shaft
// @remain The amount of material left on one side, after cutting it flat
// @pad Padding for printing, recommended 0.05-0.1
module star_shaft(height, inner, outer, pad) {
    difference() {
        translate([0,0,-height/2])
        linear_extrude( height = height ) 
        Star(6, outer+pad/2, inner+pad/2);
    }
}



// Make a test gear for the motor shaft.
circular_pitch=7;

// Motor, and we go for 1:5
motor_shaft_gear_num_teeth = 9;
motor_shaft_gear_radius    = pitch_radius(num_teeth=motor_shaft_gear_num_teeth, circular_pitch=circular_pitch);
echo(str("motor_shaft_gear_num_teeth = ", motor_shaft_gear_num_teeth));
echo(str("motor_shaft_gear_radius = ", motor_shaft_gear_radius));

// Ratio - get as close to 5 as possibly
driver_gear_num_teeth = motor_shaft_gear_num_teeth * 5; // Ints only... 
driver_gear_radius    = pitch_radius(num_teeth=driver_gear_num_teeth, circular_pitch=circular_pitch);
echo(str("driver_gear_num_teeth = ", driver_gear_num_teeth));
echo(str("driver_gear_radius = ", driver_gear_radius));
echo(pitch_radius(num_teeth=10, circular_pitch = 9));

////////////////////////////////////////////////////////////
// Motor gear
// A gear with room for the shaft, is it is now.
module motor_gear() {
    difference() {
        translate([0,0,-1.5])
        linear_extrude(height=3)
        gear(num_teeth=motor_shaft_gear_num_teeth, circular_pitch=circular_pitch);
        
        # star_shaft(6, motor_star_fitting_outer_diameter/2, motor_star_fitting_inner_diameter/2, star_print_pad);
        // D_shaft(6, motor_shaft_diameter, motor_shaft_d_remain, motor_print_pad;
        
    }
}

// Testing the motor gear

module test_motor_gear() {
    difference() {
        motor_gear();
        // Circular pitch
        translate([-1.3,3.4,1])
        linear_extrude(height = 4) {
            text(str(circular_pitch), size = 4);
        }
        // Radius
        translate([-2.2,-6.4,1])
        linear_extrude(height = 4) {
            text(str(floor(motor_shaft_gear_radius*10)/10), size = 3);
        }
    }
}

test_motor_gear();


// Second gear, testing
/*
translate([-driver_gear_radius-motor_shaft_gear_radius,0,0])
linear_extrude(height=3)
gear(num_teeth=driver_gear_num_teeth, circular_pitch=circular_pitch);
*/

