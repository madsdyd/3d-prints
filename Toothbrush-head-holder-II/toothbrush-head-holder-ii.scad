// Toothbrush head holder in SCAD format












////////////////////////////////////////////////////////////
// Helper functions
// Obs, will only slice 0-180 degrees
// Start and end angles are relative to X axis
module cylinder_half_slice( r1, r2, h, start_angle, end_angle ) {
    module cut_cube() {
        rotate([0,0,-90]) {
            translate([0,-( r1 + r2 ),-h]) {
                cube([ 2* ( r1 + r2 ), 2*( r1 + r2 ), 3 * h ]);
            }
        }
    }

    // Rotate into place
    rotate([0,0,-(180-end_angle)]) {
        // Cut to limit of angles. 
        difference() {
            rotate([0,0,180-(end_angle-start_angle)]) {
                // First cut, limits to 180 degrees
                difference() {
                    cylinder( r1 = r1, r2 = r2, h = h );
                    cut_cube();
                }
            }
            cut_cube();
        }
    }
}


cylinder_half_slice( 10, 20, 40, 90, 180 );