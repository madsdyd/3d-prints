// Et differential til en plæneklipper

// Det er en plæneklipper,
// mcculloch m95-66x 9.5 hp motor, ca. 2012

outer_diameter = 106.5;
main_height = 12.1;

// A is the nice side

// Thickness of rim
a_inner_rim = 5.0;
b_inner_rim = 11.5;
a_rim_thickness = 1.2;
b_rim_thickness = 1.9;
// This does not really matter, should just be larger than the thickness.
rim_cutter_height = 4;

// Hole expansion. This is because the liquid sets a bit.
// We multiply by two, because there are two sides... (silly)
hole_addition = 2 * 0.25;


// Center hole diameter
center_hole_diameter = 9.2 + hole_addition;
center_hole_height = 20;

// Small holes diameter
small_hole_diameter = 4.0 + hole_addition;
// outer_hole_offset from center
outer_hole_offset = 44.8;
inner_hole_offset = 36.5;

// Hole expansion. This is because the liquid sets a bit.
// We multiply by two, because there are two sides... (silly)
hole_addition = 2 * 0.25;

// The boxes. Two are vertical, two are horizontal
// Vertical box offset from center to center.
v_box_height = 23.0 + hole_addition;
v_box_offset = 10.9 + v_box_height / 2.0;
v_box_width  = 8.0 + hole_addition;

// Horizontal box offset from center
h_box_offset = v_box_offset;
h_box_height = 13.4 + hole_addition;
// We do not add here, because it is meant to keep distance to the bore holes
h_box_width = 43.1;

// Knaster
outer_knast_diameter = 18;
knast_offset = 56.1;

// Støttebøsning 
hole_support_diameter = 9.0;
hole_support_height = 3;

// Tapper
tap_width = 2.7 - hole_addition;
tap_depth = 4.5;
// Offset fra center :-)
tap_offset = 37.5;

// Cutouts
cutout_radius = 6.5;

// Slightly more corners
$fn = 60;

// Sometimes a pad is helpfull
pad = 0.05;

// Make four holes using the small_hole_diameter, and a given offset
module four_holes(offset) {
    for( i = [0,1,2,3] ) {
        rotate([0,0,90*i])
        translate([offset, 0, -center_hole_height/2.0])
        cylinder(r = small_hole_diameter/2.0, h = center_hole_height);
    }
}

// Make four hole supports using the small_hole_diameter, and a given offset
module four_holes_support(offset) {
    for( i = [0,1,2,3] ) {
        rotate([0,0,90*i])
        translate([offset, 0, -center_hole_height/2.0])
        difference() {
            cylinder(r = hole_support_diameter / 2.0, h = main_height);
            // Cut it at the main_height / 2
            translate([0,0,+center_hole_height / 2.0 - 1.5 * main_height ])
            cylinder(r = hole_support_diameter / 2.0 + 2*pad, h = main_height);
            // This is basically the hole again from four_holes
            cylinder(r = small_hole_diameter/2.0, h = center_hole_height);
        }
    }
}



module two_boxes(offset, h, w) {
    for( i = [1,-1] ){
        translate([0,i*offset,0])
        cube([w,h,center_hole_height], center = true);
    }
}


// Knaster
module knaster() {
    for(i = [0,1,2]) {
        rotate([0,0,120*i])
        translate([0,knast_offset,-main_height/2.0])
        difference() {
            union() {
                cylinder(r = outer_knast_diameter / 2.0, h = main_height);
                // Extra support on the back size
                translate([0,0,-hole_support_height])
                cylinder(r = hole_support_diameter / 2.0, h = hole_support_height);
            }
            translate([0,0,-center_hole_height / 2.0])
            cylinder(r = small_hole_diameter/2.0, h = center_hole_height*2 );
        }

        // Runde knaster af.
        for(j=[-1,1]) {
            difference() {
                rotate([0,0,120*i-10*j])
                translate([0,outer_diameter / 2.0,-main_height/2.0])
                cylinder(r = 5.5, h = main_height);
                // Substract something round
                rotate([0,0,120*i-16.375*j])
                translate([0,outer_diameter / 2.0 + 8.925,-main_height/2.0-pad])
                cylinder(r = 9, h = main_height + pad * 2);
            }
        }
        
    }
}

// Weird stuff on the B side
module tappe() {
    for( i = [-1,1]) {
        translate([i*(tap_offset + tap_depth / 2.0),0,-main_height / 2.0 + b_rim_thickness / 2.0])
        cube([tap_depth, tap_width, b_rim_thickness], center=true);
    }
}

// Cutouts for the holes on the A side
module cutouts() {
    for( i = [-5,-2.5,0,2.5,5,90,175,177.5,180,182.5,185,270] ) {
        rotate([0,0,i])
        translate([outer_hole_offset, 0, main_height / 2.0 - a_rim_thickness])
        cylinder(r = cutout_radius, h = center_hole_height);
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
        // Horiz. boxes
        two_boxes(h_box_offset, h_box_height, h_box_width);

        // Cutouts from the a side
        cutouts();
    }

    // Manually add some minor adjustments.
    tappe();
    
    // Small holes support
    four_holes_support(outer_hole_offset);

}

main();