// Small box to hold an on-off button
use <Chamfer.scad>

$fn = 20;

// Outer measurements.
box_length = 50; // x
box_width = 34;  // y
box_height = 20; // z

wall_thickness = 2.4;
wire_radius = 3; // Radius of wire going into the box.
wire_distance = (box_width - 2*wall_thickness)/3 + wire_radius; // Distance between the wire holes;

// Measurements of the contact
cutout_length = 19;
cutout_height = 12.5;

// Mounts
mount_outer_radius = 6;
mount_inner_radius = 2;
mount_thickness = 2.4;
screw_head_radius = 4;

// Hole in the side of the box.
module wire_hole() {
    translate([box_length/2-wall_thickness/2,0,0])
    rotate([0,90,0])
    cylinder(h=wall_thickness*2, r = wire_radius, center = true);
}

// Centered chamferCylinder
module ccc(h, r) {
    translate([0,0,-h/2])
    chamferCylinder(height = h, radius = r);
}

module cccube(x, y, z) {
    translate([-x/2, -y/2, -z/2])
    chamferCube(sizeX = x, sizeY = y, sizeZ = z);
}

module mount() {
    translate([0,0,-mount_thickness/2+box_height/2])
    difference() {
        union() {
            ccc(h=mount_thickness, r = mount_outer_radius);
            translate([-mount_outer_radius/2,0,0])
            cccube(mount_outer_radius, mount_outer_radius*2, mount_thickness);
        }
        cylinder(h = mount_thickness * 2, r = mount_inner_radius, center = true);
    }
}

module mounts() {
    translate([box_length/2+screw_head_radius, 0, 0])
    mount();
    rotate([0,0,180])
    translate([box_length/2+screw_head_radius, 0, 0])
    mount();
    
}

// The main module
module main() {
    
    difference() {
        cccube(box_length, box_width, box_height);
        
        // Make box hollow
        translate([0,0,wall_thickness])
        cccube(box_length - 2*wall_thickness,
                box_width - 2*wall_thickness,
                box_height);
        
        // Make the cutout for the contact
        translate([0, -box_width/2.0+wall_thickness/2.0, 0])
        cube([cutout_length, wall_thickness * 2, cutout_height], center = true);
        
        // And, the cutout for the wires. Use two holes, makes the most snug fit.
        translate([0, wire_distance / 2, 0]) wire_hole();
        translate([0, -wire_distance / 2, 0]) wire_hole();
    }
}


main();
mounts();
