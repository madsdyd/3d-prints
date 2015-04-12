// Ant poison trap/buffer that matches the stuff made by ECOstyle in DK

outer_radius = 57 / 2.0;
default_thickness = 1.6;
stiffener_width = 4;
total_height = 15;
trap_outside_height = 4;
trap_depth = 2;
ledge_width = 4;


lid_grip_height = total_height - trap_outside_height;
trap_width = 27.5;


pad = 0.05;
$fn = 50;

// Build the walls
module walls() {
    // The stuff that goes into the lid
    difference() {
        cylinder( r = outer_radius, h = lid_grip_height );
        // Cut main hole
        translate([0,0,default_thickness]) {
            cylinder( r = outer_radius - default_thickness, h = lid_grip_height );
        }
        // Cut hole through to ground
        translate([0,0,-pad]) {
            cylinder( r = outer_radius - default_thickness - stiffener_width, h = lid_grip_height );
        }
    }
}

// Build a leaf/trap
module leaf( radius, width, thickness ) {
    intersection() {
        cylinder( r = radius, h = thickness );

        translate([radius*2 - width,0,0]) {
            cylinder( r = radius, h = thickness );
        }
    }
}

module single_trap(offset) {
    difference() {
        leaf( outer_radius + 1.5, trap_width, trap_outside_height );
        translate([-offset,0,trap_outside_height - trap_depth]) {
            leaf( outer_radius + 1.5 - 5.5, 17, trap_outside_height );
        }
    }
}

module traps() {
    single_trap( 1.5);
    mirror([1,0,0]) {
        single_trap( 1.5);
    }
}

// The whole trap

translate([0,0,trap_outside_height-pad]) {
    walls();
}
traps();

