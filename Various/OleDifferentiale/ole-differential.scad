// Et differential til en plæneklipper

// Det er en plæneklipper,
// mcculloch m95-66x 9.5 hp motor, ca. 2012

outer_diameter = 106.5;
main_height = 11.21;

// A is the nice side

// Thickness of rim
a_inner_rim = 5.0;
b_inner_rim = 11.5;
a_rim_thickness = 1.2;
b_rim_thickness = 1.9;
// This does not really matter, should just be larger than the thickness.
rim_cutter_height = 4;

// Center hole diameter
center_hole_diameter = 9.2;
center_hole_height = 20;

// Small holes diameter
small_hole_diameter = 4.2;
// outer_hole_offset from center
outer_hole_offset = 44.8;
inner_hole_offset = 36.5;

// The boxes. Two are vertical, two are horizontal
// Vertical box offset from center to center.
v_box_height = 23.3;
v_box_offset = 8.2 + v_box_height / 2.0;
v_box_width  = 8.1;

// Horizontal box offset from center
// h_box_offset = 

// Knaster
outer_knast_diameter = 18;
knast_offset = 56.1;

// Slightly more corners
$fn = 60;

// Make four holes using the small_hole_diameter, and a given offset
module four_holes(offset) {
    for( i = [0,1,2,3] ) {
        rotate([0,0,90*i])
        translate([offset, 0, -center_hole_height/2.0])
        cylinder(r = small_hole_diameter/2.0, h = center_hole_height);
    }
}

module two_boxes(offset, h, w) {
    for( i = [1,-1] ){
        translate([0,i*offset,0])
        # cube([w,h,center_hole_height], center = true);
    }
}

// Knaster
module knaster() {
    for(i = [0,1,2]) {
        rotate([0,0,120*i])
        translate([0,knast_offset,-main_height/2.0])
        difference() {
            cylinder(r = outer_knast_diameter / 2.0, h = main_height);
            translate([0,0,-1])
            cylinder(r = small_hole_diameter/2.0, h = center_hole_height);
        }
        // Runde knaster af.
    }
}


module main() {
    difference() {
        union() {
            // Main cylinder
            translate([0,0,-main_height / 2.0]) 
            cylinder(r = outer_diameter / 2.0, h = main_height );
        
            // Add knaster
            knaster();
        }

        
        // Cuttings on both sides
        // A side
        translate([0,0,-rim_cutter_height/2.0+rim_cutter_height/2.0+main_height/2.0-a_rim_thickness])
        cylinder (r = outer_diameter / 2.0 - a_inner_rim, h = rim_cutter_height);

        // B side
        translate([0,0,-rim_cutter_height/2.0-rim_cutter_height/2.0-main_height/2.0+b_rim_thickness])
        cylinder (r = outer_diameter / 2.0 - b_inner_rim, h = rim_cutter_height);

        // Center hole
        translate([0,0,-center_hole_height / 2.0])
        cylinder(r = center_hole_diameter / 2.0, h = center_hole_height);
        
        // Small holes
        four_holes(outer_hole_offset);

        // Small holes
        rotate([0,0,45])
        four_holes(inner_hole_offset);
        
        // Vertical boxes
        two_boxes(v_box_offset, v_box_height, v_box_width);
        
    }

     

}

main();