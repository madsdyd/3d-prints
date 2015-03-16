// Replacement part for a velux curtain thingy



pad = 0.05;
$fn = 50;

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

// PLATE CONSTANTS
plate_width = 32;
plate_height = 22;
plate_thickness = 2;
// Offset from bottom edge of base to start of plate.
plate_base_offset = 7.3;

// The screw hole is important. Offsets from center
plate_screw_hole_x_offset = 17.4;
plate_screw_hole_y_offset = 8.6;
plate_screw_hole_diameter = 2.4; // r = d/2 ... 

// And, the wire gude. Offsets from center.
plate_wire_guide_x_offset = 9.5;
plate_wire_guide_y_offset = 15.5;
plate_wire_guide_inner_width = 5;
plate_wire_guide_inner_height = 6;
plate_wire_guide_outer_depth = 9.5;
plate_wire_guide_roundness = 1; // Dunno yet.
plate_wire_guide_thickness = 3;

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
// The plate is the vertical plate from the base
// Most is cut from this (shape), using a coordinate system with 0,0 in lover left corner.
// Later, some additional stuff is added
module plate() {
    
    // The wire guide outer stuff
    # translate([ plate_wire_guide_x_offset, plate_wire_guide_y_offset, plate_wire_guide_outer_depth / 2.0 - plate_wire_guide_outer_depth + pad]) {
        
        cube([plate_wire_guide_inner_width + 2 * plate_wire_guide_thickness,
                plate_wire_guide_inner_height + 2 * plate_wire_guide_thickness,
                plate_wire_guide_outer_depth], center = true);
        
    }
    

    difference() {
        // The actual plate
        cube([plate_width, plate_height, plate_thickness]);

        // Screw hole
        translate( [plate_screw_hole_x_offset, plate_screw_hole_y_offset, plate_thickness / 2] ) {
            cylinder(r = plate_screw_hole_diameter / 2.0, h = plate_thickness * 2, center = true );
        }

        // Add the hole for the guide for the wire - wireguide
        
    }
}

module positioned_plate() {
    translate([-plate_thickness,plate_base_offset,base_thickness-pad]) {
        rotate([0,90,0]) {
            rotate([0,0,90]) {
                plate();
            }
        }
    }
}


// Just to translate the base the correct place.
module base_and_plate() {
    translate([fitter_base_offset,0,0]) {
        translate([-fitter_base_offset,0,0]) {
            base();
        }
        positioned_plate();
    }
}

////////////////////////////////////////////////////////////
// The fitter is the round part that goes into the something.
// Yes, I know, I have a really hard time describing it.
module fitter() {
}





//  plate();
base_and_plate();
// base_weird_edge();