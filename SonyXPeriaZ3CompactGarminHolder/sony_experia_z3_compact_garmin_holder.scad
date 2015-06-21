// Holder for Garmin base.

include <nuts_and_bolts.scad>;

////////////////////////////////////////////////////////////
// Variables for the thing that grabs the ball.

// diameter of ball
// Print 3 and 4 was ok, and used 16.8. Try slightly smaller
ball_diameter = 16.8;
// additional gap * in each side *. Diameter + 2 gap = hole diameter
// Print 3 and 4 was OK with 0.1. Try 0.
// 0 broke, we add 0.1
ball_gap = 0.1;
// Tab thickness is the thickness of the tabs
// Print 3 was OK, with 2.0. Try with 2.4 to make it slightly tighter.
// 2.4 was probably too much, they broke.. Back to 2.0
tab_thickness = 2.0;
// Tab overlap is how much over the center of the ball, the tabs grabs
// Print 3 was OK, with 3.0, Try with 3.6 to make it slightly tighter.
tab_overlap = 3.6;
// Amount of space between tabs and walls
tab_wall_spacing = 1.5;
// Slits are cut through the tabs.
slit_thickness = 3.0;
// wall thickness
wall_thickness = 1.2;
// base thickness, is the thickness of the material from the edge of the ball to where the mount goes.
base_thickness = 1.0;

// Variables for the nut and bolt tightener
// m3
nut_size = 3;
nut_support_radius = 3.6;
// Nudge against round thing here.
nut_nudge = 0.5;
// Calculated below
// nut_support_depth = base_thickness+wall_thickness+tab_thickness;


////////////////////////////////////////////////////////////
// Variables for the phone holder
// By adding something extra here, the phone holder gets enlarged.
// Print with 30% infill?
phone_width = 127.3 + 0.2 + 0.5;
phone_height = 64.9 + 0.2 + 0.5;
phone_holder_thickness = 2;
phone_tab_thickness = 2.4;
phone_tab_width = 10;
phone_thickness = 8.6 - 1.0; // Matches the tabs... I hope

phone_tab_flip_radius = 1.5;
phone_tab_flip_offset = -0.5;
// Control scale of the flips on the holder tabs.
// top and bottom
phone_tab_flip_scale_vert = 1.3;
// Sides
phone_tab_flip_scale_horz = 1.0;

// How much to offset the top dual tabs
phone_top_tab_offset = 25;
// Controls how much to scale the cylinder.
// TODO: This could be calculated, simple linear formula
phone_top_tab_cyl_scale = 0.75;

// pad, to aviod non-manifold
pad = 0.1;

// Increase circles
$fn = 70;

////////////////////////////////////////////////////////////////////////////////
// Calculated stuff.

////////////////////////////////////////////////////////////
// ball attachment stuff
hollow_radius = ( ball_diameter + 2* ball_gap ) / 2.0;
// The ball attachment is cut from this cylinder
cylinder_radius = hollow_radius + tab_thickness + tab_wall_spacing + wall_thickness;
cylinder_height = base_thickness + hollow_radius + tab_overlap;
nut_support_depth = cylinder_radius - ball_diameter / 2.0 +1;
// tab height is the height of the free space behind the tabs. It
// should be <= than hollow_radius + tab_overlap
tab_height = hollow_radius + tab_overlap;

// Slit height is almost the same as tab height
slit_height = tab_height - 2.0;

// Inner tube outer radius is needed for the slits.
inner_tube_outer_radius = cylinder_radius - wall_thickness - tab_wall_spacing;

// Centered in x,y. Hole is at z = 0, downwards.
// top is at cylinder_height.
module ball_attachment() {


    difference() {
        
        union() {
            
            // Most is carved from a cylinder
            difference() {
                cylinder(h=cylinder_height, r=cylinder_radius);
                
                // Cut the walls
                difference() {
                    cylinder(h=tab_height*2.0, r = inner_tube_outer_radius + tab_wall_spacing , center = true);
                    cylinder(h=tab_height*2.0, r = inner_tube_outer_radius, center = true);
                }
                
                // Cuts by cubes
                for ( z = [0, 60, 120] ) {
                    rotate([0,0,z]) {
                        translate([0,0,slit_height / 2.0 - pad]) {
                            cube([inner_tube_outer_radius*2.0+pad, slit_thickness, slit_height + 2*pad], center = true );
                            // cube([slit_thickness, inner_tube_outer_radius*2.0+pad, slit_height + 2*pad], center = true );
                        }
                    }
                }

            }
            
            // Add a cylinder to put a nut and bolt into
            translate([0,ball_diameter/2.0+nut_support_depth/2.0-nut_nudge,tab_overlap]) {
                rotate( [270,0,0] ) {
                    cylinder( r = nut_support_radius, h = nut_support_depth, center = true );
                }
            }
            
            // A nut hole. What ever that is

            
        }
        // Cut by nut and bolt. This is not really convenient.
        translate([0,ball_diameter/2.0+nut_support_depth/2.0-nut_nudge,tab_overlap]) {
            rotate( [270,0,0] ) {
                // Two nuts, to ensure depth enough on slopy cut
                translate([0,0,-nut_support_depth/2.0-pad]) {
                    nutHole(nut_size);
                }
                translate([0,0,-nut_support_depth/2.0-pad+nut_nudge]) {
                    nutHole(nut_size);
                }
                // A cylinder for the screw
                rotate([180,0,0])
                translate([0,0,-nut_support_depth/2.0-pad]) {
                    boltHole(nut_size, length = nut_support_depth);
                }
            }
        }
        
        // Make the center hollow
        translate([0,0,tab_overlap]){
            sphere( r = hollow_radius, center = true );
        }
    }
};

