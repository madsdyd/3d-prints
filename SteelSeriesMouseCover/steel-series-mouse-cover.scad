// Steel series mouse, pro gaming laser mouse, cover.


// Padding manifolds
pad = 0.1;

// This is a snap holder in the front. Two are used, one on each side of the wire.
module front_snap( x_offset, width, inner_height, thickness, overlap, overlap_angle ) {
    translate( [x_offset + width / 2.0, thickness / 2.0, (inner_height + thickness) / 2.0] ) {
        cube([width, thickness, inner_height + thickness], center = true);
        // TODO: the 4.2 can be calculated, if I cared...
        translate( [ -width/2.0, 0, ( overlap + inner_height + thickness ) / 2.0 - 4.2 ] ) {
            rotate( [overlap_angle, 0, 0] ) {
                cube([width, thickness, overlap], center = false );
            }
        }

    }
}

module front_snaps() {
    front_snap( 5, 10, 14, 2, 5, 60 );
    front_snap( -15, 10, 14, 2, 5, 60 );
}
    
module snaps() {
    front_snaps();
    
}

snaps();

