// Tachometer reflector surface for motor axel
// Designed to be printed in two colors.

// Main principle is a cylinder (tacho reflector) with cutouts from the axel and for mountings

// Variables

// The full diameter of the axel
axel_diameter = 10;
// The distance from the cutout flat side to the other side of the axel (the width of the "D")
axel_diameter_flat = 8;

// The outside diameter of the reflector cylinder
tacho_reflector_diameter = 30;
// Length of reflector
tacho_reflector_length = 100;

// Screw diameter
screw_diameter = 4;
// Screw head diameter -- also used for hex nut cutput
screw_head_diameter = 8;
// Screw cutout length. This should really be calculated...
screw_cutout_length = 20;

// Consts

// Space -- for making space around the screw
space = 0.25;
// Pad -- for padding stuff
pad = 0.05;
// Neato circles.
$fn = 50;


// Calculated values
axel_radius = axel_diameter / 2.0;
tacho_reflector_radius = tacho_reflector_diameter / 2.0;
screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;

// The axel is used to "cut out" the axel from the techo cylinder
module axel() {
    difference() {
        #cylinder(r = axel_radius, h = tacho_reflector_length + 2*pad, center = true);
        translate([axel_diameter_flat + pad,0,0]) {
            cube([2*axel_radius + 2*pad, 2*axel_radius + 2*pad, tacho_reflector_length + 4*pad], center = true);
        }
    }
}


axel();