// This is a tab on each arm, that holds the phone "clicked" in place.
module holder_tab( scale_factor ) {

    // Round the tab
    intersection() {
        union() {
            // tab arm
            cube([phone_tab_width, phone_tab_thickness, phone_thickness], center = true);
            
            // tab click top
            scale([1,scale_factor,1]) {
                translate([0,0,phone_thickness / 2.0 + phone_tab_flip_radius + phone_tab_flip_offset ]){
                    rotate([0,90,0]) {
                        cylinder( h = phone_tab_width, r = phone_tab_flip_radius, center = true);
                    }
                }
            }
        }
        
        translate([0,phone_tab_thickness / 2.0, 0] ) {
            cylinder( r = phone_tab_width / 2.0, h = phone_thickness * 2, center = true );
        }
    }
    
    // Does not work, but fun.
    /*
    multmatrix( m = [
    [1, 0, 0, 0],
    [0, 1, 0.4, -phone_tab_thickness / 2.0],
    [0, 0, 1, -phone_thickness / 2.0],
    [0, 0, 0,  1] ] ) {
    # cylinder( r = phone_tab_width / 2.0, h = phone_thickness, center = false );
    }
    */
    
    // Add sphere below, cut off front
    difference() {
        translate([0,phone_tab_thickness / 2.0,-phone_thickness / 2.0] ) {
            sphere( r = phone_tab_width / 2.0 );
        }
        translate([0,phone_tab_width+phone_tab_thickness/2.0-pad,0]) {
            cube([phone_tab_width * 2, phone_tab_width * 2 , phone_thickness], center = true );
        }
    }
    
}

// This is the actual holder
module z3_compact_holder() {

    // ARMS
    // Arms made of cylinders, cuttet with cube
    // TODO: The r1 of all these cylinders should be max of cylinder_height and width, I think, or user set
    difference() {
        // But, also cut arms with sligtly smaller cylinder than the one for attaching
        difference() {
            translate([0,0,cylinder_height]) {
                // Right
                rotate([0,90,0] ) {
                    cylinder(r1 = cylinder_height, r2= phone_tab_width / 2.0 , h = phone_width / 2.0 );
                    // cylinder(r1 = cylinder_radius, r2= phone_tab_width / 2.0 , h = phone_width / 2.0 );
                }
                // Left
                rotate([0,270,0] ) {
                    cylinder(r1 = cylinder_height, r2= phone_tab_width / 2.0 , h = phone_width / 2.0 );
                }
                // Bottom
                rotate([90,0,0] ) {
                    cylinder(r1 = cylinder_height, r2= phone_tab_width / 2.0 , h = phone_height / 2.0);
                }
                // Top is different.
                translate([phone_top_tab_offset,0,0]) {
                    rotate([270,0,0] ) {
                        cylinder(r1 = cylinder_height * phone_top_tab_cyl_scale, r2= phone_tab_width / 2.0 , h = phone_height / 2.0 );
                    }
                }
                translate([-phone_top_tab_offset,0,0]) {
                    rotate([270,0,0] ) {
                        cylinder(r1 = cylinder_height * phone_top_tab_cyl_scale, r2= phone_tab_width / 2.0 , h = phone_height / 2.0 );
                    }
                }
            }
            cylinder(h=cylinder_height, r=cylinder_radius-pad);

            
        }


        // Cut everything with a big cube
        translate ([0,0,cylinder_height * 2.0+pad]) {
            cube([phone_width * 2, phone_height * 2, cylinder_height * 2], center = true );
        }

    }

    // Add the tabs.
    // BOTTOM
    translate([0,-phone_height / 2.0 - phone_tab_thickness / 2.0, cylinder_height + phone_thickness / 2.0] ) {
        holder_tab( phone_tab_flip_scale_vert );
    }
    // Add the tabs.
    // TOP
    // Different, needs two, translated 2.5 cm to each side
    translate([25,+phone_height / 2.0 + phone_tab_thickness / 2.0, cylinder_height + phone_thickness / 2.0] ) {
        rotate([0,0,180]) {
            holder_tab( phone_tab_flip_scale_vert );
        }
    }
    translate([-25,+phone_height / 2.0 + phone_tab_thickness / 2.0, cylinder_height + phone_thickness / 2.0] ) {
        rotate([0,0,180]){
            holder_tab( phone_tab_flip_scale_vert );
        }
    }
    // LEFT
    translate([-phone_width / 2.0 - phone_tab_thickness / 2.0, 0, cylinder_height + phone_thickness / 2.0] ) {
        rotate([0,0,270]) {
            holder_tab( phone_tab_flip_scale_horz );
        }
    }
    // RIGHT
    translate([+phone_width / 2.0 + phone_tab_thickness / 2.0, 0, cylinder_height + phone_thickness / 2.0] ) {
        rotate([0,0,90]) {
            holder_tab( phone_tab_flip_scale_horz );
        }
    }
}



////////////////////////////////////////////////////////////////////////////////
// Main
union () {
    ball_attachment();

    z3_compact_holder();
}