// Fridge shelf thingy


length = 30;

cyl_width = 13;
cyl_height = 9.7;

cube_width = 18.5;
cube_height = 7.6;
cube_offset = 4;

shelf_cut_height = 4.2;
shelf_cut_side_offset = 3.5; // Offset from side of cylinder.
shelf_cut_end_offset = 2; // Offset from end of holder.

// The stuff that rests on the fridge
holder_rest_diameter = 6.9; // r = d/2
holder_rest_height = 11;
holder_rest_offset = 9;

// To keep manifold
pad = 0.05;

// Back support is a cube placed the right place.
back_support_length = 18.5;

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

            // And, add the back support.
            translate([0,length - cube_height,cube_height / 2.0]) {
                rotate([-90,0,90]) {
                    cube([cube_height, cube_height, back_support_length + cyl_width/2.0]);
                }
            }
        }
        // Cube cut
        translate([shelf_cut_side_offset - cyl_width / 2.0,shelf_cut_end_offset,shelf_cut_height / 2.0]) {
            rotate([-90,0,0]) {
                cube([cube_width * 2, shelf_cut_height, length]);
            }
        }
        // Cut part of the corner
        translate([cube_offset+cube_width-10,length - 10,0]) {
            difference() {
                translate([0,0,-10]) cube([20,20,20]);
                cylinder( r = 10, h = cube_height * 2.0, center = true );
            }
        }
    }
    // Add a cylinder for the stuff to rest in.
    translate([holder_rest_offset, -holder_rest_height + pad, 0])
    rotate([-90,0,0]) {
        cylinder( r = holder_rest_diameter / 2.0, h = holder_rest_height );
    }
}


rotate([-90,0,0]) thing();