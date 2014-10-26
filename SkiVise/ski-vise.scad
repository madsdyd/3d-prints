// Ski vise

use <threads.scad>;

// The vise is basically very simple, and is a cube that is hollowed out.
// These are the basic dimensions for this cube
vise_height = 180;
vise_width = 40;
// This should/could be adjusted to accommodate wider skis
// 140 is very wide. You should probably not go lower than 80
vise_depth = 140;

// We need a cutout to allow for a clamp, for clamping to a table.
// This should match the clamp available for you
// Offset from the table you mount to
clamp_offset = 20;
clamp_height = 20;
clamp_width = 30;
clamp_depth = 60; // This could be a percent?

// This is for the slot to place the ski, when you need to work the edges
// This is always centered, but do have a depth and height
slot_height = 50;
slot_depth = 25;

// This is to avoid breaking the manifold
pad = 0.1;

// The major part, everything else is cut from this
module base() {
    // Place centered in x,y
    translate( [0,0,vise_height / 2.0]) {
        cube([vise_width, vise_depth, vise_height], center = true);
    };
}

// The place to clamp the vise to the table
module clamp_hollower() {
    // Translate to match front of main/base, and offset
    translate( [-clamp_width/2.0, -vise_depth/2.0 - pad, clamp_offset] ) {
        cube([clamp_width, clamp_depth+pad, clamp_height]);
    };
}

// The slot to place the ski in when working on the edge
module slot_hollower() {
    translate( [-vise_width/2.0 - pad, -slot_depth/2.0, vise_height - slot_height ] ) {
        cube([vise_width + 2*pad, slot_depth, slot_height + pad] );
    }
}

// For now, main.
module vise() {
    difference() {
        base();
        # clamp_hollower();
        # slot_hollower();
    }
}


// Can't make this work...
// metric_thread( 34, 2, 10, internal=true, n_starts=6);
// english_thread(1/4, 20, 1);
vise();