// Fume extractor for soldering


// Controls the fan size
fan_hole_distance = 71;
fan_width = 80;
fan_height = fan_width; // Assumed in model.
fan_thickness = 25;

// The following four determines the amount of support for the back hole.
// Offsets are from button left
fan_x_offset = 14;
fan_y_offset = 4;

// Extra space
box_x_space = 4; // Room for switch.
box_y_space = 4;

// I use two carbon filters of 8 mm.
carbon_filter_thickness = 2 * 8;

// And this is to stop the carbon filters from beeing sucked into the fan
carbon_filter_gap_filler_thickness = 1;

// The diameter of the cutout for the carbon filter
fan_window_diameter = 78;
fan_window_bar_width = 3;

// Thickness of the walls of the box
box_wall_thickness = 1.2;

pad = 0.05;
$fn=120;

////////////////////////////////////////
// CALCULATED
inner_box_width     = fan_width + fan_x_offset + box_x_space;
inner_box_height    = fan_height + fan_y_offset + box_y_space;
inner_box_thickness = fan_thickness + carbon_filter_thickness + carbon_filter_gap_filler_thickness;
box_width     = 2 * box_wall_thickness + inner_box_width;
box_height    = 2 * box_wall_thickness + inner_box_height;
box_thickness = 2 * box_wall_thickness + inner_box_thickness;

fan_center_x = box_wall_thickness + fan_x_offset + fan_width / 2;
fan_center_y = box_wall_thickness + fan_y_offset + fan_height / 2;
fan_window_radius = fan_window_diameter / 2.0;



// Box is front, with no lid
module box() {
    // Frame
    difference() {
        cube([box_width, box_thickness, box_height]);
        translate([box_wall_thickness,box_wall_thickness,box_wall_thickness])
        cube([inner_box_width, inner_box_thickness + box_wall_thickness + pad, inner_box_height]);

        // Fan cutout
        translate([fan_center_x,0,fan_center_y])
        rotate([90,0,0])
        cylinder(r = fan_window_radius, h = box_wall_thickness * 100, center=true);
    }

    

    
    // Cutout for air
    translate([fan_center_x,box_wall_thickness/2.0,fan_center_y])
    rotate([0,0,0])
    for (i = [0: 4]) {
        rotate([0,60*i,0])
        cube([fan_width, box_wall_thickness, fan_window_bar_width], center=true);
    }

    
    
}


box();