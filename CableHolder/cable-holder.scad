// Thingy to hold a cable to a wall or other surface.
// Meant to be sturdy, to support "thick" cables.

cable_diameter = 17;

holder_thickness = 4;

screw_hole_diameter = 4;
screw_counter_sunk_diameter = 8;
// screw_counter_sunk_angle = 45; Always assumed
screw_support_thickness = 4;
screw_support_width = 2;

holder_length = 50;

// Calculated fields
cable_radius = cable_diameter / 2.0;
holder_width = ( cable_radius + holder_thickness + screw_counter_sunk_diameter + 2*screw_support_width ) * 2;
holder_base_thickness = screw_support_thickness;
screw_hole_radius = screw_hole_diameter / 2.0;
screw_counter_sunk_radius = screw_counter_sunk_diameter / 2.0;

pad = 0.05;

// Its basically a block


module base() {
    translate([0,0,holder_base_thickness/2.0])
    cube([holder_length, holder_width, holder_base_thickness], center=true);
}


// Cutter and cuttee - halfpipe with base.
module half_pipe(radius, offset, length) {
    difference() {
        union() {
            translate([0,0,offset])
            rotate([0,90,0])
            cylinder(r = radius, h = length, center=true);
            translate([0,0,offset/2.0])
            cube([length, radius*2, offset], center=true);
        }
        // Cut the bottom half
        translate([0,0,-offset/2.0])
        cube([length+2*pad, radius*2, offset], center=true);        
    }        
}

// Make a simple screwhole
module screw_hole() {
    translate([0,0,-screw_counter_sunk_radius/2.0]) {
        translate([0,0,-screw_counter_sunk_radius/2.0])
        cylinder(r1 = 0, r2 = screw_counter_sunk_radius, h = screw_counter_sunk_radius);
    
        translate([0,0,-screw_support_thickness * 10])
        cylinder(r = screw_hole_radius, h = screw_support_thickness * 10);
    }
}

module all_screw_holes() {
    translate([
            holder_length/2.0-screw_counter_sunk_radius-screw_support_width,
            holder_width/2.0-screw_counter_sunk_radius-screw_support_width,
            holder_base_thickness+pad
        ]) screw_hole();
    translate([
            -(holder_length/2.0-screw_counter_sunk_radius-screw_support_width),
            holder_width/2.0-screw_counter_sunk_radius-screw_support_width,
            holder_base_thickness+pad
        ]) screw_hole();
    translate([
            holder_length/2.0-screw_counter_sunk_radius-screw_support_width,
            -(holder_width/2.0-screw_counter_sunk_radius-screw_support_width),
            holder_base_thickness+pad
        ]) screw_hole();
    translate([
            -(holder_length/2.0-screw_counter_sunk_radius-screw_support_width),
            -(holder_width/2.0-screw_counter_sunk_radius-screw_support_width),
            holder_base_thickness+pad
        ]) screw_hole();

}

module main() {
    difference() {
        base();
        translate([0,0,-pad])
        #half_pipe(cable_radius+holder_thickness-pad, cable_radius-pad, holder_length + 2);
    }
    difference() {
        half_pipe(cable_radius+holder_thickness, cable_radius, holder_length);
        half_pipe(cable_radius, cable_radius, holder_length + 2);
    }
}

difference() {
    main();
    all_screw_holes();
}

//translate([holder_length/2.0,0,cable_radius])
// sphere(r=cable_radius);