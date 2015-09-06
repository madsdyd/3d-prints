// Toothbrush head holder in SCAD format

$fn = 180;

// Variables

// Radius of the cup to hang on, inside
cup_radius = 45;

// Height of the holder (the part that the toothbrush head goes into
inner_height = 39;

// Radius of the cutout for the head
cutout_radius = 12;

// Side thickness. You probably want this to match your extruder
cutout_side_thickness = 0.4 * 3;

// Bottom thickness. You probably want this to match your layer height
cutout_bottom_thickness = 0.3 * 4;

////////////////////////////////////////////////////////////////////////////////
// Calculated stuff

// This is the center of the toothbrush. We calculate the angle based on this.
center_radius = cup_radius - cutout_side_thickness - cutout_radius;

// This is the distance that out cutout angle most cover.
// Using notation from http://mathworld.wolfram.com/Circle-CircleIntersection.html
circ_R = center_radius;
circ_r = cutout_radius;
circ_d = center_radius;
circ_x = ( circ_d*circ_d - circ_r * circ_r + circ_R * circ_R ) / ( 2 * circ_d );
echo ("circ_x: ", circ_x );
circ_half_angle = asin( circ_x / circ_R);
echo ("circ_half_angle: ", circ_half_angle); 

shell_total_height = inner_height + cutout_bottom_thickness;

// TODO: Add the cutout thickness here
shell_total_angle = circ_half_angle * 2;


pad = 0.05;


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
module old_shell( radius, height, width, depth, cut_height, side_thickness, thickness, pad ) {
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



module  shell() {
    cylinder_half_slice( cup_radius, cup_radius, shell_total_height, 0, shell_total_angle);


}

shell();


