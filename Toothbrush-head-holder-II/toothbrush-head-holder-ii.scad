// Toothbrush head holder in SCAD format

$fn = 180;

////////////////////////////////////////////////////////////
// Helper functions
// Obs, will only slice 0-180 degrees, but the angles can go from
// [-180,0] => [0,180]
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
// Test
// cylinder_half_slice( 10, 20, 40, 90, 180 );
// cylinder_half_slice( 10, 20, 40, -10, 90 );

////////////////////////////////////////////////////////////
// Module that creates a single holder

// Creates a single shell
// radius are outer measures
// height, width and depth is internal measures,  ie. the space for the head
// OBS: width is measured on the top of the holder.
// side_thickness is also measured in angles
// thickness is measured in mm
// pad is padding to keep manifold
module shell( r_low, r_high, height, width, depth, cut_height, side_thickness, thickness, pad ) {
    // TODO: Calculate stuff
    // Change width parameter to be in mm, calculate from radius.
    // Make sides boxes, so they have the same thickness everywhere.
    angular_width = width;
    
    difference() {
        // Main cylinder slice, everything is cut from this.
        cylinder_half_slice( r_low, r_high, height + thickness,
            -side_thickness - angular_width / 2.0, side_thickness + angular_width / 2.0 );

        // The space for the head
        // TODO: Cut more
        translate([0,0,thickness]) {
            difference() {
                // Inner side of outermost side
                cylinder_half_slice( r_low - thickness, r_high - thickness, height + pad,
                    - angular_width / 2.0, angular_width / 2.0 );
                // Need to substract yet another cylinder, to allow for the inner wall.
                cylinder_half_slice( r_low - thickness - depth, r_high - thickness - depth, height + pad,
                    - angular_width / 2.0, angular_width / 2.0 );
            }
        }
            
        // Cuts the inner part of the circle completely away
        # translate([0,0,-pad]) {
            cylinder_half_slice(
                r_low - 2 * thickness - depth,
                r_high - 2* thickness - depth,
                height + thickness + pad * 2,
                -side_thickness - angular_width / 2.0 - 10*pad, side_thickness + angular_width / 2.0 + 10*pad );
        }
    }

        
    
}


top_radius = 45;
bottom_radius = 35;
inner_height = 39;
inner_width_in_angles = 25;
depth = 17;
cut_heigth = 25;
// TODO: Calculate to match thickness
side_thickness_in_angles = 2;
front_back_thickness = 1.2;
pad = 0.05;

shell( bottom_radius, top_radius,
    inner_height, inner_width_in_angles, depth, cut_height,
    side_thickness_in_angles, front_back_thickness, pad );



