// Filament guide with builtin room for something to clean the filament with

// Arm with 10 mm width, centered on z, and rotated such that z is up, and x and y matches the bed. I hope.
rotate([0,-90,0] ){
	linear_extrude( height=10, center = true ) {	
		union () {
			// Thingy to go on the top of the printer
			polygon(points=[[0,7],[40,7], [40,0], 
								 [0,0], [0,-3], [40,-4], [50,-5], 
			                [80,0],[100,0], [100,12], [0,12]]);
				
			// Arm to hold the cup
			translate([91.5,3.5,0]) {
				rotate( [0,0,-45] ) {
				   square([70, 12] );
				}
			}
		}
	}
}

// Cup placement
translate([0,-54,152] ) {
	rotate( [-45, 0, 0 ] ) {
		// Actual cup.
		difference() {
			cube( size=[10,30,30], center = true );
		   // Hollow.
			translate ([0,0,1] ){ 
				cube( size=[6, 26, 28 ], center = true );
			}
			// Hole for filament
	      translate ([0,0,-14]) {
				cylinder( h=2, r=1, center = true, $fn=100 );
       	}
		}
	}
}