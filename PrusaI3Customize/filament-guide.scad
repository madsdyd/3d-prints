// Filament guide with builtin room for something to clean the filament with

// Arm with 10 mm width, centered on z, and rotated such that z is up, and x and y matches the bed. I hope.

module arm_shape() {
	// The bar is the thing we mount on.
   bar_width = 6.5;
	bar_height = 40.5;
	bar_height_slack = 1.0;
   bar_width_slack = 0.0;
   gap = 10.0;
	// The lower arm is the thing that connets to the bar
	upper_arm_height = 50.0;
	// The width of the front "stoppers"
	front_width_stopper = 4.0;
	// Bottom thickness
	bottom_thickness = 5.0;
	// Top thickness
	top_thickness = 5.0;
	// Backside thickness
	backside_thickness = 5.0;


	// 0,0 is the top of the bar, front
	// x is towards the back, y is up.
	color([1,0,0]){
	 	polygon(points=[
			// Start with passing over the bar, then down and below from front to back.
			[0,0], [bar_width+bar_width_slack,0], 
			// Now, go down to below the bar, leave 10 mm gap
			[bar_width+bar_width_slack, 0-bar_height-bar_height_slack-gap], 
		   // Move to front of bar
		   [0.0, 0-bar_height-bar_height_slack-gap], 
			// Up, and out, this is 40% of the gap
		   [0.0, 0-bar_height-bar_height_slack-gap+0.4*gap],
			// Down, and out to make "kile" form
			[0-front_width_stopper, 0-bar_height-bar_height_slack-gap+0.3*gap], 
			// Further down, while out, to the bottom of the arm
			[0-front_width_stopper, 0-bar_height-bar_height_slack-gap-bottom_thickness], 
			// back to the back of the holder
			[bar_width+bar_width_slack+backside_thickness, 0-bar_height-bar_height_slack-gap-bottom_thickness], 
			// And, up
			[bar_width+bar_width_slack+backside_thickness, top_thickness],
			// Further up, to about 70, something
			[bar_width+bar_width_slack+backside_thickness, top_thickness+55],
			// Front part of the arm
			[bar_width+bar_width_slack+backside_thickness-12, top_thickness+55],
	      // Reduce some material
			[bar_width+bar_width_slack+backside_thickness-12, top_thickness+25],


		   // Now, build the stoppers. Back to the front, lets see what happens.
			[0-front_width_stopper, top_thickness],
			// And, down, to build the stopper
			[0-front_width_stopper, 0-0.3*gap],
			// Second part of the stopper
			[0, 0-0.4*gap]
		]);
	};


		
	// Arm to hold the cup
	translate([-46.5,101,0]) {
		rotate( [0,0,-45] ) {
		   square([70, 12] );
		}
	}
}


// Cup placement
module cup () {
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
				// This needs to be completely changed.
		      translate ([0,0,-14]) {
					cylinder( h=2, r=1, center = true, $fn=100 );
	       	}
			}
		}
	}
}

// rotate([0,-90,0] ){
//        linear_extrude( height=10, center = true ) {    
//               union () {



arm_shape();

// org_arm();
// cup();