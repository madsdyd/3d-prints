// Holder for sandpaper.




// TODO: Change to use the other thread library
// TODO: Bolts and flangenuts for putting the things together
// TODO: Slightly thicker top and deeper cuttings
// TODO: Much larger holes to put bolts through
// TODO: Perhaps single screw
// TODO: Wider overhang
// TODO: Measure official tool, match it
// TODO: Better handle
// TODO: Infill 20 percent
// TODO: Move paper the other direction?
// TODO: Round corners, if possible
// TODO: Ergonomics

use <threads.scad>;


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

// Edge height is the approximage height of the edges that keeps the paper in place
edge_height = 2.0;
// Edge offset is the offset from each end of the edges
edge_offset = 8;

// Size of studs
stud_diameter = 6;


// Offset from center for studs
stud_offset = 8;

// For ease
THICKNESS=holder_thickness * 1.0;
HOLDER_DEPTH=holder_depth_support+paper_width/2.0+holder_thickness;
HOLDER_WIDTH=holder_width * 1.0;
HOLDER_HEIGHT=holder_height_support+paper_thickness+paper_padding_slot+holder_thickness;

// General padding to avoid breaking the manifold
pad = 0.1;
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
// Stuff to put on top of things
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

// total stuf
module grib( pad = 0 ) {
    // Edges
    translate([HOLDER_WIDTH/2.0-edge_offset, 0, 0]) edge( pad );
    translate([-HOLDER_WIDTH/2.0+edge_offset, 0, 0]) edge( pad );
    
    // Studs
    translate([stud_offset, 0, 0]) stud( pad );
    translate([-stud_offset, 0, 0]) stud( pad );
}


////////////////////////////////////////////////////////////////////////////////
// The holder

module holder() {
    translate([-HOLDER_WIDTH/2.0,-HOLDER_DEPTH/2.0,-HOLDER_HEIGHT]) baseholder();

    grib ( 0.0 );
}

////////////////////////////////////////////////////////////////////////////////
// The lid
module lid() {
    difference() {
        translate([0,0,THICKNESS/2.0]) cube([HOLDER_WIDTH, HOLDER_DEPTH, THICKNESS], center=true );
        grib( paper_padding_grib );
    }
}


////////////////////////////////////////////////////////////////////////////////
// Main

holder();

translate([0,0,4*THICKNESS]) lid();



