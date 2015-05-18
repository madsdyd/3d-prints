// Holder to hand a guitar (bass) on a shelf

// Note: Your openscad previewer needs to increase
// Preferences->Advanced->Turn of rendering at elements ... to about 6000 to work.

// Also, this takes about 180 seconds minut to preview, about 180 seconds to compile afterwards.

// Print with LARGE infill, to make it stiffer.


use <Thread_Library.scad>;

// The thickness of the shelf. Leave a little wiggle room
shelf_thickness = 12 + 1;

// Some values for the screw
screw_radius = 6;
screw_pitch = 2;
screw_clearance = 0.3;
screw_support = 6;
// How much wander to allow for the screw
screw_wander = 3;
screw_handle_thickness = 5;

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

// Rounded corner radius
round_corner_radius = 1;

$fn = 20;
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////
// Calculated consts

arm_support_width = arm_separation + 2 * arm_thickness;
arm_support_depth = arm_grab_lower_depth;
screw_length = screw_wander + arm_thickness_grab;

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


// Now, a screw
module screw() {
    translate([0,sg_thread_y,-screw_length*2]) {
        trapezoidThread( screw_length, screw_pitch, screw_radius, clearance=screw_clearance );
        // The handle uses the same thickness as the grabber, scales relative to screw
        scale([screw_radius * 2, screw_radius, 1])
        translate([0,0,-screw_handle_thickness])
        cylinder(h = screw_handle_thickness+pad, r = 1);
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
    } // Translate
}

module arms() {
    translate([-(arm_separation+arm_thickness)/2.0,0,0]) mirror([1,0,0]) arm();
    translate([(arm_separation+arm_thickness)/2.0,0,0]) arm();
}

// Support for the arms / the screw
sg_thread_x = 0; 
sg_thread_y = arm_support_depth-screw_radius-screw_support;
module arm_support() {
    difference() {
        translate([-arm_support_width/2.0, 0, 0]) {
            round_cube( arm_support_width, arm_support_depth+rc, arm_thickness_grab, round_corner_radius );
        }
        // Cut out the thread
        // # center_screw_hole( screw_length, screw_pitch, screw_radius, screw_radius + 6 );
        // ([10,0,0] ) 
        translate([sg_thread_x, sg_thread_y, 0] ) {
            trapezoidThreadNegativeSpace( screw_length, screw_pitch, screw_radius, clearance=screw_clearance );
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Main
screw();
arms();
arm_support();



