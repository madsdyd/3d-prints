// Cover for "manhole" and holder for ultrasound module
// Designed to be printed in two parts

// Main principle is a disc with a hole and a "border", with a seperate holder on top.

// Variables

// Cover -- the main structure

// The diameter of the whole cover
cover_diameter = 180;
// Thickness of cover
cover_thickness = 3;

// The grid is because a solid is too extensive. Width of grid
cover_grid_width = 2;

// And distance between grid stuff
cover_grid_distance = 6;

// The pipe holder "sticks up"

// The inner diameter fits the pipe
pipe_holder_inner_diameter = 50;
// The thickness of the wall
pipe_holder_thickness = 3;
// And, the height, above the cover, of the holder
pipe_holder_height = 13;
// And, the offset from center of center.
pipe_holder_offset = 45;


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
pipe_holder_inner_radius = pipe_holder_inner_diameter / 2.0;


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


module pipe_holder_with_cover() {
    // Translate + walls
    difference() {
        union() {
            // Translate
            cover();
            // outer
            translate([pipe_holder_offset, 0, 0.5*(pipe_holder_height)]) {
                cylinder(
                    h = cover_thickness + pipe_holder_height,
                    r = pipe_holder_inner_radius + pipe_holder_thickness - inner_hole_adjustment,
                    center = true);
            }
        }
        
        // Cutout inner cylinder
        translate([pipe_holder_offset, 0, 0.5*pipe_holder_height]) {
            cylinder(
                h=cover_thickness + pipe_holder_height + 2*pad,
                r = pipe_holder_inner_radius + inner_hole_adjustment,
                center = true);
        }
    }
}



pipe_holder_with_cover();
