use <Writescad/write.scad>

stencil_thickness = 3;

// Sort of try to make it an elipse / oval

stencil_outer_radius1 = 35;
stencil_outer_radius2 = 45;

// This is the inner ones - basically the head of the poles handle.
// Used during development.
stencil_inner_radius1 = 15;
stencil_inner_radius2 = 20;

// text height determines the size that will fit on the head of the pole handle.
text_height = 13;

// Handle is a simple cube.
handle_length = 100;
handle_width = 15;

// Include handle
inner_only = true;

// Calculated stuff.

text_thickness = stencil_thickness * 2 ;

// An oval, centered, with the number in. Includes outer stencil (cover) and handle if global variable set.

module stencil(number) {
    difference() {
        if (inner_only) {
            scale([1, stencil_inner_radius1/stencil_inner_radius2, 1]) cylinder(h=stencil_thickness, r=stencil_inner_radius2, center = true);
        } else {
            scale([1, stencil_outer_radius1/stencil_outer_radius2, 1]) cylinder(h=stencil_thickness, r=stencil_outer_radius2, center = true);
        }
        // Translate to middle of text height. 6 is emperical on the stencil font.
        // Translate X to middle of string - Empircal
        // two letters (i < 100), factor i 0.22
        // Lucky, even works with other lenghts! :-)

        translate([-(text_height*0.22),-text_height/6,0])
        write(str(number), t = text_thickness, h = text_height, space = 1.2, center= true);
    }

    // Include handle if set for that.
    if (!inner_only) {
        // Handle. 0.9 will not work with all values.
        translate([-handle_length/2-stencil_outer_radius2*0.9,0,0])
        cube([handle_length, handle_width, stencil_thickness], center = true);
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