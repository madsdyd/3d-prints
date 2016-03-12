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
    cube([length,depth,height], center = true);
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

module main() {
    difference() {
        part();
        cutter();
    }
    
}

// main_cutter();
main();