use <Writescad/write.scad>
use <Chamfers-for-OpenSCAD/Chamfer.scad>

// This started out as seperate stencils, but I have realised a huge
// stencil mounted in a contraption is a better idea.

stencil_thickness = 1.2; // Match layer thickness of .3 - print solid, I reckon.


// text height determines the size that will fit on the head of the pole handle.
text_height = 16;

// These measurements are for spacing issues more than anything. So, they do not match exact on the print
two_letter_width = 30;
three_letter_width = 40;
letter_height = 25; // Not really, but for spacing issues.
x_spacing = 12.5;
x_border = 15; // For the holes
y_spacing = 15;
y_border = 10;

hole_radius = 3;
hole_offset_from_edge = 7.5;


// For laying out numbers
// Make sure first row is all two_letter, or you will get issues.
num_x = 3;
num_y = 4;
number_start = 80;
number_step = 5;

// Calculated
stencil_width = 2 * x_border + two_letter_width + (num_x-1) * (three_letter_width + x_spacing);
stencil_height = 2 * y_border + num_y * letter_height + (num_y-1) * y_spacing;
echo( "stencil_width: ", stencil_width );
echo( "stencil_height: ", stencil_height );




// Not used anymore



// Sort of try to make it an elipse / oval

stencil_outer_radius1 = 22;
stencil_outer_radius2 = 30;
// stencil_outer_radius1 = 25;
//stencil_outer_radius2 = 25;

// This is the inner ones - basically the head of the poles handle.
// Used during development.
stencil_inner_radius1 = 18;
stencil_inner_radius2 = 24;


rsh_text_height = text_height / 4;

// Handle is a simple cube.
//handle_length = 100;
handle_length = 10;
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
    write(text, t = text_thickness, h = height, space = 1.2, center= true);
}

module handle() {
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

module handles() {
    handle();
    rotate([0,0,180]) handle();
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
        handles();
    }
}

///////////////////////////////////////
xi_start = 0;
xi_end = num_x-1;
yi_start = 0;
yi_end = num_y-1;

module numbers() {
    for (xi = [xi_start:xi_end] ) {
        for (yi = [yi_start:yi_end]) {
            number = number_start + xi*num_y*number_step + yi*number_step;
            // trans_y = stencil_height - ( y_border*2 + yi * (letter_height + y_spacing) );
            trans_y = stencil_height - ( y_border + letter_height / 2.0 + yi * (letter_height + y_spacing) );
            // Need to if on number < 100...
            if ( number < 100 ) {
                trans_x = x_border + xi + two_letter_width / 2.0;
                echo(number, " ", trans_x, " ", trans_y);
                translate([trans_x, trans_y, 0]) write_cc(str(number), text_height);
            } else {
                trans_x = x_border + two_letter_width + x_spacing + (xi - 1) * (three_letter_width + x_spacing) + three_letter_width / 2.0;
                echo(number, " ", trans_x, " ", trans_y);
                translate([trans_x, trans_y, 0]) write_cc(str(number), text_height);
            }
        }
    }
}


module main_cube() {
    // translate([-stencil_width/2, -stencil_height/2, -stencil_thickness/2])
    translate([0, 0, -stencil_thickness/2])
    chamferCube(stencil_width, stencil_height, stencil_thickness);
}

module main() {
    difference() {
        main_cube();
        numbers();
    }
}

main();