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
plate_screw_hole_x_offset = 18;
plate_screw_hole_y_offset = 8.6;
plate_screw_hole_diameter = 3.0; // r = d/2 ... 

// And, the wire gude. Offsets from center.
plate_wire_guide_x_offset = 14.5;
plate_wire_guide_y_offset = 16;
plate_wire_guide_inner_width = 5;
plate_wire_guide_inner_height = 6;
plate_wire_guide_outer_depth = 9.5;
plate_wire_guide_roundness = 1; // Dunno yet.
plate_wire_guide_thickness = 2.4;

// And, the curtain holder
plate_curtain_holder_x_offset = 19.1;

// A small guide thing, that goes in, close the curtain holder
plate_guide_width = 6.0;
plate_guide_height = 1.2;
plate_guide_depth = 5;
plate_guide_x_offset = 19;
plate_guide_y_offset = 5.0;
plate_guide_angle = 4;

// Tounge - visible oval thingy
plate_tounge_width = 16;
plate_tounge_height = 5; // Half height
plate_tounge_x_offset = 9;
plate_tounge_y_top = 8.5;
plate_tounge_limit_angle = 22.5;
plate_tounge_depth = 10; // Not precise, just more than the limit stuff.
// Two cutouts
plate_tounge_cutout_radius = 1.25;
plate_tounge_cutout_x_offset_center = 8;
plate_tounge_cutout_y_offset_bottom = 2;

// shape is the final shape
shape_tounge_diff = 1.5;


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

/////////////////////////////////////////////////
// Some weird cutting that fits the curtain.
module plate_curtain_cutting() {
    linear_extrude( height = plate_thickness * 2 ) {
        polygon(points=[
                [0,-pad],
                [0,4],
                [0.5,4],
                [8,1],
                [7.9,2.5],
                [11,2.5],
                [11,1.5],
                [9.5,0.75],
                [9.5,-pad]
            ]);
    }
}
// plate_curtain_cutting();

////////////////////////////////////////
// The "tounge" is the round sloped thing that goes into the visible user area
// This is cut against the base, later
module plate_tounge() {
    difference() {
        union() {
            scale( [plate_tounge_width, plate_tounge_height*2,1] ) {
                cylinder(r = 0.5, h = plate_tounge_depth );
            }
            // Cube thinge
            // Something fishy with pad here.
            translate([ 0, - plate_tounge_y_top / 2.0 + base_thickness / 2.0 + 3*pad, plate_tounge_depth / 2 + pad] ) {
                cube( [plate_tounge_width, plate_tounge_y_top - plate_tounge_height + base_thickness, plate_tounge_depth], center = true );
            }
        }
        // Two very minor cuts
        union() {
            translate([-plate_tounge_cutout_x_offset_center, - plate_tounge_y_top / 2.0 + base_thickness / 2.0 + 3*pad - plate_tounge_cutout_y_offset_bottom/2.0, 0] ) {
                cylinder(r = 1.25, h = plate_tounge_depth*2);
            }
            translate([plate_tounge_cutout_x_offset_center, - plate_tounge_y_top / 2.0 + base_thickness / 2.0 + 3*pad - plate_tounge_cutout_y_offset_bottom/2.0, 0] ) {
                cylinder(r = 1.25, h = plate_tounge_depth*2);
            }
        }

    }
}

// The actual plate
module plate() {
    
    //////////////////////////////////////////////////
    // The wire guide
    // This is made as a cube with a rounded hole in.
    minkowski($fn = 10) {
        difference() {
            translate([ plate_wire_guide_x_offset, plate_wire_guide_y_offset, plate_wire_guide_outer_depth / 2.0 - plate_wire_guide_outer_depth + pad]) {
                
                cube([plate_wire_guide_inner_width + 2 * plate_wire_guide_thickness - plate_wire_guide_roundness * 2.0,
                        plate_wire_guide_inner_height + 2 * plate_wire_guide_thickness - plate_wire_guide_roundness * 2.0,
                        plate_wire_guide_outer_depth], center = true);
            }
            // Cut a hole through it
            // Note, this is done again below.
            translate([ plate_wire_guide_x_offset, plate_wire_guide_y_offset, plate_wire_guide_outer_depth / 2.0 - plate_wire_guide_outer_depth + pad]) {
                
                cube([plate_wire_guide_inner_width + plate_wire_guide_roundness * 2,
                        plate_wire_guide_inner_height + plate_wire_guide_roundness * 2,
                        plate_wire_guide_outer_depth * 2 ], center = true);
                
            }
            
        }
        sphere( r = plate_wire_guide_roundness );
    }

