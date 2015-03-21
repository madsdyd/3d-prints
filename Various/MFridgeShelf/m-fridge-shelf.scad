// Fridge shelf thingy


length = 30;

cyl_width = 13;
cyl_height = 9.7;

cube_width = 18.5;
cube_height = 7.6;
cube_offset = 4;

shelf_cut_height = 4.4;
shelf_cut_side_offset = 3.5; // Offset from side of cylinder.
shelf_cut_end_offset = 2; // Offset from end of holder.

// The stuff that rests on the fridge
holder_rest_diameter = 6.9; // r = d/2
holder_rest_height = 11;
holder_rest_offset = 9;
pad = 0.05;

$fn = 50;

module thing() {
    // Cut the part the shelf rests in from all of this
    difference() {
        union() {
            

            // The cylinder part that goes against the back.
            scale([cyl_width, 1, cyl_height]) {
                rotate([-90,0,0]) {
                    cylinder( r = 0.5, h = length );
                }
            }
            // The cube part, that the class rests in.
            // And cut.
            translate([cube_offset,0,cube_height / 2.0]) {
                rotate([-90,0,0]) {
                    cube([cube_width, cube_height, length]);
                }
            }

        }
        // Cube cut
        translate([shelf_cut_side_offset - cyl_width / 2.0,shelf_cut_end_offset,shelf_cut_height / 2.0]) {
            rotate([-90,0,0]) {
                cube([cube_width * 2, shelf_cut_height, length]);
            }
        }
    }
    // Add a cylinder for the stuff to rest in.
    translate([holder_rest_offset, -holder_rest_height + pad, 0])
    # rotate([-90,0,0]) {
        cylinder( r = holder_rest_diameter / 2.0, h = holder_rest_height );
    }
    
    
}


thing();