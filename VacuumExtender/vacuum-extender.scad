// Extend vaacum

inner_radius = 32.3 / 2.0;
inner_length = 50.0;
outer_radius = 32.0 / 2.0;
outer_length = 50.0;

fudge = 0.3;

thickness = 2.0;
overlap = 15.0;

pad = 0.1;

$fn = 50;

// Stuff that goes inner
module inner() {
    translate([0,0,-inner_length]) {
        difference () {
            cylinder( h = inner_length + overlap, r1 = inner_radius - fudge, r2 = inner_radius + fudge);
            translate( [0,0,-pad] ) {
                cylinder( h = inner_length + overlap + 2 * pad, r1 = inner_radius - fudge - thickness, r2 = inner_radius + fudge - thickness );
            }
        }
    }
}

module outer() {
    difference () {
        cylinder( h = outer_length + overlap, r1 = outer_radius + thickness - fudge, r2 = outer_radius + thickness + fudge);
        translate( [0,0,-pad] ) {
            cylinder( h = outer_length + overlap + 2 * pad, r1 = outer_radius - fudge, r2 = outer_radius + fudge);
        }
    }
}

inner();
outer();