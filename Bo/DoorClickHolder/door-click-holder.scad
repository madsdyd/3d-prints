// Weird click holder to door in orangeri

// 5 and 15 degrees.


base_width = 24.5;
base_height = 19.5 + 3.0; // Add 3 mm.
base_thickness = 5.0;
base_hole_offset = 8 + 3.0 - 2.0; // Offset center. - move 3 mmm
base_hole_radius = 3.75 + 0.25;

ludo_base_height = 12.5;
ludo_total_height = 21;
ludo_ball_radius = 9.7 / 2.0;
ludo_base_radius = 7.4 / 2.0;
ludo_top_radius = 5.5 / 2.0;

ludo_offset = 6.5; // Add fudge here, to increase distance
ludo_rel_angle = 5;

// The support
support_width = base_width;
support_height = 12.5;
support_thickness = 4.5;
support_thickness_min = 3.0;
support_rel_angle = ludo_rel_angle;

// Cut
cut_rel_angle = 15;


// Consts
$fn = 50;
pad = 0.05;

// The grabbers are shaped as ludo brick.
module ludo() {
    cylinder( r1 = ludo_base_radius, r2 = ludo_top_radius, h = ludo_base_height );
    // Translate to full height
    translate( [0,0,ludo_total_height - ludo_ball_radius] ) {
        sphere( r = ludo_ball_radius );
    }
}

module ludos() {
    translate([ludo_offset,0,0]) ludo();
    translate([-ludo_offset,0,0]) ludo();
}

module base() {
    difference() {
        // The base
        translate([-base_width / 2, 0, 0]) {
            cube([base_width, base_height, base_thickness]);
        }

        // The main hole
        translate([0,base_hole_offset,-pad]) {
            cylinder( r = base_hole_radius, h = base_thickness + 2*pad );
        }
    }

    // The Ludos.
    // The translation is slightly inaccurate, because of the rotation
    translate([0,base_height-0.3,ludo_base_radius]) {
        rotate([-90+ludo_rel_angle,0,0]) {
            ludos();
        }
    }

    // The support. Tricky stuff
    difference() {
    translate([0,base_height,0.5]) {
        rotate([90+support_rel_angle,0,0]) {
            translate([-support_width / 2.0,0,0]) {
                cube([support_width, support_height, support_thickness]);
            }
        }
    }
    translate([0,base_height-2.3,0.5]) {
        rotate([90+cut_rel_angle,0,0]) {
            translate([-support_width/ 2.0 - pad ,0,0]) {
                cube([support_width + 2*pad, support_height, support_thickness]);
            }
        }
    }

}
    
    
}

base();
