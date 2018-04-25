
include <gear.scad>


$fn=200;

// The shafts are used several places.
shaft_diameter = 2.3 + 0.8; // 0.8 added for printing, and adjusted after first print.
// And, some settings for the axle_holders
axle_holder_height = 5;
axle_holder_outer_diameter = 10;
axle_holder_bearings_thickness = 2; // Not really bearings. ... forget the name.


////////////////////////////////////////
// Measurements of the motor
motor_shaft_length   = 5; // That is, after the "star" thing has been put on...
motor_shaft_diameter = 2.3;  // Raw measure
motor_shaft_d_remain = 0.55; // From center of shaft to no more material - shortest distance.
motor_print_pad      = 0.2;  // Pad for inner hole shrinkage. This is "diameter"
// 0.2 for white filament, something else for black... 

// We reuse the "star" gear from the original motor.
motor_star_fitting_inner_diameter = 2.5;
motor_star_fitting_outer_diameter = 4.7;
star_print_pad = 1.3; // Seems to depend somewhat on filament. 1.3 slightly tighther than last print.

////////////////////////////////////////
// General gear settings
// The geat thickness. For now, go with motor_shaft_length
gear_thickness = motor_shaft_length;

// Not used for now. May never be, actually.
// pressure_angle = 25;

// All gears must use same circular pitch.
// Changing this, greatly influences the size / dimension of everything.
circular_pitch = 5;


////////////////////////////////////////
// Specific gear settings.

// Motor, and we go for 1:5
motor_gear_num_teeth    = 9;
motor_gear_pitch_radius = pitch_radius(num_teeth=motor_gear_num_teeth, circular_pitch=circular_pitch);
motor_gear_inner_radius = motor_gear_pitch_radius - dedendum(circular_pitch=circular_pitch);
motor_gear_outer_radius = motor_gear_pitch_radius - addendum(circular_pitch=circular_pitch);
echo(str( "Motor gear: num_teeth=", motor_gear_num_teeth, ", outer_radius=", motor_gear_outer_radius, ", pitch_radius=", motor_gear_pitch_radius));


// Ratio - get as close to 3 as possibly. 
// Middle has two gears, really.
// Input, gets input from the motor.
// Output, output gear, really
middle_gear_input_num_teeth    = 25; 
middle_gear_input_pitch_radius = pitch_radius(num_teeth=middle_gear_input_num_teeth, circular_pitch=circular_pitch);
middle_gear_input_inner_radius = middle_gear_input_pitch_radius - dedendum(circular_pitch=circular_pitch);
middle_gear_input_outer_radius = middle_gear_input_pitch_radius + addendum(circular_pitch=circular_pitch);
echo(str( "Middle gear input: num_teeth=", middle_gear_input_num_teeth, ", outer_radius=", middle_gear_input_outer_radius, ", pitch_radius=", middle_gear_input_pitch_radius));

middle_gear_output_num_teeth    = 9; 
middle_gear_output_pitch_radius = pitch_radius(num_teeth=middle_gear_output_num_teeth, circular_pitch=circular_pitch);
middle_gear_output_inner_radius = middle_gear_output_pitch_radius - dedendum(circular_pitch=circular_pitch);
middle_gear_output_outer_radius = middle_gear_output_pitch_radius + addendum(circular_pitch=circular_pitch);
echo(str( "Middle gear output: num_teeth=", middle_gear_output_num_teeth, ", outer_radius=", middle_gear_output_outer_radius, ", pitch_radius=", middle_gear_output_pitch_radius));

////////////////////////////////////////////////////////////
// Some calculated distances
motor_gear_to_middle_gear_distance = motor_gear_pitch_radius+middle_gear_input_pitch_radius;

// Pad, for ensuring overlap when "joining" structures
pad = 0.01;

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
// Make a star
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

//////////////////////////////////////////////////////////////////////
// Create a holder for the axles
module axle_holder() {
    difference() {
        cylinder(h = axle_holder_height,   r = axle_holder_outer_diameter / 2, center = true);
        cylinder(h = axle_holder_height*2, r = shaft_diameter / 2, center = true);
    }
}

////////////////////////////////////////////////////////////
// Motor gear
// A gear with room for the shaft, is it is now.
module motor_gear() {
    difference() {
        linear_extrude(height=gear_thickness)
        gear(num_teeth=motor_gear_num_teeth, circular_pitch=circular_pitch);
        
        translate([0,0,gear_thickness/2])
        star_shaft(6, motor_star_fitting_outer_diameter/2, motor_star_fitting_inner_diameter/2, star_print_pad);
        // D_shaft(6, motor_shaft_diameter, motor_shaft_d_remain, motor_print_pad;
    }
    // Add an axle holder to the bottom.
    translate([0,0,-axle_holder_height/2])
    axle_holder();
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
            text(str(floor(motor_gear_pitch_radius*10)/10), size = 3);
        }
    }
}

////////////////////////////////////////////////////////////
// The middle gear holds two conversions.
module middle_gear() {
    difference() {
        union() {
            translate([0,0,-pad])
            linear_extrude(height=gear_thickness+pad)
            gear(num_teeth=middle_gear_output_num_teeth, circular_pitch=circular_pitch);
            translate([0,0,-gear_thickness])
            linear_extrude(height=gear_thickness)
            gear(num_teeth=middle_gear_input_num_teeth, circular_pitch=circular_pitch);
        }
        // The shaft
        cylinder(h = gear_thickness * 4, r = shaft_diameter / 2.0, center = true);
    }
}


////////////////////////////////////////////////////////////////////////////////
// Main, sets the stuff together, as needed
module main() {
    motor_gear();
    translate([motor_gear_to_middle_gear_distance,0,0])
    rotate([180,0,0])
    middle_gear();
}


main();

// motor_gear();
// middle_gear();




