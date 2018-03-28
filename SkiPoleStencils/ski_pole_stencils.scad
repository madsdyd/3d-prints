use <Writescad/write.scad>
use <Chamfers-for-OpenSCAD/Chamfer.scad>

stencil_thickness = 3;

// Sort of try to make it an elipse / oval

stencil_outer_radius1 = 30;
stencil_outer_radius2 = 35;
// stencil_outer_radius1 = 25;
//stencil_outer_radius2 = 25;

// This is the inner ones - basically the head of the poles handle.
// Used during development.
stencil_inner_radius1 = 18;
stencil_inner_radius2 = 24;

// text height determines the size that will fit on the head of the pole handle.
text_height = 16;

rsh_text_height = text_height / 4;

// Handle is a simple cube.
//handle_length = 100;
handle_length = 50;
handle_width = 15;
handle_hole_radius = 3;

// Include handle
inner_only = false;

// Calculated stuff.

text_thickness = stencil_thickness * 2 ;


// Center corrected write helper funtion
module write_cc(text, height) {
    // Translate to middle of text height. 6 is emperical on the stencil font.
    // Translate X to middle of string - Empircal
    // two letters (i < 100), factor i 0.22
    // Lucky, even works with other lenghts! :-)
    translate([-(height*0.22),-height/6,0])
    write(text, t = text_thickness, thickness, h = height, space = 1.2, center= true);
}

// An oval, centered, with the number in. Includes outer stencil (cover) and handle if global variable set.

module stencil(number) {
    difference() {
        if (inner_only) {
            scale([1, stencil_inner_radius1/stencil_inner_radius2, 1]) cylinder(h=stencil_thickness, r=stencil_inner_radius2, center = true);
        } else {
            translate([0,0, -stencil_thickness/2])
            scale([1, stencil_outer_radius1/stencil_outer_radius2, 1]) chamferCylinder(height=stencil_thickness, radius=stencil_outer_radius2);
        }
        // Substract the stencil font
        write_cc(str(number), text_height);
        
        // This will not work, unfortunately
        /*
        translate([0,-stencil_inner_radius1*0.8,0])
        write_cc("RSH", rsh_text_height);
        translate([0,stencil_inner_radius1*0.8,0])
        write_cc("RSH", rsh_text_height); */
    }

    // Include handle if set for that.
    if (!inner_only) {
        // Handle. 0.9 will not work with all values.
        translate([-handle_length/2, -handle_width/2, -stencil_thickness/2])
        translate([-handle_length/2-stencil_outer_radius2*0.9,0,0])
        difference() {
            chamferCube(handle_length, handle_width, stencil_thickness);
            
            // Cut a hole for a keyring, or something
            translate([handle_width/2,handle_width/2,-stencil_thickness/2])
            cylinder(h=stencil_thickness*3, r=handle_hole_radius);
        }
    }
}

///////////////////////////////////////
i_start = 70;
i_end = 135;
i_step = 5;

module main() {
    for (i = [i_start:i_step:i_end] ) {
        my_step = (i-i_start)/i_step;
        translate([0, my_step * (stencil_inner_radius2 + 5), 0]) stencil(i);
    }
}


// main();
stencil(125);