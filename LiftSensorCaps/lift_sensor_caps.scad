// Lift sensor caps

// Overall cap thickness
cap_thickness = 1.2;

// plate parameters
plate_thickness = 1.8;
plate_edge = 1;
hole_diameter = 4;
hole_edge = 2;

// Inner slip diameter
inner_slip = 0.5;

// The cable cap measurements
cable_diameter = 15 + inner_slip;
cable_depth = 18;

// sensor is a "double" cap
sensor_outer_diameter = 30 + inner_slip;
sensor_outer_depth = 30;
sensor_inner_diameter = 12 + inner_slip;
sensor_inner_depth = 15.5;



pad = 0.05;
$fn=40;

// calculated
plate_size_xy = sensor_outer_diameter + 2*cap_thickness + 2*plate_edge;
hole_offset = plate_size_xy / 2.0 - hole_diameter / 2.0 - hole_edge;

module plate() {
    difference() {
        translate([0,0,-plate_thickness / 2.0 + pad] )
        cube([plate_size_xy, plate_size_xy, plate_thickness], center = true);

        # translate([hole_offset, hole_offset, -plate_thickness])
        cylinder(r = hole_diameter / 2.0, h = plate_thickness * 2.0);
        # translate([hole_offset, -hole_offset, -plate_thickness])
        cylinder(r = hole_diameter / 2.0, h = plate_thickness * 2.0);
        # translate([-hole_offset, hole_offset, -plate_thickness])
        cylinder(r = hole_diameter / 2.0, h = plate_thickness * 2.0);
        # translate([-hole_offset, -hole_offset, -plate_thickness])
        cylinder(r = hole_diameter / 2.0, h = plate_thickness * 2.0);

    }
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


translate([-plate_size_xy-5,0,0])
sensor_cap();
cable_cap();
