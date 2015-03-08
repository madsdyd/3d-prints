// Holder for Garmin base.

// diameter of ball
ball_diameter = 16.8;

// additional gap * in each side *. Diameter + 2 gap = hole diameter
ball_gap = 0.1;

// Tab thickness is the thickness of the tabs
tab_thickness = 2.0;

// Tag overlap is how much over the center of the ball, the tabs grab.
tab_overlap = 1.0;

// Amount of space between tabs and walls
tab_wall_spacing = 1.0;

// Slits are cut through the tabs.
slit_thickness = 3.0;

// wall thickness
wall_thickness = 1.2;

// base thickness, is the thickness of the material from the edge of the ball to where the mount goes.
base_thickness = 2.0;

// pad, to aviod non-manifold
pad = 0.1;

////////////////////////////////////////////////////////////////////////////////
// Calculated stuff.

////////////////////////////////////////////////////////////
// ball attachment stuff
hollow_radius = ( ball_diameter + 2* ball_gap ) / 2.0;
cylinder_radius = hollow_radius + tab_thickness + tab_wall_spacing + wall_thickness;
cylinder_height = base_thickness + hollow_radius + tab_overlap;

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

    // Everything is carved from a cylinder
    difference() {
        cylinder(h=cylinder_height, r=cylinder_radius);
        
        // Cut the walls
        difference() {
            cylinder(h=tab_height*2.0, r = inner_tube_outer_radius + tab_wall_spacing , center = true);
            cylinder(h=tab_height*2.0, r = inner_tube_outer_radius, center = true);
        }
        
        // TODO: 4 cuts. In some of it
        translate([0,0,slit_height / 2.0 - pad]) {
            cube([inner_tube_outer_radius*2.0+pad, slit_thickness, slit_height + 2*pad], center = true );
            cube([slit_thickness, inner_tube_outer_radius*2.0+pad, slit_height + 2*pad], center = true );
        }
        
        // Make the center hollow
        translate([0,0,tab_overlap]){
            sphere( r = hollow_radius, center = true );
        }
    }
};





////////////////////////////////////////////////////////////////////////////////
// Main
ball_attachment();