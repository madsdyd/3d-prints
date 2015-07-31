// Hose cap

// Part of openscad
// include <nuts_and_bolts.scad>;
// Local library
use <Thread_Library.scad>;

// Note: Your openscad previewer may need to increase
// Preferences->Advanced->Turn of rendering at elements ... to about 6000 to work.

// Also, this takes about 180 seconds minut to preview, about 5 minutes to compile afterwards.
// Also: Previews may not work very well.

// Print with LARGE infill, to make it stiffer.


cap_height = 17;
cap_thickness = 3;
// If possible, print the bottom (or maybe entire cap) solid (100% infill).
bottom_thickness = 4;

grip_numbers = 16; // Should probably split 360 evenly
grip_radius = 2; // If too large, grips will overlap.

// thread controls
// This is based on
// https://en.wikipedia.org/wiki/Garden_hose
// and
// https://en.wikipedia.org/wiki/British_Standard_Pipe
thread_minor_radius = 24.120 / 2;
thread_major_radius = 26.441 / 2; 
thread_pitch = 1.814; // Testing...might be slightly smaller..
thread_angle = 55 / 2;

thread_clearance = 0.1;

// This is for "control"
washer_diameter = 24;
pad = 0.1;
// Increase circles
$fn = 70;

// Calculated
thread_radius = (thread_major_radius + thread_minor_radius) / 2;
// This may work better.
// thread_radius = thread_major_radius;

outer_radius = thread_radius + cap_thickness;

////////////////////////////////////////////////////////////////////////////////
// Calculated stuff.

////////////////////////////////////////////////////////////
module cap() {
    difference() {
        cylinder( r = outer_radius, h = cap_height );
        translate([0,0,bottom_thickness]) {
            trapezoidThreadNegativeSpace(
                length      = cap_height,
                pitch       = thread_pitch,
                pitchRadius = thread_radius,
                theadAngle  = thread_angle,
                clearance   = thread_clearance );
        }
        // cylinder( r = washer_diameter / 2, h = 4 );
        
    }
}

module grip(angle) {
    rotate([0,0,angle]) {
        translate([outer_radius,0,0])
        cylinder( h = cap_height, r = grip_radius );
        translate([-outer_radius,0,0])
        cylinder( h = cap_height, r = grip_radius );
    }
}
    
module grips() {
    angle_step = 180 / ( grip_numbers / 2 );
    difference() {
        union() {
            for ( n = [0:(grip_numbers / 2 - 1)] ) {
                grip(n*angle_step);
            }
        }
        cylinder(h = cap_height, r = outer_radius - pad);
    }
}

grips();
cap();