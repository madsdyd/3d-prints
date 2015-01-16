// Steel series mouse, pro gaming laser mouse, cover.


mouse_length = 126;
// Smallest waist
mouse_waist = 58 + 3.0;
// Smallest place at, measured from front.
mouse_waist_at = 55;
// Height is used by case
mouse_height = 42;

// Case offset to mouse stuff
// These are inside measurements.
case_padding = 30;
case_width = mouse_waist + case_padding;
case_length = mouse_length + case_padding;
case_height = mouse_height + case_padding; // Leave room for wire.
case_corner_radius = 5;
case_thickness = 2.0;

// thickness whereever it is used
snap_thickness = 2.0;

// Padding manifolds
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////

// This is a snap holder in the front. Two are used, one on each side of the wire.
module front_snap( x_offset, width, inner_height, thickness, overlap, overlap_angle ) {
    translate( [x_offset + width / 2.0, thickness / 2.0, (inner_height + thickness) / 2.0] ) {
        cube([width, thickness, inner_height + thickness], center = true);
        // TODO: the 4.2 can be calculated, if I cared...
        translate( [ -width/2.0, 0, ( overlap + inner_height + thickness ) / 2.0 - 3.7 ] ) {
            rotate( [overlap_angle, 0, 0] ) {
                cube([width, thickness, overlap], center = false );
            }
        }

    }
}

module front_snaps() {
    front_snap( 5, 10, 11, snap_thickness, 4, 60 );
    front_snap( -15, 10, 11, snap_thickness, 4, 60 );
}



// This is a snap holder in the back. Two are used, one on each side of the wire.
module back_snap( x_offset, width, inner_height, thickness, overlap, overlap_angle ) {
    translate( [x_offset + width / 2.0, thickness / 2.0, (inner_height + thickness) / 2.0] ) {
        cube([width, thickness, inner_height + thickness], center = true);
        // TODO: the 2.1 can be calculated, if I cared...
        // y also, very broken now.
        translate( [ -width/2.0, -thickness+1, ( overlap + inner_height + thickness ) / 2.0 - 1.5 ] ) {
            rotate( [overlap_angle, 0, 0] ) {
                cube([width, thickness, overlap], center = false );
            }
        }

    }
}

module back_snaps() {
    translate([0, -mouse_length-snap_thickness, 0] ) {
        back_snap( 5, 10, 6, snap_thickness, 3, -40 );
        back_snap( -15, 10, 6, snap_thickness, 3, -40 );
    }
}


// Side snaps, not really snaps
module side_snap( x_offset, y_offset, width, height, thickness ) {
    translate( [x_offset, y_offset, height / 2.0] ) {
        cube([thickness, width, height], center = true);
    }
}

module side_snaps() {
    side_snap( mouse_waist / 2.0, -mouse_waist_at, 8, 4, snap_thickness );
    side_snap( -mouse_waist / 2.0, -mouse_waist_at, 8, 4, snap_thickness );
}


module snaps() {
    front_snaps();
    back_snaps();
    side_snaps();
}

// Bottom, just something to place it on
module snap_bottom() {
    translate( [-( mouse_waist + snap_thickness ) / 2.0, -mouse_length-snap_thickness, -snap_thickness+pad]) {
        cube([mouse_waist + snap_thickness, mouse_length + 2* snap_thickness, snap_thickness]);
    }
}

////////////////////////////////////////////////////////////////////////////////
// The enclosure/case
module rounded_box(x, y, z, r) {
    minkowski() {
        cube([x-r * 2, y-r*2, z-r*2], center = true);
        sphere(r=r);
    }
}

module hollow_box(x, y, z, r) {
    difference() {
        rounded_box(x+case_thickness*2, y+case_thickness*2, z+case_thickness*2, r+0.1);
        rounded_box(x, y, z, r);
    }
}


module bottom() {
    // Translate up to snaps + pad
    translate([0,0,case_height/2.0+pad]) {
        difference() {
            hollow_box(case_width, case_length, case_height, case_corner_radius);
            // Cut at mouse height for now
            translate([0,0,mouse_height]) {
                cube( [200,200,case_height + case_thickness*2], center = true);
            }
        }
    }
}



////////////////////////////////////////////////////////////////////////////////
// Just testing
// Snaps are z == 0. No padding.
// This centers it on x,y.
module all_snaps() {
    translate([0, ( mouse_length + 2 * snap_thickness ) / 2.0, 0]) {
        translate([0,-snap_thickness,0]) {
            snaps();
            // snap_bottom();
        }
    }
}

all_snaps();
bottom();

    
