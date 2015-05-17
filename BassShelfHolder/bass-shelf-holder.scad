// Holder to hand a guitar (bass) on a shelf

// Note: Your openscad previewer needs to increase
// Preferences->Advanced->Turn of rendering at elements ... to about 6000 to work.

// There are three parts to this, the thing that fits on the shelf,
// the tigthening screw, and the actual holder for the bass.

use <Thread_Library.scad>;

// shelf_grabber

// How far in to grab the shelf
shelf_grabber_depth = 40;

// The thickness of the shelf grabber. Remember to adjust infill to fit strenght
shelf_grabber_thickness = 4;

// The minimim screw support - adds a cylinder for the screw
shelf_grabber_min_screw_support = 6;

// The thickness of the shelf. Leave a little wiggle room
shelf_thickness = 12 + 1;

// How much wander to allow for the screw
screw_wander = 5;


// Rounded corner radius
round_corner_radius = 1;

// Some values for the screw
screw_radius = 6;
screw_pitch = 2;
screw_clearance = 0.3;


// Values for actual holders, called "arms" here
arm_thickness = 8;
arm_length = 50;
arm_knob_radius = 8;
// Inside distance
arm_separation = 42;


$fn = 20;
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////
// Calculated consts
shelf_grabber_width = arm_separation + 2 * arm_thickness + 2*round_corner_radius;
shelf_grabber_height = shelf_grabber_thickness * 2 + shelf_thickness;
shelf_grabber_extra_screw_support = shelf_grabber_min_screw_support - shelf_grabber_thickness;
screw_length = shelf_grabber_extra_screw_support > 0 ? shelf_grabber_extra_screw_support + screw_wander + shelf_grabber_thickness : screw_wander + shelf_grabber_thickness;

// modules

// Create a cube with rounded corners of radius r.
// Reusable
module round_cube(x, y, z, r) {
    translate([r,r,r]) {
        minkowski() {
            cube([x-2*r,y-2*r,z-2*r]);
            sphere(r = r);
        }
    }
}

// The shelf grabber is more or less a box
sg_thread_x = shelf_grabber_width / 2.0;
sg_thread_y = shelf_grabber_depth-screw_radius-shelf_grabber_thickness-round_corner_radius;

module shelf_grabber() {
    // Translate to center on x
    translate([-shelf_grabber_width/2.0, 0, 0]) {

        // Cut the thread into this
        difference() {
            // Round outer thing, cut something from it
            union() {
                difference() {
                    round_cube(shelf_grabber_width, shelf_grabber_depth, shelf_grabber_height, round_corner_radius);
                    translate([-pad,shelf_grabber_thickness,shelf_grabber_thickness]) cube([shelf_grabber_width+2*pad, shelf_grabber_depth, shelf_thickness]);
                }
                // Add support for the screw, center back.
                if ( shelf_grabber_extra_screw_support > 0 ) {
                    // Note the x and y values are the center for the thread too
                    translate([sg_thread_x, sg_thread_y, -shelf_grabber_extra_screw_support]) {
                        cylinder( r = screw_radius + shelf_grabber_thickness, h = shelf_grabber_extra_screw_support + pad);
                    }
                }
            }
            // Cut out the thread
            // # center_screw_hole( screw_length, screw_pitch, screw_radius, screw_radius + 6 );
            // ([10,0,0] ) {
            translate([sg_thread_x, sg_thread_y, -screw_length/2.0] ) {
                trapezoidThreadNegativeSpace( screw_length, screw_pitch, screw_radius, clearance=screw_clearance );
            }
        }
    }
}

// Now, a screw
module screw() {
    translate([0,sg_thread_y,-screw_length*2]) {
        trapezoidThread( screw_length, screw_pitch, screw_radius, clearance=screw_clearance );
        // The handle uses the same thickness as the grabber, scales relative to screw
        scale([screw_radius * 2, screw_radius, 1])
        translate([0,0,-shelf_grabber_thickness])
        cylinder(h = shelf_grabber_thickness+pad, r = 1);
    }
}


// Finally the arms.
module arm() {
    translate([arm_thickness / 2.0 - round_corner_radius, pad, 2*round_corner_radius])
    minkowski() {
        rotate([90,0,-90])
        linear_extrude( height = arm_thickness - 2*round_corner_radius) 
        // Clockwise, x and y
        polygon(points=[
                [0,0],
                [0,shelf_grabber_height-4*round_corner_radius],
                [arm_length,shelf_grabber_height-4*round_corner_radius],
                [arm_length,shelf_grabber_height-1*round_corner_radius-arm_knob_radius]
            ]);
        sphere(r = round_corner_radius);
    }
    // Finally, add a knob at the end
    translate([0,-arm_length,shelf_grabber_height-round_corner_radius])
    sphere( r = arm_knob_radius );
}

module arms() {
    translate([-(arm_separation+arm_thickness)/2.0,0,0]) arm();
    translate([(arm_separation+arm_thickness)/2.0,0,0]) arm();
}

// Main
shelf_grabber();
screw();
arms();




