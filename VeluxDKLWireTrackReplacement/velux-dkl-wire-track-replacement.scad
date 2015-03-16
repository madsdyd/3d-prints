// Replacement part for a velux curtain thingy



pad = 0.05;

////////////////////////////////////////////////////////////
// CONSTANTS

// BASE PART CONSTANTS
// The largest part. Goes into the track of the curtain
base_width = 15.8;
base_height = 31.2;
base_thickness = 2.4;
// The base "wedges off" in the top, with an angle
base_wedge_offset = 26.0; // This is not actual measurement.
base_wedge_angle = 17; // very approximate

// FITTER CONSTANTS
// ALSO USED BY BASE. REALLY; THIS IS CONFUSING
// The very small edge in the side
fitter_edge_thickness = 0.7;
// The offset from the left edge to the start of the fitter
fitter_base_offset = 14.7;


////////////////////////////////////////////////////////////////////////////////
// BASE PART
// It has a very weird visible edge here...
module base_weird_edge() {
    linear_extrude( height = base_thickness * 2 ) {
    polygon(points=[
            [-pad,0],
            [2.5,0],
            [5,2.5],
            [8.5,2.5],
            [12,4],
            [base_width-1.5,4],
            [base_width+pad,2.5],
            [base_width+pad,10],
            [-pad,10]
            ]);
    }
}

// The base part, without weird cuttings.
module base_base() {

    // Base with wedge
    // The rotation is sort of weird
    translate([base_width / 2.0, base_height / 2.0, 0] ) {
        rotate([0,0,180]) {
            translate([-base_width / 2.0, -base_height / 2.0, 0] ) {
                difference() {
                    // This is the largest part, called the base
                    cube([base_width, base_height, base_thickness]);
                    
                    // Cut with a wedge
                    // the 3/-3 is imprecise, but ...
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

// The actual base.
module base() {

    // Cut off some stuff
    difference() {
        // The main base
        difference() {
            base_base();
            translate([0,base_height-4,-pad]) {
                base_weird_edge();
            }
        }
        // The edge is actually a wedge too, but really...
        translate( [ base_width + fitter_base_offset, 0, base_thickness + fitter_edge_thickness ] ) {
            cube([base_width * 2, base_height * 2, base_thickness * 2], center = true );
        }
    }
}

////////////////////////////////////////////////////////////
// The fitter is the round part that goes into the something.
// Yes, I know, I have a really hard time describing it.

module fitter() {
    

}

module base_and_fitter() {
    


}


base();
// base_weird_edge();