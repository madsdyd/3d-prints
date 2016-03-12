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


pad = 0.5;

$fn = 200;

// The major part
module part() {
    intersection() {
        cube([main_length, main_depth, main_height], center = true);
        translate([0,round_radius-main_depth/2.0,0])
           cylinder(r = round_radius, h = round_radius, center = true);
    }
}

// The cutter to make the main form
module cutter() {
    // The main "hole"
    translate([0,-th_bottom,(th_grip - th_curved)/2.0])
    # cube([main_length + pad, main_depth, main_height  - th_curved - th_grip], center = true);
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


main();