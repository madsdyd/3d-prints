// Lift sensor caps

// Overall cap thickness
cap_thickness = 2;
plate_thickness = 2;

// The cable cap measurements
cable_diameter = 15;
cable_depth = 18;

// sensor is a "double" cap
sensor_outer_diameter = 30;
sensor_outer_depth = 30;
sensor_inner_diameter = 12;
sensor_inner_depth = 15.5;

pad = 0.05;

module plate() {
    translate([0,0,-plate_thickness / 2.0 + pad] )
    cube([sensor_outer_diameter + 2* cap_thickness,sensor_outer_diameter + 2* cap_thickness,plate_thickness], center = true);
}

module cable_cap() {
    difference() {
        cylinder(r = cable_diameter / 2.0 + cap_thickness, h = cable_depth);
        cylinder(r = cable_diameter / 2.0, h = cable_depth);
    }
    plate();
}

module sensor_cap() {
    difference() {
        cylinder(r = sensor_outer_diameter / 2.0 + cap_thickness, h = sensor_outer_depth);
        cylinder(r = sensor_outer_diameter / 2.0, h = sensor_outer_depth);
    }
    difference() {
        cylinder(r = sensor_inner_diameter / 2.0 + cap_thickness, h = sensor_inner_depth);
        cylinder(r = sensor_inner_diameter / 2.0, h = sensor_inner_depth);
    }
    plate();
}


sensor_cap();