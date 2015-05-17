// Rough ketcher for build a bear

// Total length of the ketcher
total_length = 205;

// Head outside width
head_width = 76;

// Head outside height
head_height = 106;

// thickness of frame, outside
frame_thickness = 5.5;

// height of frame, outside
frame_height = 9.0;

// handle_thickness = 11.5;

handle_length = 100;

$fn = 50;

pad = 0.5;

string_radius = 1.2;

// Strings
module horz_string(offset, length) {
    translate([-length  / 2.0, offset, frame_height / 2.0])
    rotate([0,90,0])
    cylinder(r = string_radius, h = length);
}
// Strings
module vert_string(offset, length) {
    translate([offset, length / 2.0, frame_height / 2.0])
    rotate([90,0,0])
    cylinder(r = string_radius, h = length);
}


// The head of the ketcher
// Modelled as a warped cylinder, that gets rounded
module head() {
    translate([0,head_height / 2.0 - pad,-frame_height/2.0]) {
        difference() {
            // Outer cylinder
            scale( [head_width, head_height, frame_height] ) {
                cylinder( r = 0.5, h = 1.0 );
            }
            // Cylinder cut
            translate([0,0,-pad/2.0]) {
                scale( [head_width - 2*frame_thickness, head_height- frame_thickness * 2, frame_height + 2*pad] ) {
                    cylinder( r = 0.5, h = 1.0 );
                }
            }
        }

        // Strings - sigh.
        horz_string(42, 40);
        horz_string(35, 50);
        horz_string(28, 55);
        horz_string(21, 65);
        horz_string(14, 70);
        horz_string(7, 70);
        horz_string(0, 70);
        horz_string(-7, 70);
        horz_string(-14, 70);
        horz_string(-21, 65);
        horz_string(-28, 55);
        horz_string(-35, 50);
        horz_string(-42, 40);

        vert_string(-28,65);
        vert_string(-21,80);
        vert_string(-14,90);
        vert_string(-7,100);
        vert_string(0,100);
        vert_string(7,100);
        vert_string(14,90);
        vert_string(21,80);
        vert_string(28,65);
    }
}



// handle
module handle() {
    rotate([90,0,0]) {
    cylinder(r = frame_height / 2.0, h = handle_length);
    }
}

// Testing
head();    
handle();    