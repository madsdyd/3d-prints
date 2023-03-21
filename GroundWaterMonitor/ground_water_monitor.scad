// Cover for "manhole" and holder for ultrasound module
// Designed to be printed in two parts

// Main principle is a disc with a hole and a "border", with a seperate holder on top.

// Variables

// Cover

// The diameter of the whole cover
cover_diameter = 180;
// Thickness of cover
cover_thickness = 3;

// The grid is because a solid is too extensive. Width of grid
cover_grid_width = 2;

// And distance between grid stuff
cover_grid_distance = 6;

// Consts

// Inner radius adjustment. This seems to work with 0.25
inner_hole_adjustment = 0.25;
// Pad -- for padding stuff
pad = 0.05;
// Neato circles.
$fn = 100;


// Calculated values
cover_radius = cover_diameter / 2.0;
num_grid_lines = ceil(cover_diameter / (cover_grid_width + cover_grid_distance) + 2);


module one_grid() {
    translate([-(num_grid_lines/2*(cover_grid_width+cover_grid_distance)),0,0]) {
        for( i = [ 0 : num_grid_lines] ) {
            // Translate and do a grid line. Length needs to be fixed.
            translate([i*(cover_grid_width + cover_grid_distance),0, 0]) {
                cube([cover_grid_width, cover_diameter + 2*pad, cover_thickness], center=true);
            }
        }
    }
}


module cover() {

    intersection() {
        union() {
            // X line grid
            one_grid();
            
            // Y line grid
            rotate([0,0,90]) one_grid();
        }
        // Intersect with larger cylinder...
        cylinder(h = cover_thickness + 2*pad, r = cover_radius, center = true);
    }
    // And, outside diameter cylinder
    difference() {
        cylinder(h = cover_thickness, r = cover_radius, center = true);
        cylinder(h = cover_thickness + 2 * pad, r = cover_radius - cover_grid_width, center=true);
    }
    


}



cover();
