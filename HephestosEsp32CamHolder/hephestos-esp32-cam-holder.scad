// Holder to espcam thing
// Two major parts, a case and an arm
// The arm is made to attached to the hephestos arm and the case attachs to the arm
// The case is "totally open" by design, to allow air, 

// The physical dimensions of the esp32 cam module

// When "ESP32-CAM" can be read naturally. Camera side is front.
module_width = 27 + 0.7; // Extra gap for cutout needed.
module_height = 40; // Only used for cutout
// Tolerance is like gap for this
module_tolerance = 0.3; // I forgot to use it :-/

// The support for the corners. Must match distance from camerasupport to pcb
module_support_height = 8; 
// The width of the support.
module_support_width = 4;
// The opposite of support cutout. Quite confusing
module_support_min_material = 3;
module_pcb_thickness = 0.75 + 0.25 + 0.20; // need some slack

// Support for arm on module
module_arm_length = 20;
module_support_base_depth = 3;
module_support_base_height =3;

module_screw_support_thickness = 7;
module_screw_support_length = 8;




// Screw stuff
// Screw diameter
screw_diameter = 3.6;
// Screw head diameter -- also used for hex nut cutout
screw_head_diameter = 6;
// Screw cutout length. This should really be calculated...
screw_cutout_length = 15;
nut_thickness = 2;
space = 0.0;
screw_head_thickness = 2;



pad = 0.05;

// Inner radius adjustment. This seems to work with 0.25
inner_hole_adjustment = 0.25;



// Calculated
module_support_base_length = module_width + 2*module_support_min_material + module_arm_length;
screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;
module_screw_support_full_width = module_screw_support_thickness + screw_diameter;

////////////////////////////////////////////////////////////////////////////////
// GENERAL


// Create a screw cutout of a given length
// Center is center of cutout. Translate for only nut or head.
$fn=50;
module screw_hole(hole_length) {
    rotate([0,90,0]) {
        // Room for screw
        cylinder(r = screw_radius + space, h = hole_length*2, center = true);
        // Screw head cutout
        translate([0,0,hole_length/2.0+screw_head_thickness/2.0]) {
            cylinder(r1=screw_radius + space, r2 = screw_head_radius + inner_hole_adjustment, h = screw_head_thickness, center = true);
        }
        // Extension of head cutout
        translate([0,0,hole_length/2.0+25+screw_head_thickness-pad]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true);
        }
        // Hex nut cutout
        translate([0,0,-(hole_length/2.0+25)]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true, $fn = 6);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// MODULE HOLDER

module pcb() {
    cube([module_width, module_pcb_thickness, module_height]);
    
}


// The case is really just some corners to grab by.
module support() {

    difference() {
        union() {
            // The support support...
            cube([module_support_base_length, module_support_base_depth, module_support_base_height]);
            // left corner holder
            translate([0,0,module_support_base_height-pad])
            cube([module_support_width+module_support_min_material, module_support_base_depth, module_support_height]);
            // right corner holder
            translate([module_width-module_support_width+module_support_min_material,0,module_support_base_height-pad])
            cube([module_support_width+module_support_min_material, module_support_base_depth, module_support_height]);
            
            
        }
        #translate([module_support_min_material,
                -module_pcb_thickness/2.0+0.5*module_support_base_depth,
                module_support_base_height])
        pcb();
    }
}


// The part of the module holder that constitues the nut support.
module support_nut_support() {
    difference() {
        cube([module_screw_support_length, module_screw_support_full_width, module_screw_support_full_width], center = true);
        translate([nut_thickness+pad,0,0.125*module_screw_support_full_width])
        rotate([30,0,0])
        screw_hole(module_screw_support_length);
    }
    
}

// The final module holder module ;-) 
module cam_module_holder() {

    // Translate ready to mount for screw
    translate([-module_support_base_length,-0.5*module_support_base_depth,0]) support();
    translate([0.5*module_screw_support_length-pad,0,0.5*module_screw_support_full_width]) support_nut_support();

}

////////////////////////////////////////////////////////////////////////////////
// HEPHESTOS ROLLER HOLDER ATTACHMENT

// Original arm -- GPL from Bq.
module hephestos_arm() {
    mirror([ 0, 1, 0 ])    {
	difference()	{
	    union()	    {

		//enganche con marco
		difference()		{
		    union()		    {
			minkowski()			{
			    cylinder(h=8, r=6, $fn=100, center=true);
			    translate([20,3.5,8])cube(size=[40,7,8], center=true);
			}

			//Cuerpo spooler
			linear_extrude(height = 10)
			polygon(points=[	[-2.5,12.4], /*pico enganche superior*/
				[43,-5.35], /*pico encganche inferior*/
				[-130,-50],
				[-130,-40] ]);

			//base soporte
			translate([-130,-42,5])cylinder(h=10, r=12, $fn=100, center=true);
		    }
		    translate([20,3.5,10])cube(size=[41,7,25], center=true);
		    translate([26.1,9.5,10])cube(size=[40,7.5,25], center=true);
		    translate([0,0,18])cube(size=[100,50,16], center=true);
		    translate([-130,-42,-1])cylinder(h=30, r=1.8, $fn=100, center=true);
		}
		translate([-130,-42,17.5])cylinder(h=35, r=10, $fn=100, center=true);
	    }//Fin union()
	}

    }
}

module cam_arm() {
    difference() {
        hephestos_arm();
        translate([-110,38.5,10/2.0-screw_head_thickness])
        rotate([0,270,0])
        screw_hole(10);
    }
}


////////////////////////////////////////////////////////////////////////////////
// MAIN

// screw_hole(module_screw_support_length);


// cam_module_holder();
cam_arm();