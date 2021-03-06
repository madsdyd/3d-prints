// Filament guide with builtin room for something to clean the filament with

// Arm with 10 mm width, centered on z, and rotated such that z is up, and x and y matches the bed. I hope.


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


module arm_shape() {

    // TODO: The z height must be about 20 mm lower to allow the spool to turn.
    
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
		// Down, and out to make wedge shape
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

// The actual arm.
module arm() {
    linear_extrude( height=10, center = true ) {    
        arm_shape();
    }
};


// Now, for the wedge. Its made of two parts.
// TODO: Round as many corners as possible.

module wedge_box() {
    linear_extrude( height=50, center = true ) {
        translate([-front_width_stopper,-bar_height+5.0,0]) {
            color("red"){
	        polygon( points=[
                        // This is from the top, leftmost point, to the top, rightmost point
                        [0.0,0.0], [front_width_stopper, 0.0],
                        // Down 5 mm
                        [front_width_stopper, -5.0],
                        // Going under the arm - this is where the wedge shape will be added.
                        [front_width_stopper+bar_width, -5.0],
                        // Going all the way down
                        [front_width_stopper+bar_width, -5.0-gap],
                        // Now, back
                        [front_width_stopper, -5.0-gap],
                        // And, up
                        [front_width_stopper, -5.0-gap+0.4*gap], 
                        [0.0, -5.0-gap+0.3*gap]
                    ]);
            }
        }
    }
}

// This is the actual wedge. Its extruded and then rotated
module wedge_wedge() {
    color("green"){

        // Translate to match the wedge_box
        translate([bar_width/2, -bar_height-gap, 0]) {
            // rotate to match the wedge_box
            rotate([0,180+90,0]) {
                // Extrude
                linear_extrude( height=bar_width, center = true ) {
                    // Translate to match center
                    translate([-25.0,0.0,0.0]) {
	                polygon( points=[
                                // This is a very simple wedge: first to right, then up, then back
                                [0.0,0.0], [50.0,0],
                                // down 3 mm, then back to 1 below
                                [50.0, -3.0], [0.0, -1.0]
                            ]);
                    }
                }
            }
        }
    }
    
}

// This is the actual wedge
module wedge() {
    color("green" ){
        union() {
            wedge_box();
            wedge_wedge();
        }
    }
}

// The width of the slit in the bottom of the cup. Something like filament diameter +.75
slit_width = 1.75+0.75;

// TODO: This need to be changed to something like a wedge, and be much bigger!

// Cup placement
module cup () {
    translate([-57,110,0] ) {
	rotate( [0, -90, -135 ] ) {
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
		    cube( [6,slit_width,2], center = true );
	       	}
	    }
	}
    }
}


////////////////////////////////////////////////////////////////////////////////
// I need the arm, then cutting a bit of the wedge from the arm, then
// a wedge in the same level as the arm.

// Arm with wedge shape cut into it
module final_arm() {
    union() {
        difference() {
            // This is the arm
            //        color("cyan", 0.7 )
            arm();

            // The first edge, used to difference with
            translate([0,0,10]) {

                //color("red", 0.7)
                wedge();
            }
        }
        // Union with the cup
        cup();
    }
}

// And, a new wedge, which needs to have its thick end down.
// And, because everything expands, cut a part of the size to allow it to fit in the slot

module final_wedge() {
    translate([-20,20,20]){
        rotate([0,180,0]) {
            
            difference() {
                wedge();
                translate([5+bar_width-1.5,-45,0]) {
                    cube([10,20,52], center = true);
                }
            }
        }
    }
}

// Main
final_arm();
final_wedge();