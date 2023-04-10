// Caps for the metalsensors at Hedeland. 

use <threadlib/threadlib.scad>

// Cap is m12, AFIAK
cap_thread = "M12x1";

// COMMON

// Thicknes of cap "lid"
cap_lid_thickness = 2;

finger_screw_length = 40;
finger_screw_end_diameter = 8;
finger_screw_center_diameter = 16.4;
finger_screw_thickness = 3;
finger_screw_arm_reduction = 0;

nut_size = 14; // DO NOT CHANGE
nut_hex_radius = 8.0829; // 14 mm
// 13 = nut_hex_radius = 7.50555; // 13 mm
// 15 = nut_hex_radius = 8.66025; // 15 mm. Could be calculated from abov.


// SENSOR
// How deep the cap for the sensor is
sensor_cap_inner_height = 10;
// Must be <= than nut_size
sensor_cap_outer_diameter = 14;

// Cable
// How deep the cable cab should be.
cable_cap_inner_height = 10;
cable_cap_turns = 8; // Fits 1 diameter pitch.
// The walls of the cable cap.
cable_cap_inner_cutout_diameter = 8 + 1;
cable_cap_nut_height = 7;

pad = 0.05;

$fn=120;

module finger_screw() {
    translate([0,0,finger_screw_thickness/2.0]) {
        hull() {
            translate([finger_screw_length / 2.0 - finger_screw_end_diameter / 2.0, 0, 0])
            cylinder(h = finger_screw_thickness, r = finger_screw_end_diameter / 2.0 - finger_screw_arm_reduction, center = true);
            
            translate([-finger_screw_length / 2.0 + finger_screw_end_diameter / 2.0, 0, 0])
            cylinder(h = finger_screw_thickness, r = finger_screw_end_diameter / 2.0 - finger_screw_arm_reduction, center = true);
            
            cylinder(h = finger_screw_thickness, r = finger_screw_center_diameter / 2.0 - finger_screw_arm_reduction, center = true);
        }
        
        translate([finger_screw_length / 2.0 - finger_screw_end_diameter / 2.0, 0, 0])
        cylinder(h = finger_screw_thickness, r = finger_screw_end_diameter / 2.0, center = true);
        
        translate([-finger_screw_length / 2.0 + finger_screw_end_diameter / 2.0, 0, 0])
        cylinder(h = finger_screw_thickness, r = finger_screw_end_diameter / 2.0, center = true);
        
        cylinder(h = finger_screw_thickness, r = finger_screw_center_diameter / 2.0, center = true);
    }
}

module sensor_cap() {

    intersection() {
        // I have to adjust this, because I need about 0.5 diameter more. 6 => 6.25 == 1.042 %
        // We provide turns, not height here... 
        scale([1.0416666, 1.0416666, 1])
        nut(cap_thread, turns=sensor_cap_inner_height * 3, Douter=sensor_cap_outer_diameter);
        // A cube that intersects the height we want
        cube([sensor_cap_outer_diameter + 2*pad,
                sensor_cap_outer_diameter + 2*pad,
                sensor_cap_inner_height * 2], center=true);
    }
    // Actual lid
    translate([0,0,-cap_lid_thickness])
    cylinder(h = cap_lid_thickness + pad, r = sensor_cap_outer_diameter / 2.0);

    // Add a fingerscrew, but cut out the center, to not destroy the thread.
    translate([0,0,-cap_lid_thickness])
    difference() {
        finger_screw();
        cylinder(h = 100, r = sensor_cap_outer_diameter/2.0 - 1, center=true);
    } 

    // Add a ring "on top" as a guide
    translate([0,0,sensor_cap_inner_height-pad+1])
    difference() {
        cylinder(h = 2, r = sensor_cap_outer_diameter/2.0 + 0, center = true);
        cylinder(h = 2+pad,
            r1 = sensor_cap_outer_diameter/2.0-0.8,
            r2 = sensor_cap_outer_diameter/2.0-0.4,
            center = true);
                
    }

    // Add a nut to work with
    difference() {
        rotate([0,0,30]) {
            cylinder(h=sensor_cap_inner_height, r=nut_hex_radius, $fn=6);
        }
        cylinder(h=sensor_cap_inner_height + pad, r = sensor_cap_outer_diameter/2.0 - pad);
    }
    
}

module cable_cap() {
    difference() {
        // The bolt
        // I have to adjust this, because I need about 0.5 diameter less. 6 => 5.75 == 0.95833 %
        // scale([0.9583333, 0.9583333, 1]) // Slightly too smal
        scale([0.97, 0.97, 1]) 
        bolt(cap_thread, turns=cable_cap_turns);
        // Cutout for center thing from cable
        cylinder(h = cable_cap_inner_height * 3, r = cable_cap_inner_cutout_diameter / 2.0, center = true);
    }
    // Add a nut and fingerscrew below.
    // Add a nut to work with
/*    translate([0,0,-cable_cap_nut_height])
    rotate([0,0,30]) {
            cylinder(h=cable_cap_nut_height, r=nut_hex_radius, $fn=6);
        }

        */
    // Add a fingerscrew, but cut out the center, to not destroy the thread.
    translate([0,0,-finger_screw_thickness])
    finger_screw();

    
}


// finger_screw();

// sensor_cap();
cable_cap();




