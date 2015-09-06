// Small fix for a binocular thing that brooke

thickness = 1.6;
hole_radius = 2;
head_radius = 3.1;
outer_radius = 7;
outer_top_radius = 5;
outer_thickness = 5;

pad = 0.05;

$fn = 50;

module main () {
    difference() {
        // Main cone

        union() {
            translate([0,0,thickness]) {
                cylinder( r2 = outer_top_radius, r1 = outer_radius, h = outer_thickness-thickness );
            }
            cylinder( r = outer_radius, h = thickness );
        }

        // Cut for screw
        translate([0,0,-pad]) {
            cylinder( h = outer_thickness * 2, r = hole_radius );
        }

        // Cut for screw head
        translate([0,0,thickness]) {
            cylinder( h = outer_thickness * 2, r = head_radius );
        }
    }
}


main();