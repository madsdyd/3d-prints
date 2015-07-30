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
cap_thickness = 2.1;



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
// Increase circles
$fn = 70;

// Calculated
thread_radius = (thread_major_radius + thread_minor_radius) / 2;

////////////////////////////////////////////////////////////////////////////////
// Calculated stuff.

////////////////////////////////////////////////////////////
module cap() {
    difference() {
        cylinder( r = thread_radius + cap_thickness, h = cap_height );
        translate([0,0,cap_thickness]) {
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


cap();