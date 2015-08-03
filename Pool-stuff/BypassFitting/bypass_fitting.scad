// Poor mans bypass for pool

// Local library
use <Thread_Library.scad>;


// Note: Your openscad previewer may need to increase
// Preferences->Advanced->Turn of rendering at elements ... to about 6000 to work.

// Also, this takes about 180 seconds minut to preview, about 5 minutes to compile afterwards.
// Also: Previews may not work very well.

// Print with LARGE infill, to make it stiffer.

// Outer hose diameter is 32. Radius /2 ... (Captain obvious).
hose_radius = 32 / 2;

// Amount of grip for each hose
hose_grip = 20;

// Slip is the distance between the main pipe and the start of the threading
slip = 5;

// The lenght of the thread. Well, the amount of thread.
thread_length = 13;

// overall thickness of walls
overall_thickness = 3;

// Setup for outer thread, BSP:
// This is based on
// https://en.wikipedia.org/wiki/Garden_hose
// and
// https://en.wikipedia.org/wiki/British_Standard_Pipe

// The commented ones are INTERNAL THREAD diameters...
// I had to reduce to make an EXTERNAL THREAD diameter.
// thread_minor_radius = 24.120 / 2;
thread_minor_radius = 23.7 / 2;
// thread_major_radius = 26.441 / 2;
thread_major_radius = 26.0 / 2;
thread_pitch = 1.814;
thread_angle = 55 / 2;



thread_clearance = 0.1;


// Padding and other stuff
pad = 0.1;
// Increase circles
$fn = 70;

// Calculated
thread_radius = (thread_major_radius + thread_minor_radius) / 2;


// Pipe length is the total lenght of the fitting
pipe_length = ( hose_grip + thread_major_radius ) * 2;

module torus( r, circle_radius ) {
    rotate_extrude()
    translate([r, 0, 0])
    circle(r = circle_radius);


}

// The main pipe. The other stuff is mounted/cut from this.
// This has round corners
module main_pipe_positive() {
    translate([0,0,-(pipe_length-overall_thickness)/2]) {
        cylinder( r = hose_radius, h = pipe_length - overall_thickness );
        // I want round corners.
        torus( hose_radius - overall_thickness/2, overall_thickness / 2);    
        translate([0,0,pipe_length-overall_thickness])
        torus( hose_radius - overall_thickness/2, overall_thickness / 2);
    }
}

module main_pipe_negative() {
    translate([0,0,-(pipe_length-overall_thickness)/2]) {
    translate([0,0,-pad]) {
        cylinder( r = hose_radius - overall_thickness, h = pipe_length -overall_thickness + 2 * pad );
    }
    }
}


// A threaded cylinder thingy.
module thread_mount_positive() {
    // Height is hose outer radius + slip, then cut later with negative
    cylinder(r = thread_minor_radius, h = hose_radius + slip);
    translate([0,0,slip+hose_radius-pad])
    trapezoidThread( length = thread_length,
        pitch = thread_pitch,
        pitchRadius = thread_radius,
        threadAngle = thread_angle,
        clearance=thread_clearance );
}

module thread_mount_negative() {
    cylinder( r = thread_minor_radius - overall_thickness,
        h = hose_radius + slip + thread_length + pad * 2);
}


module main() {
    difference() {
        union() {
            rotate([0,90,0])
            main_pipe_positive();
            thread_mount_positive();
        }
        rotate([0,90,0])
        main_pipe_negative();
        thread_mount_negative();
    }

}

main();
