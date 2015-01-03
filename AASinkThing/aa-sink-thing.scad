// AA sink thing

use <Thread_Library.scad>;

// Length of threaded part
screw_offset = 2.0;
screw_length = 44.5 + screw_offset;

// Distance between threads
thread_distance = 1.0;

// Radius of threaded part
screw_radius = 5.5/2.0;

// mount thing
mount_outer_radius = 6.0;
mount_inner_radius = 3.5;
mount_width = 5.4;

// decoration
dec_radius = 13.4/2.0;
dec_thickness = 3.0;
dec_transition_thickness = 2;
dec_transition_radius = 3.5;


// Padding
pad = 0.1;

// Rounds
// $fn = 10;

module center_thread( length = thread_length, pitch=thread_pitch, pitchRadius = thread_pitch_radius ) {
    trapezoidThread(
        length=length,                  // axial length of the threaded rod 
        pitch=pitch,                    // axial distance from crest to crest
        pitchRadius=pitchRadius,        // radial distance from center to mid-profile
        threadHeightToPitch=0.5,        // ratio between the height of the profile and the pitch 
        // std value for Acme or metric lead screw is 0.5
        profileRatio=0.5,                       // ratio between the lengths of the raised part of the profile and the pitch
                                                // std value for Acme or metric lead screw is 0.5
        threadAngle=20,                 // angle between the two faces of the thread 
                                                // std value for Acme is 29 or for metric lead screw is 30
        RH=true,                                // true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
        clearance=0.1,                  // radial clearance, normalized to thread height
        backlash=0.1,                   // axial clearance, normalized to pitch
        stepsPerTurn=24,                        // number of slices to create per turn,
        showVertices=false
                );
}

module thread() {
    difference() {
        translate([0,0,-screw_offset] ) {
            center_thread( screw_length, thread_distance, screw_radius );
        }
        
        translate([0,0,screw_length-screw_offset-5.0+pad]) {
            
            difference() {
                cylinder( h = 5.0, r = screw_radius * 2.0 );
                
                cylinder( h = 5.0, r1 = screw_radius, r2= 2.0 );
            }
        }
    }
}

module mount() {
    translate([0,mount_width / 2.0, -mount_outer_radius + pad]) {
        rotate( [90,0,0] ) {
            difference() {
                cylinder( r = mount_outer_radius, h = mount_width );
                translate( [0,0,-pad] ){
                    cylinder( r = mount_inner_radius, h = mount_width + 2* pad);
                }
            }
        }
    }
}

module decoration() {
    translate([0,0, -dec_transition_thickness - mount_outer_radius * 2.0 + 1]) {
        rotate([180,0,z]) {
            cylinder( h = dec_thickness, r = dec_radius );
            translate( [0,0,-dec_transition_thickness + pad] ) {
                cylinder( h = dec_transition_thickness + pad, r2 = dec_radius, r1 = dec_transition_radius );
            }
        }
    }
}

mount();
thread();
decoration();
