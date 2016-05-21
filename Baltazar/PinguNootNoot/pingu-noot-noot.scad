// Ping noot noot horn.

// This is in two parts that are meant to put together
// afterwards.


////////////////////////////////////////////////////////////
// outer is the outer part, inner is the inner part. Some variables are shared.

// Overall measurements
outer_total_height = 175;
outer_inner_min_radius = 25;
outer_inner_max_radius = 30;

outer_sleeve_height = 10;
// All thicknesses are approximate
outer_sleeve_min_thickness = 1;
outer_thickness = 4;
// The noot is the trumpet at the end
outer_noot_height = 20;
outer_noot_min_radius = 55;
outer_noot_max_radius = 60;

////////////////////////////////////////////////////////////
// Inner

// Overlap with inner
inner_overlap = 20;

// Outer max should match inner + overlap
// Overlap addition radius can be calculated
inner_overlap_addition_radius = inner_overlap / outer_total_height  * (outer_inner_max_radius - outer_inner_min_radius );
inner_outer_max_radius = outer_inner_min_radius + inner_overlap_addition_radius;

// Outer min should extend the angle
inner_outer_min_radius = outer_inner_min_radius - (outer_inner_max_radius - outer_inner_min_radius ) + inner_overlap_addition_radius;

// Plate is to mount on
inner_mount_thickness = 4;
inner_mount_number = 6;
// Offset from center
inner_mount_offset = 10;
inner_mount_hole_radius = 2;

// Approximate
inner_thickness = 4;

pad = 0.1;
$fn = 50;

module outer() {
    difference() {
        union() {
            // Bottom cylinder is noot
            cylinder( h = outer_noot_height, r2 = outer_noot_min_radius, r1 = outer_noot_max_radius );
            // And a cylinder for the main part (not the sleeve)
            // Note, thickness is not adjusted for slope on cutter cylinder.
            cylinder( h = outer_total_height - outer_sleeve_height,
                r2 = outer_inner_min_radius + outer_thickness,
                r1 = outer_inner_max_radius + outer_thickness );
            // And, the sleeve
            translate([0,0, outer_total_height - outer_sleeve_height - pad])
            cylinder( h = outer_sleeve_height + pad,
                r2 = outer_inner_min_radius + outer_sleeve_min_thickness,
                r1 = outer_inner_min_radius + outer_thickness );
        }
        // The cutter to cut with
        translate([0,0,-pad])
        cylinder( h = outer_total_height + 2*pad,
            r2 = outer_inner_min_radius,
            r1= outer_inner_max_radius );
    }
}

module plate_holes() {
    for(i=[0:inner_mount_number-1]) {
        // Make a small cylinder and rotate
        rotate([0,0,360/inner_mount_number*i])
        translate([inner_mount_offset,0,0])
        cylinder(h = inner_mount_thickness * 2, r = inner_mount_hole_radius, center = true);
    }

}

module inner() {
    // Mount plate
    difference() {
        // Main stuff, with cutout
        difference() {
            cylinder( h = outer_total_height,
                r2 = inner_outer_min_radius,
                r1 = inner_outer_max_radius );
            // Cut away, but leave a plate to mount no.
            // translate([0,0,-pad])
            cylinder( h = outer_total_height - inner_mount_thickness + 2*pad,
                r2 = inner_outer_min_radius - inner_thickness,
                r1 = inner_outer_max_radius - inner_thickness );
        }
        translate([0,0,outer_total_height])
        plate_holes();
    }
}



module main() {

    outer();
    rotate([180,0,0])
    translate([outer_noot_max_radius + inner_outer_max_radius + 10, 0, -outer_total_height])
    inner();

}

main();

