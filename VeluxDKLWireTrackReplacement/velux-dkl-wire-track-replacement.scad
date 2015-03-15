// Replacement part for a velux curtain thingy





////////////////////////////////////////////////////////////
// BASE
// The largest part. Goes into the track of the curtain
base_width = 15.8;
base_height = 31.2;
base_thickness = 2.4;
// The base "wedges off" in the top, with an angle
base_wedge_offset = 26.0;
base_wedge_angle = 25; // very approximate

module base() {

    // This is the largest part, called the base
    cube([base_width, base_height, base_thickness]);
}


base();