// Not to scale
inner_diameter = 50;
outer_diameter = 80;
thickness = 1.8;
cardboard_thickness = 2.5;
tabs_depth = 10;
tooth_pick_thickness = 2;
pad = 0.05;

$fn=200;

difference() {
    // Actual ring
    difference() {
        cylinder(r = outer_diameter/2, h = thickness, center  = true);
        cylinder(r = inner_diameter/2, h = thickness * 2, center = true);
    }
    // cut one side off
    translate([0, -outer_diameter, -thickness])
    cube([2*outer_diameter, 2*outer_diameter, 2*thickness]);
}



module tab_cutout() {
    rotate([0,0,45])
    cube([tabs_depth/4, tabs_depth/4, thickness * 2], center = true);
}

module tab_cutouts() {
    translate([tabs_depth*1.25, (outer_diameter-inner_diameter)/4, 0])
    tab_cutout();
    translate([tabs_depth*1.25, -(outer_diameter-inner_diameter)/4, 0])
    tab_cutout();
}


module tab() {
    difference() {
        translate([-pad, -(outer_diameter-inner_diameter)/4, -thickness/2])
        difference() {
            cube([tabs_depth+cardboard_thickness, (outer_diameter-inner_diameter)/2, thickness]);
            // Make a hole for the toothpick
            translate([tooth_pick_thickness / 2 + cardboard_thickness, (outer_diameter-inner_diameter)/4, 0])
            cylinder(r = tooth_pick_thickness / 2, h = thickness * 3,  center = true);
        }
        tab_cutouts();
    }
}

module tabs() {
    translate([0,(outer_diameter-inner_diameter)/4+inner_diameter/2,0])
    tab();
    translate([0,-((outer_diameter-inner_diameter)/4+inner_diameter/2),0])
    tab();

    }

tabs();

    