    ////////////////////////////////////////
    // The little guide
    // TODO: May want to round corners here.
    translate([plate_guide_x_offset, plate_guide_y_offset, plate_thickness - pad]) {
        rotate([0,0,-plate_guide_angle]) {
            cube([plate_guide_width, plate_guide_height, plate_guide_depth]);
        }
    }

    // The tounge
    translate([plate_tounge_x_offset, plate_tounge_y_top - plate_tounge_height, plate_thickness - pad]) {

        plate_tounge();
    }

    
    //////////////////////////////////////////////////
    // The plate, with various cuttings in it.
    difference() {
        // The actual plate
        cube([plate_width, plate_height, plate_thickness]);

        ////////////////////////////////////////
        // Screw hole
        translate( [plate_screw_hole_x_offset, plate_screw_hole_y_offset, plate_thickness / 2] ) {
            cylinder(r = plate_screw_hole_diameter / 2.0, h = plate_thickness * 2, center = true );
        }

        // Add the hole for the guide for the wire - wireguide
        // Note, this is also done above, sort of
        translate([ plate_wire_guide_x_offset, plate_wire_guide_y_offset, plate_wire_guide_outer_depth / 2.0 - plate_wire_guide_outer_depth + pad]) {
            
            cube([plate_wire_guide_inner_width + plate_wire_guide_roundness * 2,
                    plate_wire_guide_inner_height + plate_wire_guide_roundness * 2,
                    plate_wire_guide_outer_depth * 2 ], center = true);
            
        }

        ////////////////////////////////////////
        // The cutting for the actual cloth of the curtain
        translate( [plate_curtain_holder_x_offset,0,-plate_thickness / 2.0] ) {
            plate_curtain_cutting();
        }

        // And, some cuts for the shape of the plate
        // Cut above curtain guide
        translate([plate_width + 4, 6 + 15,0]) {
            cylinder( r = 15, h = 6, center = true );
        }
        // Cut some corner above the curtain guide cut.
        translate([19,19,-5]) {
            difference() {
                cube( [10, 10, 10] );
                cylinder( r = 3, h = 20 );
            }
        }
        // And around the tounge
        translate([plate_tounge_x_offset,plate_tounge_y_top - plate_tounge_height ,0]) {
            difference() {
                translate([-50,0,-5]) cube([50,50,50]);
                scale( [plate_tounge_width + 2 * shape_tounge_diff,
                        ( plate_tounge_height + shape_tounge_diff ) * 2 , 1] ) {
                    translate([0,0,-6]) cylinder(r = 0.5, h = 52 );
                }
            }
        }
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




////////////////////////////////////////////////////////////////////////////////

module main() {
    // Rotate to support print better
    rotate([0,-90,0]) {
        difference() {
            base_and_plate();
            
            // This is a special cut, which really is part of the tounge, but was too
            // hard to handle in that coordinate system
            // Note, 10 and 5 are hardcoded here.
            // And, go way oversize, to allow for the other stuff to move arounc
            translate([base_width + 5/cos(plate_tounge_limit_angle),0,0]) {
                rotate([0,90+plate_tounge_limit_angle,0]) {
                    cube([plate_tounge_width * 10, plate_tounge_height * 10, 10 ], center = true );
                }
            }
        }
    }
}

// Finally, print one for each side
translate([-10,0,0]) main();
mirror([1,0,0]) translate([-10,0,0]) main();

