// Fume extractor for soldering


// Controls the fan size
fan_width = 80;
fan_height = fan_width; // Assumed in model.
fan_thickness = 25;

// Distance between support holes
fan_hole_distance = 71;
// The support holes
fan_hole_diameter = 4 - 0.4; // 0.4 mm tolerance
// The extra tole
fan_hole_diameter_outside = fan_hole_diameter + 0.8;

// The following four determines the amount of support for the back hole.
// Offsets are from button left
fan_x_offset = 15;
fan_y_offset = 4;

// Extra space
box_x_space = 15; // Room for fasteners
box_y_space = 4;

// I use two carbon filters of 8 mm. Front and back
carbon_filter_thickness = 8;
carbon_filter_number = 2;

// Extra size to allow filter to be slightly larger than the fan.
carbon_filter_extra = 2;

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
switch_offset_x = 11;
switch_offset_y = 11;

////////////////////////////////////////
// FASTENER SUPPORT

// Minimum support that fastener must have. Offset from sides, really.
fastener_support = 1.6;

box_fastener_support_thickness = 5;

////////////////////////////////////////
// SCREW MODULE STUFF

// Screw stuff
// Screw diameter
screw_diameter = 3.6;
// Screw head diameter -- also used for hex nut cutout
screw_head_diameter = 6;
// Screw cutout length. This should really be calculated...
screw_cutout_length = 15;
nut_thickness = 2;
space = 0.0;
screw_head_thickness = 2;
inner_hole_adjustment = 0.25;


screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;



pad = 0.05;
$fn=120;

////////////////////////////////////////
// CALCULATED
inner_box_width     = fan_width + fan_x_offset + box_x_space;
inner_box_height    = fan_height + fan_y_offset + box_y_space;
inner_box_thickness = fan_thickness + ( carbon_filter_thickness + carbon_filter_gap_filler_thickness) * carbon_filter_number;
box_width     = 2 * box_wall_thickness + inner_box_width;
box_height    = 2 * box_wall_thickness + inner_box_height;
box_thickness = 2 * box_wall_thickness + inner_box_thickness;

fan_center_x = box_wall_thickness + fan_x_offset + fan_width / 2;
fan_center_y = box_wall_thickness + fan_y_offset + fan_height / 2;
fan_window_radius = fan_window_diameter / 2.0;
fan_hole_distance_half = fan_hole_distance / 2.0;

// This is calculated by the screw radius and support
fastener_support_side = (screw_radius + fastener_support) * ( 1.4142 + 2);

////////////////////////////////////////////////////////////////////////////////
// GENERAL


// Create a screw cutout of a given length
// Center is center of cutout. Translate for only nut or head.
module screw_hole(hole_length) {
    rotate([0,90,0]) {
        // Room for screw
        cylinder(r = screw_radius + space, h = hole_length*2, center = true);
        // Screw head cutout
        translate([0,0,hole_length/2.0+screw_head_thickness/2.0]) {
            cylinder(r1=screw_radius + space, r2 = screw_head_radius + inner_hole_adjustment, h = screw_head_thickness, center = true);
        }
        // Extension of head cutout
        translate([0,0,hole_length/2.0+25+screw_head_thickness-pad]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true
);
        }
        // Hex nut cutout
        translate([0,0,-(hole_length/2.0+25)]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true
, $fn = 6);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// BOX


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

module fan_support(diam) {
    for(x = [-1,1])
    for(y = [-1,1])
    translate([fan_hole_distance_half*x, 0, fan_hole_distance_half*y])
    rotate([90,0,0])
    cylinder(r = diam, h = inner_box_thickness, center = true);
}

            
// Box is front, with no lid
module box() {
    rotate([90,0,0]) {
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
                fan_support(fan_hole_diameter/2.0);


            }
            
            // Cutout for switch
            translate([switch_offset_x,0,box_height-switch_offset_y])
            rotate([90,0,0])
            cylinder(r = 3, h = box_wall_thickness * 4, center=true);
        }   

        ////////////////////////////////////////
        // Fastenersupport corners
        
        // Translate into place
        translate([box_wall_thickness,
                inner_box_thickness
                -box_fastener_support_thickness/2.0
                +box_wall_thickness,
                box_wall_thickness])
        // Only use inner part of corners
        intersection() {
            // Four corners
            for(x = [0,1])
            for(y = [0,1])
            translate([(x)*inner_box_width,0,(y)*inner_box_height])
            // A single corner
            rotate([90,0,0])
            difference() {
                cylinder(r = 1.4142*screw_head_radius + screw_head_diameter + 2*fastener_support,
                    h=box_fastener_support_thickness, center = true);
                // Inner cutout
                cylinder(r = 1.4142*screw_head_radius,
                    h = box_fastener_support_thickness + pad, center = true);
            }

            // Matching the inner box for intersection.
            translate([inner_box_width / 2.0 + pad, 0, inner_box_height / 2.0 + pad]) {
                difference() {
                    cube([inner_box_width + 2*pad, box_fastener_support_thickness + 2*pad, inner_box_height + 2*pad], center=true);

                    // Cut out four screw holes
                    for(x = [-1,1])
                    for(y = [-1,1])
                    // Cut out a screw hole
                    translate([x*(inner_box_width / 2.0 - fastener_support - 1.4142* screw_head_radius-2*pad),
                            nut_thickness,
                            y*(inner_box_height / 2.0 - fastener_support - 1.4142*screw_head_radius-2*pad)])
                    rotate([45,0,90])
                    screw_hole(box_fastener_support_thickness);
                }
                

            }

            
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// FILTER HOLDER

// Support for the filters
filter_width = fan_width + carbon_filter_extra;
filter_height = fan_height + carbon_filter_extra;
module filter_support() {
    // Center "flanges"
    translate([-(filter_width+box_inner_wall_thickness)*0.5,
            carbon_filter_thickness/2.0-carbon_filter_gap_filler_thickness/2.0,
            0])
    for(x = [0,1])
    for(y = [0,1])
    translate([(x+y)*(filter_width+box_inner_wall_thickness-pad)*0.5,
            0,
            (x-y)*(filter_height+box_inner_wall_thickness-pad)*0.5])
    rotate([0,90*(x+y),0])
    cube([box_inner_wall_thickness, carbon_filter_thickness, fan_hole_distance/4.0], center=true);
    
}
    // Move to center of fan
//    translate([fan_center_x,inner_box_thickness/2.0+box_wall_thickness,fan_center_y])

module filter_holder() {
    rotate([90,0,0])
    translate([0,carbon_filter_gap_filler_thickness/2.0,filter_height/2.0]) {
        difference() {
            cube([filter_width,
                    carbon_filter_gap_filler_thickness,
                    filter_height], center=true);
            air_cutout();
            fan_support(fan_hole_diameter_outside/2.0);        
        }
        filter_support();
    }
}

// Test
// air_cutout();

translate([-20-fan_width,0,0]) filter_holder();



// The actual box
box();

