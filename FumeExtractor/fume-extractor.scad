// Fume extractor for soldering


// Controls the fan size
fan_width = 80;
fan_height = fan_width; // Assumed in model.
fan_thickness = 25;

// Distance between support holes
fan_hole_distance = 71;
// The support holes
fan_hole_diameter = 3.6;

// The following four determines the amount of support for the back hole.
// Offsets are from button left
fan_x_offset = 20;
fan_y_offset = 4;

// Extra space
box_x_space = 4; // Room for switch.
box_y_space = 4;

// I use two carbon filters of 8 mm. Front and back
carbon_filter_thickness = 8;
carbon_filter_number = 2;

// And this is to stop the carbon filters from beeing sucked into the fan
carbon_filter_gap_filler_thickness = 1;

// The diameter of the cutout for the carbon filter
fan_window_diameter = 78;
fan_window_bar_width = 3;

// Thickness of the walls of the box
box_wall_thickness = 1.2;

// Wall to support the filters.
box_inner_wall_thickness = 0.8;

// Switch cutout is assumed round
switch_radius = 3;
// From upper left corner
switch_offset = 10;

pad = 0.05;
$fn=120;

////////////////////////////////////////
// CALCULATED
inner_box_width     = fan_width + fan_x_offset + box_x_space;
inner_box_height    = fan_height + fan_y_offset + box_y_space;
inner_box_thickness = fan_thickness + carbon_filter_thickness * carbon_filter_number + carbon_filter_gap_filler_thickness;
box_width     = 2 * box_wall_thickness + inner_box_width;
box_height    = 2 * box_wall_thickness + inner_box_height;
box_thickness = 2 * box_wall_thickness + inner_box_thickness;

fan_center_x = box_wall_thickness + fan_x_offset + fan_width / 2;
fan_center_y = box_wall_thickness + fan_y_offset + fan_height / 2;
fan_window_radius = fan_window_diameter / 2.0;
fan_hole_distance_half = fan_hole_distance / 2.0;

module air_cutout() {
    difference() {
        // Cylinder base.
        rotate([90,0,0])
        cylinder(r = fan_window_radius, h = box_wall_thickness+pad, center=true);
        
        // Cutout for air
        rotate([0,0,0])
        for (i = [0: 4]) {
            rotate([0,60*i,0])
            cube([fan_width, box_wall_thickness+2*pad, fan_window_bar_width], center=true);
        }
    }
}

module fan_support() {
    for(x = [-1,1])
    for(y = [-1,1])
    translate([fan_hole_distance_half*x, 0, fan_hole_distance_half*y])
    rotate([90,0,0])
    cylinder(r = fan_hole_diameter/2.0, h = inner_box_thickness, center = true);
}

// Box is front, with no lid
module box() {

    difference() {
        union() {

    // Frame
    difference() {
        cube([box_width, box_thickness, box_height]);
        translate([box_wall_thickness,box_wall_thickness,box_wall_thickness])
        cube([inner_box_width, inner_box_thickness + box_wall_thickness + pad, inner_box_height]);

        // Fan cutout
        translate([fan_center_x,box_wall_thickness/2.0,fan_center_y])
        air_cutout();
    }

    
    // Support for fan.
    translate([fan_center_x,inner_box_thickness/2.0+box_wall_thickness,fan_center_y])
    fan_support();

    // Support for carbon filters
    // Move to center of fan
    translate([fan_center_x,inner_box_thickness/2.0+box_wall_thickness,fan_center_y])
    // Center "flanges"
    translate([-fan_width*0.5-1,0,0])
    for(x = [0,1])
    for(y = [0,1])
    translate([(x+y)*fan_width*0.5+(x+y)*1,0,(x-y)*fan_width*0.5+(x-y)*1])
    rotate([0,90*(x+y),0])
    cube([box_inner_wall_thickness, inner_box_thickness, fan_hole_distance_half], center=true);

}
    
    // Cutout for switch
    translate([switch_offset,0,box_height-switch_offset])
    rotate([90,0,0])
    cylinder(r = 3, h = box_wall_thickness * 4, center=true);
}   

}

module foo() {
    translate([fan_center_x,carbon_filter_thickness/2.0+box_wall_thickness,fan_center_y])
    difference() {
        cube([fan_width+2*box_inner_wall_thickness,
                carbon_filter_thickness,
                fan_height+2*box_inner_wall_thickness], center=true);
        cube([fan_width,
                carbon_filter_thickness+pad,
                fan_height], center=true);
    }



    }


box();
// air_cutout();