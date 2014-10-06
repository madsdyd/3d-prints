// Door stop

// The height of the "straight" part of the doorstop
base_height = 64;

// The inner diameter of the top. Outer diameter is this + 2 * wall_thickness
top_inner_diameter = 23;

// The inner diameter of the botton. Outer diameter is this + 2 * wall_thickness
bottom_inner_diameter = 25.3;

// The height of the thing that the stop goes over
knob_height = 30;

// Thickness of the walls
wall_thickness = 2.5;

// Stop height. A ball with this radius is constructed on the top.
stop_height = 6.5;


//// CODE

// Fillet function. 

/* Create a round fillet, used for rounding corner on e.g. cylinders.
 *
 * Create a fillet like this, and either difference (for outside fillets) or union
 * (for inside fillets).
 *
 * @param outer_radius The radius of the resulting fillet
 * @param fillet_radius The radius of actual fillet (in the fillet).
 * @param smoot How smoot to make the resulting fillet.
*/
module fillet_round_45_degree( outer_radius = 10, fillet_radius = 1.5, smooth = 90 ) {
    // Based on stuff from http://www.iheartrobotics.com/2011/02/openscad-tip-round-2-of-3.html
    
    // Padding to maintain manifold - set to 0.0 for now.
    pad = 0.0; 

    // Main parameter, the outside radius of the fillet.
    // outer_radius = 25.3/2.0;

    // This seems to be a translation offset from z, really.
    ct = 0;

    // Number of facets of rounding cylinder
    // smooth = 90;   

    // radius is the radius of the fillet
    // fillet_radius = 1.5;
    
    difference() {
        rotate_extrude(convexity=10, $fn = smooth)
        translate([outer_radius-ct-fillet_radius+pad,ct-pad,0])
        square(fillet_radius+pad,fillet_radius+pad);
        rotate_extrude(convexity=10, $fn = smooth)
        translate([outer_radius-ct-fillet_radius,ct+fillet_radius,0])
        circle(r=fillet_radius,$fn=smooth);
    }
}

// Some square fillet thingy.
module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}


// Base is sort of solid, will difference later
module base( height, bottom_r, top_r ) {
    difference() {
        cylinder( h = height, r1 = bottom_r, r2 = top_r );
        
        translate([0,0,height+0.05]) {
            rotate([0,180,0]) {
                fillet_round_45_degree( outer_radius = top_r+0.05, fillet_radius = 3);
            }
        }
    };
}

module hollower() {
    translate([0,0,-0.05]) {
        intersection() {
            base( base_height, bottom_inner_diameter / 2.0 - wall_thickness, top_inner_diameter / 2.0 - wall_thickness);
            // Just make the cylinder "large enough"
            cylinder( r = bottom_inner_diameter, h = knob_height );
        }
    }
}
    

module doorstop ( ) {
    difference() {
        union() {
            base( base_height, bottom_inner_diameter / 2.0, top_inner_diameter / 2.0 );
            translate( [0,0,base_height]) {
                sphere( r = stop_height );
            }
        }
        // Substract another base. Kind of cheating.
        hollower();
    }
}

// hollower();

doorstop();



// fillet( 10, 10 );

// Fillet, chi