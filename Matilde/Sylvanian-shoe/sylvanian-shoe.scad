// Sylvanian shoe

// we enlarge some very small stuff
$fn=50;


module blank() {

    difference() {
        scale( [2.7, 1.6, 1.6 ] ) sphere( r = 5, center = true );
        // Underside cutter
        translate([0,0,-5]) {
            cube([ 30, 20, 9 ], center = true );
        }
        // Heel cutter
        translate( [-14, 0, 6]) {
            cube( [30, 20, 7 ], center = true );
        }
        // Hollower
        difference() {
            scale( [2.5, 1.4, 1.4 ] ) sphere( r = 5, center = true );
            translate([0,0,-3]) {
                cube([ 30, 20, 7 ], center = true );
            }
        }
    }
}


blank();


