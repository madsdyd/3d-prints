// Holder for sandpaper.

// TODO: Slightly thicker handle?
use <Thread_Library.scad>;


// Paper width in mm. This is 38 / 2
paper_width = 19;
// Paper thickness.
paper_thickness = 1;
// Allow some padding or it gets very hard
paper_padding_slot = 1;
paper_padding_grib = 1.4142;


// Holder width, as seen when mounted on ski
holder_width = 60;
// Amount of support on top of ski
holder_depth_support = 10;
// Amount of support on side of ski
holder_height_support = 40;
// General thickness
holder_thickness = 4;

////////////////////
// The grib

// Edge height is the approximage height of the edges that keeps the paper in place
edge_height = 2.0;
// Edge offset is the offset from each end of the edges
edge_offset = 8;

// Handle
handle_width = 90;
handle_depth = 35;
handle_height = 15;

// Size of studs
stud_diameter = 6;
// Offset from center for studs
stud_offset = 8;

// Stuff for the threads
thread_length = 25;
thread_pitch = 2;
thread_pitch_radius = 6;

nut_height = 6;
nut_radius = thread_pitch_radius + 4;

// For ease
THICKNESS=holder_thickness * 1.0;
HOLDER_DEPTH=holder_depth_support+paper_width/2.0+holder_thickness;
HOLDER_WIDTH=holder_width * 1.0;
HOLDER_HEIGHT=holder_height_support+paper_thickness+paper_padding_slot+holder_thickness;

// General padding to avoid breaking the manifold
pad = 0.1;

$fn=50;


////////////////////////////////////////////////////////////////////////////////

// The major part, everything else is cut from this - well, some is added, but still.
module base() {
    cube([HOLDER_WIDTH, HOLDER_DEPTH, HOLDER_HEIGHT] );
}

// The cutter for skis
module skicutter() {
    translate([-pad,-pad,-pad]) {
        cube([HOLDER_WIDTH + 2*pad, holder_depth_support+pad, holder_height_support+2*pad]);
    }
}
// The cutter for supports
module supportcutter() {
    translate([-pad,holder_depth_support+holder_thickness,-pad]) {
        cube([HOLDER_WIDTH + 2*pad, paper_width/2.0+pad, holder_height_support+pad-holder_thickness]);
    }
}
// The cutter for the paper slot
module paperslotcutter() {
    translate([-pad,-pad,holder_height_support]) {
        cube([HOLDER_WIDTH + 2*pad,holder_depth_support+pad+paper_width/2.0,paper_thickness+paper_padding_slot]);
    }
}

// This is the base holder
module baseholder() {
    difference() {
        base();
        skicutter();
        supportcutter();
        paperslotcutter();
    }
}

////////////////////////////////////////////////////////////////////////////////
// The grib 
module edge( pad = 0.0 ) {
    rotate([0,45,0]) {
        cube([1.4142*edge_height + pad, HOLDER_DEPTH + 2*pad, 1.4142*edge_height + pad], center = true );
    }
}

module stud( local_pad = 0.0 ) {
    translate([0,0,THICKNESS/2.0]) {
        cylinder(h = THICKNESS + 2* pad, r = stud_diameter/2.0 + pad, center = true);
    }
}




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

module center_nut( length = nut_height, pitch=thread_pitch, pitchRadius = thread_pitch_radius, radius = nut_radius ) {
    trapezoidNut(
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
        showVertices=false,
        radius=radius
                );
}

// total stuf
module grib( pad = 0 ) {
    // Edges
    translate([HOLDER_WIDTH/2.0-edge_offset, 0, 0]) edge( pad );
    translate([-HOLDER_WIDTH/2.0+edge_offset, 0, 0]) edge( pad );
    
    // Studs
    // translate([stud_offset, 0, 0]) stud( pad );
    // translate([-stud_offset, 0, 0]) stud( pad );
}

module grib_thread() {
        // Thread
    translate([0,0,-THICKNESS/2.0]) center_thread();
}

// The stuff on the holder, that is, the platform to put the sand paper on.
module grib_holder( pad = 0 ) {
    grib( pad );
    grib_thread();
}

// The "cutter" from part of the handle, that is, the part that gets removed from the handle
module grib_handle( pad = 0 ) {
    grib( pad );
    cylinder(r = thread_pitch_radius + 1.5, h = 100, center = true );
}

// This is simple, but should work.
module butterfly_nut() {
    center_nut();

    difference() {
        scale([1.5,0.6,1]) {
            translate([0,0,2]) {
                cylinder(h = nut_height - 2, r = nut_radius);
            }
        }
        cylinder(r = thread_pitch_radius + 1.5, h = 100, center = true );
    }
    
}

////////////////////////////////////////////////////////////////////////////////
// The holder

module holder() {
    translate([-HOLDER_WIDTH/2.0,-HOLDER_DEPTH/2.0,-HOLDER_HEIGHT]) baseholder();

    grib_holder ( 0.0 );
}

// The handler
resize_factor_x = handle_width / ( handle_width + 10 );
resize_factor_y = handle_depth / ( handle_depth + 10 );
resize_factor_z = handle_height / ( handle_height + 10 );
module handle() {
    // cube([HOLDER_WIDTH, HOLDER_DEPTH, THICKNESS], center=true );
    translate([0,(handle_depth-HOLDER_DEPTH)/2.0,(handle_height-THICKNESS)/2.0]) {
        scale([resize_factor_x, resize_factor_y, resize_factor_z ]) {
            minkowski() {
                cube([handle_width, handle_depth, handle_height], center=true );
                // cylinder( h = 1, r = 5 );
                sphere( r = 5 );
                // rotate([90,0,0]) cylinder( h = 1, r = 5 );
            }
        }
    }
//    translate([0,-(handle_depth-HOLDER_DEPTH)/2.0,(handle_height+THICKNESS)/2.0]) cube([handle_width, handle_depth, handle_height], center=true );
}

////////////////////////////////////////////////////////////////////////////////
// The lid
module lid() {
    difference() {
        translate([0,0,THICKNESS/2.0]) handle();
        grib_handle( paper_padding_grib );
    }
}


////////////////////////////////////////////////////////////////////////////////
// Main

// holder();

// translate([0,0,1*THICKNESS]) lid();
translate([0,0,8*THICKNESS]) butterfly_nut();



