// Replacement part for a velux curtain thingy





////////////////////////////////////////////////////////////
// BASE
// The largest part. Goes into the track of the curtain
base_width = 15.8;
base_height = 31.2;
base_thickness = 2.4;
// The base "wedges off" in the top, with an angle
base_wedge_offset = 26.0; // This is not actual measurement.
base_wedge_angle = 20; // very approximate

module base() {

    // The rotation is sort of weird, but lots easier for me to calculate...
    
    // FIX THIS; Cuts too much.
    
    translate([base_width / 2.0, base_height / 2.0, 0] ) {
        rotate([0,0,180]) {
            translate([-base_width / 2.0, -base_height / 2.0, 0] ) {
                difference() {
                    // This is the largest part, called the base
                    cube([base_width, base_height, base_thickness]);
                    
                    // Cut with a wedge
                    translate([-base_width / 2.0, -3, 0] ) {
                        rotate([base_wedge_angle,0,0]) {
                            translate([0,3,0]) {
                                cube([base_width*2, base_height, base_thickness]);
                            }
                        }
                        
                    }
                }
            }
        }
    }
}


base();