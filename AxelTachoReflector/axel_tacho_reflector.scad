// Tachometer reflector surface for motor axel
// Designed to be printed in two colors.

// Main principle is a cylinder (tacho reflector) with cutouts from the axel and for mountings

// Variables

// The full diameter of the axel. Org. measurement 14.

// 14/12 + 0.5 - too big  (Real: 14.5 / 12.25)
// 13/11 + 0.25 - too small (Real: 13.1 / 11.1)
// 13.5/11.5 + 0.25 - fit (Real: 13.55 / 11.6)

axel_diameter = 13.5;
// The distance from the cutout flat side to the other side of the axel (the width of the "D")
// Org. measurement 12.
axel_diameter_flat = 11.5;
// The lenght of the part of the axel that the reflector mounts on
axel_length = 55;

// The outside diameter of the reflector cylinder
tacho_reflector_diameter = 30;
// Length of reflector
tacho_reflector_length = 100;

// Screw diameter
screw_diameter = 3.6;
// Screw head diameter -- also used for hex nut cutput
screw_head_diameter = 7;
// Screw cutout length. This should really be calculated...
screw_cutout_length = 20;

// There are two sets of screws. Offset from ends.
// Org. 15
screw_offset = 5;

// And, the cutout between the two halves.
cutout_width = 1;

// Consts

// Inner radius adjustment. This seems to work with 0.25
inner_hole_adjustment = 0.25;
// Space -- for making space around the screw
space = 0.0;
// Pad -- for padding stuff
pad = 0.05;
// Neato circles.
$fn = 100;


// Calculated values
axel_radius = axel_diameter / 2.0;
tacho_reflector_radius = tacho_reflector_diameter / 2.0;
screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;

// The axel is used to "cut out" the axel from the techo cylinder
module axel() {
    difference() {
        cylinder(r = axel_radius + inner_hole_adjustment, h = tacho_reflector_length + 2*pad, center = true);
        translate([axel_diameter_flat + pad + inner_hole_adjustment,0,0]) {
            cube([2*axel_radius + 2*pad, 2*axel_radius + 2*pad, tacho_reflector_length + 4*pad], center = true);
        }
    }
}

// The reflector is the visible outside surface object
module reflector() {
    cylinder(r = tacho_reflector_radius, h = tacho_reflector_length, center = true);
}

// This is used to cut holes from the reflector.
module screw_hole() {
    rotate([0,90,0]) {
        cylinder(r = screw_radius + space, h = screw_cutout_length*2, center = true);
        translate([0,0,screw_cutout_length/2.0+25]) {
            cylinder(r = screw_head_radius, h = 50, center = true);
        }
        translate([0,0,-(screw_cutout_length/2.0+25)]) {
            cylinder(r = screw_head_radius, h = 50, center = true);
        }
    }
    
}

module screw_holes() {
    translate([0,
            screw_radius + axel_radius + 1.2,
            tacho_reflector_length / 2.0 - screw_offset]) {
        screw_hole();
    }
    translate([0,
            screw_radius + axel_radius + 1.2,
            -(tacho_reflector_length / 2.0 - screw_offset)]) {
        screw_hole();
    }
    translate([0,
            -(screw_radius + axel_radius + 1.2),
            tacho_reflector_length / 2.0 - screw_offset]) {
        screw_hole();
    }
    translate([0,
            -(screw_radius + axel_radius + 1.2),
            -(tacho_reflector_length / 2.0 - screw_offset)]) {
        screw_hole();
    }
}

module main() {
    difference() {
        reflector();
        // TODO: Remember these!
        screw_holes();
        translate([0,0,tacho_reflector_length + 2*pad - axel_length]) {
            axel();
        }
    }    
}

// Two modules, left and right
difference() {

    // Temp center cutout. Each half can then be hidden / something.
    difference() {
        main();
        cube([cutout_width,1000,1000], center=true);        
    }

    // Temporary main cut, to not have to print full length initially
    translate([0,0,-10]) {
        cylinder(r=100, h=100, center=true);
    }
}

    
// TODO: Test print. Fit. Split in two.