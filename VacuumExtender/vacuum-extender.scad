// Extend vaacum

// TODO: Print using 0.2 layer, perhaps > 20% infill. 

// The inner is the part that goes into the long tube of the vacuum cleaner
inner_radius = 32.3 / 2.0;
inner_length = 50.0;

// The outer is the part that holds the handle of the vacuum 
outer_radius = 32.0 / 2.0;
outer_length = 50.0;

// Fudge means that it gets slightly thicker 
fudge = 0.3;

// Thickness of the parts edges.
thickness = 2.0;

// Overlap between the two parts.
overlap = 15.0;

// Not really used, actually
pad = 0.1;

// Make it round
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

// And outer
module outer() {
    difference () {
        cylinder( h = outer_length + overlap, r1 = outer_radius + thickness - fudge, r2 = outer_radius + thickness + fudge);
        translate( [0,0,-pad] ) {
            cylinder( h = outer_length + overlap + 2 * pad, r1 = outer_radius - fudge, r2 = outer_radius + fudge);
        }
    }
}

// And both
inner();
outer();