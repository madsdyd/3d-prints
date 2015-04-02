// Simple fitting to a door handle.

// Main variables
radius = 38 / 2.0;
thickness = 10;

// Center hole
center_hole_radius = 12 / 2.0;

// Stuff to fasten handle too
handle_holes_radius = 3 / 2.0;
handle_holes_offset = 15;

// Stuff to fasten fitting
fitting_hole_radius = 5 / 2.5;
fitting_hole_angle = 45;

// Pad and roundness
$fn = 50;
pad = 0.05;

// Base is the main stuff, exclusive the fitting holes
module base() {

    
    cylinder( h = 10, r = radius );
    
    
    
}

base();