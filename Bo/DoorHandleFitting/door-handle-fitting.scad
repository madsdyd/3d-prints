// Simple fitting to a door handle.

// Main variables
radius = 38 / 2.0;
thickness = 10;

// Center hole
center_hole_radius = 12 / 2.0;

// Stuff to fasten handle too
handle_hole_radius = 3 / 2.0;
handle_hole_offset = 15;

// Stuff to fasten fitting
fitting_hole_radius = 5 / 2.5;
fitting_hole_angle = 45;

// Pad and roundness
$fn = 50;
pad = 0.05;

// A handle hole
module handle_holes() {
    translate( [handle_hole_offset,0,0] ) {
        cylinder( h = thickness + 2*pad, r = handle_hole_radius, center = true );
    }
    translate( [-handle_hole_offset,0,0] ) {
        cylinder( h = thickness + 2*pad, r = handle_hole_radius, center = true );
    }
}

module fitting_holes() {
    // Rotate into place
    rotate([0,0,fitting_hole_angle]) {
        // Translates in x to match edge of main fitting
        translate([radius, 0, 0]) {
            cylinder( h = thickness + 2*pad, , r = fitting_hole_radius, center = true );
        }
        translate([-radius, 0, 0]) {
            cylinder( h = thickness + 2*pad, , r = fitting_hole_radius, center = true );
        }
    }
}

// The fitting
module fitting() {

    difference() {
        // The main cylinder
        cylinder( h = thickness, r = radius, center = true );

        // center hole
        cylinder( h = thickness + 2*pad, r = center_hole_radius, center = true );
        
        // Holes for fastening the handle
        handle_holes();

        // Tricky stuff.
        fitting_holes();
        
    }
    
}

fitting();