// Lamp for sylvanian dolls

use <Thread_Library.scad>;

// The height of the central part of the lamp.
// 31 == Table lamp
// 71 == Floor lamp
lamp_central_height = 71;


// Skruekærv
module bolt( length = thread_length, pitch=thread_pitch, pitchRadius = thread_pitch_radius ) {
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

module moetrik( length = nut_height, pitch=thread_pitch, pitchRadius = thread_pitch_radius  ) {
    trapezoidThreadNegativeSpace(
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
        clearance=0.3,                  // radial clearance, normalized to thread height
        backlash=0.3,                   // axial clearance, normalized to pitch
        stepsPerTurn=24,                        // number of slices to create per turn,
        showVertices=false
    );
}




// Base of lamp
module base() {
    translate([0,0,-9 -lamp_central_height]) {
        translate([0,0,lamp_central_height/2.0 + 1]) {
            // The long part of the lamp
            cylinder(h = lamp_central_height, r = 2.5, center = true);
        }
        // The base/foot of the base
        minkowski() {
            cylinder( r1= 7, r2 = 2.00, h = 5 );
            // cylinder( r = 1, h = 1 );
            sphere(r = 1);
            
        }
        // Bolt til at skrue skærmen på
        translate([0,0,lamp_central_height]) bolt( length = 5, pitch=1.5, pitchRadius = 3);
    }
}

// The hat
module ydre_skaerm() {
    minkowski() {
        cylinder( r1= 12, r2 = 6, h = 16 );
        sphere(r = 1);
    }
}
module skaerm() {

    difference() {
        ydre_skaerm();
        translate([0,0,-1.1]) {
            cylinder( r1= 10, r2 = 8, h = 8 );
        }
        translate([0,0,8]) moetrik( length = 5, pitch=1.5, pitchRadius = 3, radius = 4);
    }
}




base();
skaerm();