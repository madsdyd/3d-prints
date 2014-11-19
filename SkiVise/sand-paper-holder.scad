// Holder for sandpaper.

// Not sure I am going to need this
use <threads.scad>;


// Paper width in mm. This is 38 / 2
paper_width = 19;
// Paper thickness.
paper_thickness = 1;
// Allow some padding or it gets very hard
paper_padding_slot = 1;
paper_padding_tie = 0.5;


// Holder width, as seen when mounted on ski
holder_width = 80;
// Amount of support on top of ski
holder_depth_support = 10;
// Amount of support on side of ski
holder_height_support = 40;
// General thickness
holder_thickness = 4;



// General padding to avoid breaking the manifold
pad = 0.1;
////////////////////////////////////////////////////////////////////////////////

// The major part, everything else is cut from this - well, some is added, but still.
module base() {
    cube([holder_width, holder_depth_support+paper_width/2.0+holder_thickness, holder_height_support+paper_thickness+paper_padding_slot+holder_thickness] );
}

// The cutter for skis
module skicutter() {
    translate([-pad,-pad,-pad]) {
        cube([holder_width + 2*pad, holder_depth_support+pad, holder_height_support+2*pad]);
    }
}
// The cutter for supports
module supportcutter() {
    translate([-pad,holder_depth_support+holder_thickness,-pad]) {
        cube([holder_width + 2*pad, paper_width/2.0+pad, holder_height_support+pad-holder_thickness]);
    }
}
// The cutter for the paper slot
module paperslotcutter() {
    translate([-pad,-pad,holder_height_support]) {
        cube([holder_width+2*pad,holder_depth_support+pad+paper_width/2.0,paper_thickness+paper_padding_slot]);
    }
}


difference() {
    base();
    #skicutter();
    # supportcutter();
    # paperslotcutter();
}
