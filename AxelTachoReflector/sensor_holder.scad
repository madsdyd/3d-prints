// Holder for sensor / tachometer


// Width of the sensor
sensor_width = 14;

// Space between sensor and supports
sensor_space = 0.5;

// The support is the support for the sensor

// Width of the support besides the sensor
support_width = 3;

// Height of the support
support_height = 20;

// Depth 
support_depth = 2;

// Module mount offset and diameter
module_mount_diameter = 3;
module_mount_offset = 6;

// Base is what is attached to the ventilator pyramid stub
base_width = 25;
base_thickness = 3;

// the distance from the center of the axel to the mounting point
center_mounting_distance = 60;

// And the diameter of the mounting point
mounting_diameter = 6;

pad = 0.05;


// Calculated
support_full_width = support_width * 2 + sensor_width + 2 * sensor_space;
base_length = support_full_width + center_mounting_distance;
mounting_radius = mounting_diameter / 2.0;
module_mount_radius = module_mount_diameter / 2.0;

// Nice circles
$fn=20;

// Create the base. Leave at X/Z position for the support, centered on Y
module base() {
    translate([base_length-support_full_width,0,-base_thickness/2.0+pad]) {
        difference() {
            // Mount is mirror of center of sensor
            translate([-base_length/2.0 + support_full_width/2.0, 0,0]) {
                cube([base_length, base_width, base_thickness], center = true);
            }
            cylinder(r = mounting_radius, h = 2*base_thickness, center=true);
        }
    }
}

module support() {
    //Back support
    difference() {
        translate([0,base_width/2.0-support_depth/2.0,support_height/2.0]) {
            cube([support_full_width, support_depth, support_height], center=true);
        }
        translate([0,0,module_mount_offset]) {
            rotate([90,0,0]) {
                cylinder(r = module_mount_radius, h = 100*support_depth, center = true);
            }
        }
    }
    
    

    
    // Left side support.
    translate([-sensor_width/2.0-sensor_space,base_width/2.0-support_depth,0]) {
        rotate([90,0,270]) {
            linear_extrude(support_width) {
                polygon(points=[[0,0],[base_width-support_depth+pad,0],[0,support_height]], paths=[[0,1,2]]);
            }
        }
    }
    
    // right side support.
    translate([+sensor_width/2.0+sensor_space+support_width,base_width/2.0-support_depth,0]) {
        rotate([90,0,270]) {
            linear_extrude(support_width) {
                polygon(points=[[0,0],[base_width-support_depth+pad,0],[0,support_height]], paths=[[0,1,2]]);
            }
        }
    }
}


base();
support();