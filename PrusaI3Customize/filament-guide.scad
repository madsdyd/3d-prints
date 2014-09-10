// Filament guide with builtin room for something to clean the filament with

// Arm with 10 mm width, centered on z, and rotated such that z is up, and x and y matches the bed. I hope.
rotate([0,-90,0] ){
	linear_extrude( height=10, center = true ) {	
		union () {
			// Thingy to go on the top of the printer
			polygon(points=[[0,0],[4.5,0],[4.5,6],[46.5,6], [46.5,-1], 
								 [39.5,-1], [39.5,-7], [46.5,-7], 
			                [80,0],[100,0], [100,12], [0,12]]);
				
			// Arm to hold the cup
			translate([91.5,3.5,0]) {
				rotate( [0,0,-45] ) {
				   square([100, 12] );
				}
			}
		}
	}
}

// Cup placement
translate([0,-74,175] ) {
	rotate( [-45, 0, 0 ] ) {
		// Actual cup.
		difference() {
			cube( size=30, center = true );
		   // Hollow.
			translate ([0,0,1] ){ 
				cube( size=[26, 26, 28 ], center = true );
			}
			// Hole for filament
	      translate ([0,0,-14]) {
				cylinder( h=2, r=1, center = true );
       	}
		}
	}
}