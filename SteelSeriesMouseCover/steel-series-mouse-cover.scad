// Steel series mouse, pro gaming laser mouse, cover.


mouse_length = 126;
// Smallest waist
mouse_waist = 58 + 3.0;
// Smallest place at, measured from front.
mouse_waist_at = 55;

// thickness whereever it is used
snap_thickness = 2.0;

// Padding manifolds
pad = 0.1;

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


snaps();
snap_bottom();

