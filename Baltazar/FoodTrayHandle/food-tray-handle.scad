// Handle for a food tray

// On this, x = length, y = depth, z = height;

main_length = 98;
main_height = 17.5;
main_depth = 22.5;
round_radius = 165;

grip_length = 9.8;

// The thickness of the curved side
th_curved = 3;
// The thickness of the "bottom" of the form.
th_bottom = 2.4;
// And, the thickness of the last side
th_grip = 2;

// Pegs
peg_s_length = 2;
peg_s_depth = 14;
peg_s_height = 1;
peg_s_distance=35;

peg_l_length = 2;
peg_l_depth = 14;
peg_l_height = 2;
peg_l_distance=69;

hinge_diameter = 3;
hinge_length = 4;
hinge_dist = 16.5;
hinge_support=4;
// Needs handtuning...
hinge_offset = 2.4;

pad = 0.1;

$fn = 200;

// Calculated
main_cutter_height = main_height - th_curved - th_grip;

// The major part
module part() {
    intersection() {
        cube([main_length, main_depth, main_height], center = true);
        translate([0,round_radius-main_depth/2.0,0])
           cylinder(r = round_radius, h = round_radius, center = true);
    }
}

module peg(length, depth, height) {
    translate([0,(main_depth-depth)/2.0+pad,(main_cutter_height-height)/2.0+pad])
    difference() {
        cube([length,depth,height], center = true);
        
        translate([0,-(depth-height)/2.0,0])
        difference() {
            translate([0,-length/2.0,-length/2.0])
            cube([length+pad, length+pad, length+pad], center = true);
            rotate([0,90,0])
            cylinder(r = height/2.0, h = length+pad, center = true);
        }
    }
}

module hinge() {
    translate([(main_length-hinge_support)/2.0,(main_depth-hinge_dist)/2.0,(main_height-hinge_support)/2.0-hinge_offset])
    rotate([0,90,0]) {
        cube([hinge_support, hinge_dist, hinge_support], center = true);
        translate([0, -(hinge_dist - hinge_diameter) / 2.0, hinge_support/2.0-pad])
        cylinder( r = hinge_diameter/2.0, h = hinge_length + pad);
    }
}


// "Pegs" - some guidiance thing, I guess
module small_peg() {
    peg(peg_s_length, peg_s_depth, peg_s_height);
}

module small_pegs() {
    translate([-peg_s_distance/2.0,0,0])
    small_peg();
    translate([peg_s_distance/2.0,0,0])
    small_peg();
}

module large_peg() {
    peg(peg_l_length, peg_l_depth, peg_l_height);
}

module large_pegs() {
    translate([-peg_l_distance/2.0,0,0])
    large_peg();
    large_peg();
    translate([peg_l_distance/2.0,0,0])
    large_peg();
}

module main_cutter() {
    difference() {
        
        cube([main_length + pad, main_depth, main_cutter_height], center = true);
        // A "peg"
        small_pegs();
        large_pegs();
    }
}


// The cutter to make the main form
module cutter() {
    // The main "hole"
    translate([0,-th_bottom,(th_grip - th_curved)/2.0])
    main_cutter();
    // Cutting into the grip
    translate([0,-grip_length,-main_height / 2])
    cube([main_length + pad, main_depth, main_height], center = true);
}

module round_edge() {
    translate([0, main_depth/2.0-1, main_height/2.0-1])
    rotate([0,90,0])
    difference() {
        translate([-1,1,0])
        cube([2, 2, main_length+pad], center = true);
        cylinder(r = 1, h = main_length + pad, center = true);
    }

}

module round_edges() {
    round_edge();
    mirror([0,0,1]) round_edge();

}

module main() {
    difference() {
        part();
        cutter();
        round_edges();
    }
    hinge();
    mirror([1,0,0]) hinge();
}

main();
