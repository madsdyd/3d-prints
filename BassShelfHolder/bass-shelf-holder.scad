// Holder to hand a guitar (bass) on a shelf

// Note: Your openscad previewer needs to increase
// Preferences->Advanced->Turn of rendering at elements ... to about 6000 to work.

// Also, this takes about 1 minut to preview, about 2 minutes to render.

// There are three parts to this, the thing that fits on the shelf,
// the tigthening screw, and the actual holder for the bass.

// TODO: Change this is in a number of ways:
// Arms lot shorter
// Arms should go "upward" about a 10 mm.
// Arms should extend, instead of the top of the grabber
// Arms should be thicker on top and especially bottom.
// Print with larger infill, to make it stiffer.
// Much less screw wander.


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
arm_thickness = 10;
arm_thickness_grab = 10;
arm_grab_upper_depth = 20;
arm_grab_lower_depth = 40;
arm_hang = 10;
// The delta from the hang to the top. Makes the guitar slide towards the wall
arm_lift = 10;
// Distance from shelf edge to center of balls.
arm_length = 45; 
arm_knob_radius = 7;
// Inside distance
arm_separation = 42;


$fn = 5;
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////
// Calculated consts

arm_support_width = arm_separation + 2 * arm_thickness;
arm_support_depth = arm_grab_lower_depth;

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
// Right arm, seen from front
rc = round_corner_radius;
module arm() {
    translate([arm_thickness / 2.0 - round_corner_radius, arm_grab_upper_depth+rc, shelf_thickness+2*arm_thickness_grab]) {
    minkowski() {
        rotate([90,0,-90])
        linear_extrude( height = arm_thickness - 2*round_corner_radius) 
        // Clockwise, x and y
        // Really put on the thinking cap with regards to the corners!
        polygon(points=[
                [0+rc,0-rc],
                [arm_grab_upper_depth+arm_hang,0-rc],
                [arm_grab_upper_depth+arm_length-rc,arm_lift-rc],
                [arm_grab_upper_depth+arm_length-rc,arm_lift-arm_thickness_grab+rc],
                [arm_grab_upper_depth+arm_hang-rc,-shelf_thickness-2*arm_thickness_grab+rc],
                // Leftmost point
                [arm_grab_upper_depth-arm_grab_lower_depth+rc,-shelf_thickness-2*arm_thickness_grab+rc],
                // Leftmost side
                [arm_grab_upper_depth-arm_grab_lower_depth+rc,-shelf_thickness-arm_thickness_grab-rc],
                // Underside of grabber, rightmost point
                [arm_grab_upper_depth+rc,-shelf_thickness-arm_thickness_grab-rc],
                // Grabber inside wall
                [arm_grab_upper_depth+rc,-arm_thickness_grab+rc],
                [0+rc,-arm_thickness_grab+rc]
            ]);
        sphere(r = round_corner_radius);
    }
    // Finally, add a knob at the end
    translate([arm_thickness/2.0-arm_knob_radius,-arm_length-arm_grab_upper_depth+round_corner_radius,arm_lift])
    sphere( r = arm_knob_radius );
    }
}

module arms() {
    translate([-(arm_separation+arm_thickness)/2.0,0,0]) mirror([1,0,0]) arm();
    translate([(arm_separation+arm_thickness)/2.0,0,0]) arm();
}

module arm_support() {
    translate([-arm_support_width/2.0, 0, 0]) {
        round_cube( arm_support_width, arm_support_depth+rc, arm_thickness_grab, round_corner_radius );
    }
}


// Main
// shelf_grabber();
// screw();
arms();
arm_support();



