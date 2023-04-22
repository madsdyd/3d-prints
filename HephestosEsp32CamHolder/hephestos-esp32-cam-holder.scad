// Holder to espcam thing
// Two major parts, a case and an arm
// The arm is made to attached to the hephestos arm and the case attachs to the arm
// The case is "totally open" by design, to allow air, 

// The physical dimensions of the esp32 cam module

// When "ESP32-CAM" can be read naturally. Camera side is front.
module_width = 27;
module_height = 40; // Only used for cutout
// Tolerance is like gap for this
module_tolerance = 0.3;

// The support for the corners. Must match distance from camerasupport to pcb
module_support_height = 8; 
// The width of the support.
module_support_width = 4;
// The opposite of support cutout. Quite confusing
module_support_min_material = 3;
module_pcb_thickness = 0.75 + 0.25; // need some slack

// Support for arm on module
module_arm_length = 20;
module_support_base_depth = 3;
module_support_base_height =3;

pad = 0.05;

// Calculated
module_support_base_length = module_width + 2*module_support_min_material + module_arm_length;

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

// Translate ready to mount for screw
translate([-module_support_base_length,-0.5*module_support_base_depth,0])
support();

