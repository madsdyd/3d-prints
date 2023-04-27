// Holder to espcam thing
// A number of parts
// Module holder (module support) -- totally op
// Flexible segments -- different versions wrt. attachments
// A modified hephestos arm

// The elements go together to form a multi segmented arm that can be adjusted


////////////////////////////////////////
// MODULE HOLDER

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
module_support_base_height = 3;

module_screw_support_height = 19;
module_screw_support_width = 8;
module_screw_support_length = 4;
// Offset from top
module_screw_support_offset = 5.5;


////////////////////////////////////////
// FLEXIBLE SEGMENTS

// Length of each segment
segment_length = 100;
// the thickness of the segment
segment_thickness = 4;
// The length/height of the attachment parts in each end
// Will also be the height of the segment.
segment_fastener_platform_width = 8;
// Extra platform width on arm, to allow for rotation
segment_platform_extra = 4;

////////////////////////////////////////
// SCREW MODULE STUFF

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

////////////////////////////////////////
// SHELF ARM
shelf_arm_length = 60;
shelf_arm_thickness = 4;
shelf_arm_width =  8;
shelf_arm_screw_offset = 30;

////////////////////////////////////////
// Angle arm
angle_arm_a_length = 20;
angle_arm_b_length = 30;
angle_arm_thickness = 4;
angle_arm_width = 8;



pad = 0.05;

// Inner radius adjustment. This seems to work with 0.25
inner_hole_adjustment = 0.25;



// Calculated
module_support_base_length = module_width + 2*module_support_min_material + module_arm_length;
screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;

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
module support_screw_support() {
    translate([0,0,module_screw_support_height/2.0])
    difference() {
        cube([module_screw_support_length, module_screw_support_width, module_screw_support_height], center = true);
        translate([-nut_thickness-pad,0,module_screw_support_offset])
        rotate([0,0,180])
        screw_hole(module_screw_support_length);
    }
    
}

// The final module holder module ;-) 
module cam_module_holder() {

    // Translate ready to mount for screw
    translate([-module_support_base_length,-0.5*module_support_base_depth,0]) support();
    translate([0.5*module_screw_support_length-pad,0,0]) support_screw_support();

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
// Shelf and angle arm
module shelf_arm() {
    translate([0,0,shelf_arm_thickness/2.0])
    rotate([180,0,0])
    difference() {
        cube([shelf_arm_length,shelf_arm_width,shelf_arm_thickness], center = true);
        translate([shelf_arm_length/2.0-screw_head_diameter/2.0-1,0,screw_head_thickness])
        rotate([0,90,0])
        screw_hole(shelf_arm_thickness);
        translate([shelf_arm_length/2.0-screw_head_diameter/2.0-shelf_arm_screw_offset,0,screw_head_thickness])
        rotate([0,90,0])
        screw_hole(shelf_arm_thickness);



        translate([-shelf_arm_length/2.0+screw_head_diameter/2.0+1,0,nut_thickness])
        rotate([0,270,0])
        screw_hole(shelf_arm_thickness);
    }
}

module angle_arm() {
    translate([0,pad,0])
    mirror([1,1,0])
    difference() {
        cube([angle_arm_a_length,angle_arm_thickness, angle_arm_width]);
        translate([angle_arm_a_length-screw_head_diameter/2.0-1,0,angle_arm_width/2.0])
        rotate([0,0,90])
        screw_hole(angle_arm_thickness);
    }
    translate([-angle_arm_thickness,0,0])
    difference() {
        cube([angle_arm_b_length,angle_arm_thickness, angle_arm_width]);
        translate([angle_arm_b_length-screw_head_diameter/2.0-1,0,angle_arm_width/2.0])
        rotate([0,0,90])
        screw_hole(angle_arm_thickness);
    }

    
}



////////////////////////////////////////////////////////////////////////////////
// SEGMENTS

module fastener_platform(screw) {
    // A fastener
    difference() {
        cube([segment_fastener_platform_width, segment_thickness, segment_fastener_platform_width],
            center = true);
        if (screw) {
            translate([0,screw_head_thickness,0])
            rotate([0,0,270])
            screw_hole(segment_thickness);
        } else {
            translate([0,nut_thickness,0])
            rotate([0,0,90])
            screw_hole(segment_thickness);
        }
    }
}

// Segment
module segment(a_screw,b_screw) {
    translate([0,0,segment_fastener_platform_width/2.0]) {
    // A platform
    translate([segment_length/2.0-segment_fastener_platform_width/2.0-pad,-segment_thickness/2.0,0])
    fastener_platform(a_screw);

    // Add some extras to both ends, to be able to turn stuff freely
    translate([segment_length/2.0-segment_fastener_platform_width-segment_platform_extra/2.0+pad,-segment_thickness/2.0,0])
    cube([segment_platform_extra,segment_thickness,segment_fastener_platform_width], center=true);
    
    translate([-segment_length/2.0+segment_fastener_platform_width+segment_platform_extra/2.0-pad,segment_thickness/2.0,0])
    cube([segment_platform_extra,segment_thickness,segment_fastener_platform_width], center=true);


    
    // Use a hull for the arm. This is 1 mm offset
    hull() {
        translate([segment_length/2.0-segment_fastener_platform_width-segment_platform_extra-0.5+2*pad,-segment_thickness/2.0,0])
        cube([1,segment_thickness,segment_fastener_platform_width], center=true);
        
        translate([-segment_length/2.0+segment_fastener_platform_width+segment_platform_extra+0.5-2*pad,segment_thickness/2.0,0])
        cube([1,segment_thickness,segment_fastener_platform_width], center=true);

    }
    
    // B platform
    translate([-segment_length/2.0+segment_fastener_platform_width/2.0-pad,segment_thickness/2.0,0])
    rotate([0,0,180])
    fastener_platform(b_screw);
    }
}



////////////////////////////////////////////////////////////////////////////////
// MAIN

// screw_hole(module_screw_support_length);

// The module holder
// cam_module_holder();

// Modified Hephestos arm
// translate([0,-40,0]) cam_arm();

// Shelf arm
translate([0,20,0]) shelf_arm();

// angle arm
angle_arm();

// Modules

// And, a number of normals
// translate([0,10,0]) segment(false, true);
// translate([0,20,0]) segment(false, true);
// translate([0,30,0]) segment(false, true);
// translate([0,40,0]) segment(false, true);
// translate([0,50,0]) segment(false, true);


// These are not actually used:
// For near module holder, we need screw, screw
// segment(true,true);
// And, finally, we need nut, nut near the arm
// translate([0,40,0]) segment(false, false);

// segment(true,true);
// segment(false,false);

