// Holder to espcam thing
// Two major parts, a case and an arm
// The arm is made to attached to the hephestos arm and the case attachs to the arm
// The case is "totally open" by design, to allow air, 

// The physical dimensions of the esp32 cam module

// When "ESP32-CAM" can be read naturally. Camera side is front.
module_width = 27 + 0.8; // Extra gap for cutout needed.
module_height = 40; // Only used for cutout
// Tolerance is like gap for this
module_tolerance = 0.3; // I forgot to use it :-/

// The support for the corners. Must match distance from camerasupport to pcb
module_support_height = 8; 
// The width of the support.
module_support_width = 4;
// The opposite of support cutout. Quite confusing
module_support_min_material = 3;
module_pcb_thickness = 0.75 + 0.25 + 0.25; // need some slack

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
screw_hex_cutout_offset = 0;
nut_thickness = 2;
space = 0.0;




pad = 0.05;

// Inner radius adjustment. This seems to work with 0.25
inner_hole_adjustment = 0.25;



// Calculated
module_support_base_length = module_width + 2*module_support_min_material + module_arm_length;
screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;
module_screw_support_full_width = module_screw_support_thickness + screw_diameter;


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

$fn=50;
module screw_hole(hole_length) {
    rotate([0,90,0]) {
        cylinder(r = screw_radius + space, h = hole_length*2, center = true);
        translate([0,0,hole_length/2.0+25]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true);
        }
        // Hex cutout
        translate([0,0,-(hole_length/2.0+25-screw_hex_cutout_offset)]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true, $fn = 6);
        }
    }
}

module support_nut_support() {
    difference() {
        cube([module_screw_support_length, module_screw_support_full_width, module_screw_support_full_width], center = true);
        translate([nut_thickness+pad,0,0.125*module_screw_support_full_width])
        rotate([30,0,0])
        screw_hole(module_screw_support_length);
    }
    
}



// Translate ready to mount for screw
translate([-module_support_base_length,-0.5*module_support_base_depth,0]) support();
translate([0.5*module_screw_support_length-pad,0,0.5*module_screw_support_full_width]) support_nut_support();
