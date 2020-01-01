// Model that holds a morsø forno pipe

pipe_radius = 115 / 2;
pipe_support_height = 0.66 * pipe_radius;
left_holder_thickness = 10;
right_holder_thickness = 10;
bottom_thickness = 10;

// Stop is a small tap
stop_offset = 30;
stop_height = 20;
stop_thickness = 6;

// Cutout is where to put the magnet
cutout_width = 32;
cutout_height = 10;
cutout_bottom_offset = 1.6;
cutout_edge_offset = 6;

// Material_saver is also a cutout
material_saver_offset = 6;

depth = cutout_width; // Controlled by magnet size
pad = 0.01;

// Basically a cube, with a round cutout, and a stop support thing.

$fn = 50;

// Calculate cube parameters
// z
cube_h = bottom_thickness + pipe_support_height;
// x
cube_w = left_holder_thickness + right_holder_thickness + stop_offset + pipe_radius * 2;
// y
cube_d = depth;



module cube_and_stop() {
    // The magnet cutout
    difference() {
        // cube and stop
        difference() {
            union() {
                cube([cube_w, cube_d, cube_h]);
                translate([cube_w - stop_thickness, 0, -stop_height+pad])
                cube([stop_thickness, cube_d, stop_height]);
            }
            // Cut out from the end
            translate([cube_w-stop_offset+pad,-pad,stop_thickness-pad])
            cube([stop_offset,depth+2*pad,pipe_support_height*2]);
        }

        // Magnet cutout
        translate([cube_w-stop_offset-cutout_width-cutout_edge_offset,-pad,cutout_bottom_offset])
        cube([cutout_width, depth+2*pad, cutout_height]);
    }
}

module cut_out_cube() {
    // Cut the pipe from the cube
    difference() {
        // Translate the cube (and stop), such that the pipe center is in 0.0
        translate([-left_holder_thickness-pipe_radius,0,-bottom_thickness-pipe_radius])
        cube_and_stop();

        // rotate cylinder around 0,0
        rotate([90,0,0])
        cylinder(r = pipe_radius, h = depth * 10, center = true);
    }
}

// This is a cube cutout, that gets stuff removed.
module material_saver() {

    difference() {
        translate([-left_holder_thickness-pipe_radius,0,-bottom_thickness-pipe_radius])
        translate([material_saver_offset,-pad,material_saver_offset])
        cube([cube_w-2*material_saver_offset-stop_offset, cube_d+2*pad, cube_h-2*material_saver_offset]);
        // rotate cylinder around 0,0
        rotate([90,0,0])
        cylinder(r = pipe_radius + material_saver_offset, h = depth * 10, center = true);        
    }
}



//material_saver();
//cube_and_stop();
//cut_out_cube();

module main() {
    difference() {
        cut_out_cube();
        material_saver();
        
    }
    
    
}

main();