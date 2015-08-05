// Pool hose holder, for fixing two hoses to an edge.

$fn = 180;

// Variables

// The outer diameter of the hose to hold
// Note that some hoses expand and shrink when pressure/suction is applied.
hose_outer_diameter = 40;

// The overall angle for the hose holder
hose_holder_angles = 250;

// Number of hoses to hold. Minimum is 1
number_of_hoses = 2;

// Spacing between hoses. 0 means that the will touch
hose_holder_spacing = 2;

// Width of the thing to fasten too. Will become inside width
solid_width = 137;

// Extra width
solid_extra_width = 3;

// Substract/flex. This is substracted in *each* side.
solid_substract_width = 3;

// Solid gribbing
solid_grib_height = 40;

// Thickness
overall_thickness = 2.1;

// Width of everything
overall_width = 15;

// Helps with previews, etc.
pad = 0.1;


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

module hose_holder() {


}

// A single holder, based in 0,0,0, oriented along x axis.
hose_holder_angle = hose_holder_angles / 2;
hose_outer_radius = hose_outer_diameter / 2;
hose_holder_inside_radius = hose_outer_radius;
hose_holder_outside_radius = hose_holder_inside_radius + overall_thickness;
module hose_holder() {
    rotate([0,0,90])
    rotate([0,90,0])
    translate([-hose_holder_outside_radius,0,-overall_width/2])
    difference() {
        union() {
            cylinder_half_slice( r1 = hose_holder_outside_radius, r2 = hose_holder_outside_radius, h = overall_width, start_angle = -hose_holder_angle, end_angle = 0 );
            cylinder_half_slice( r1 = hose_holder_outside_radius, r2 = hose_holder_outside_radius, h = overall_width, start_angle = 0, end_angle = hose_holder_angle );
        }
        translate([0,0,-pad])
        union() {
            cylinder_half_slice( r1 = hose_holder_inside_radius, r2 = hose_holder_inside_radius, h = overall_width+2*pad, start_angle = -hose_holder_angle-1, end_angle = 0 );
            cylinder_half_slice( r1 = hose_holder_inside_radius, r2 = hose_holder_inside_radius, h = overall_width+2*pad, start_angle = 0, end_angle = hose_holder_angle+1 );
        }
    }
            
}

module hose_holders() {
    // Iterate, then translate into place.
    single_width = hose_holder_outside_radius * 2 + hose_holder_spacing;
    total_width = number_of_hoses * hose_holder_outside_radius * 2 + (number_of_hoses - 1 ) * hose_holder_spacing;
    translate([-total_width/2 + hose_holder_outside_radius, 0, 0])
    for ( n = [1:number_of_hoses] ) {
       translate([(n-1)*single_width,0,0]) {
           hose_holder();
       }
   }
}

module tab() {
    // Tabs in the end.
    translate([(solid_width+solid_extra_width-solid_substract_width)/2,0,-(solid_grib_height-overall_thickness)/2])
    // This is a shear
    // See http://www.cs.colorado.edu/~mcbryan/5229.03/mail/55.htm
    multmatrix( m = [
            [ 1, 0, solid_substract_width/solid_grib_height, 0 ],
            [ 0, 1, 0, 0 ],
            [ 0, 0, 1, 0 ],
            [ 0, 0, 0, 1 ] ] )
    rotate([0,90,0])
    cube([solid_grib_height, overall_width, overall_thickness], center = true);
}

module fastener() {
    // A cube is the base. It is based on z = 0.
    cube([solid_width + solid_extra_width, overall_width, overall_thickness], center = true);
    tab();
    rotate([0,0,180]) tab();
    
}


module main() {

    // The fastener
    fastener();
    
    // Translate just a tad up
    translate([0,0,overall_thickness/2-pad])
    hose_holders();
}

// Rotate to match best build setup
rotate([90,0,0])
main();