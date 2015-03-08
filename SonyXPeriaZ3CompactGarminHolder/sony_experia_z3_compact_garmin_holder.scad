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



// Centered in x,y. Hole is at z = 0, downwards.
// top is at cylinder_height.
module ball_attachment() {

    // Everything is carved from a cylinder
    difference() {
        cylinder(h=cylinder_height, r=cylinder_radius);
        
        // Cut the walls
        difference() {
            cylinder(h=tab_height*2.0, r = cylinder_radius - wall_thickness, center = true);
            cylinder(h=tab_height*2.0, r = cylinder_radius - wall_thickness - tab_wall_spacing, center = true);
        }
        
        // TODO: 4 cuts. In some of it
         
        // Make the center hollow
        # translate([0,0,tab_overlap]){
            sphere( r = hollow_radius, center = true );
        }
    }
};





////////////////////////////////////////////////////////////////////////////////
// Main
ball_attachment();