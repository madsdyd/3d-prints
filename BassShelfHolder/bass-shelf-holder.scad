// Holder to hand a guitar (bass) on a shelf

// There are three parts to this, the thing that fits on the shelf,
// the tigthening screw, and the actual holder for the bass.

// shelf_grabber
shelf_grabber_width = 60;

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



$fn = 20;
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////
// Calculated consts
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
sg_thread_y = shelf_grabber_depth-screw_radius-shelf_grabber_thickness/2.0-round_corner_radius;
module shelf_grabber() {
    // Cut the thread into this
    // Round outer thing, cut something from it
    difference() {
        round_cube(shelf_grabber_width, shelf_grabber_depth, shelf_grabber_height, round_corner_radius);
        translate([-pad,shelf_grabber_thickness,shelf_grabber_thickness]) cube([shelf_grabber_width+2*pad, shelf_grabber_depth, shelf_thickness]);
    }
    // Add support for the screw, center back.
    if ( shelf_grabber_extra_screw_support > 0 ) {
        // Note the x and y values are the center for the thread too
        translate([sg_thread_x, sg_thread_y, -shelf_grabber_extra_screw_support]) {
            cylinder( r = screw_radius + shelf_grabber_thickness / 2.0, h = shelf_grabber_extra_screw_support + pad);
        }
    }

       
}



// Main
shelf_grabber();