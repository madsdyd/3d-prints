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

// Just to make sure we go through
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

///////////////////////////////////////
// Write the numbers
module numbers() {
    xi_start = 0;
    xi_end = num_x-1;
    yi_start = 0;
    yi_end = num_y-1;
    for (yi = [yi_start:yi_end]) {
        for (xi = [xi_start:xi_end] ) {
            number = number_start + xi*num_y*number_step + yi*number_step;
            // trans_y = stencil_height - ( y_border*2 + yi * (letter_height + y_spacing) );
            trans_y = stencil_height - ( y_border + letter_height / 2.0 + yi * (letter_height + y_spacing) );
            // Need to if on number < 100...
            // "A variable can only have one value in a scope"... nice, that one.
            if ( number < 100 ) {
                trans_x = x_border + xi + two_letter_width / 2.0;
                echo(number, " ", trans_x, " ", trans_y);
                translate([trans_x, trans_y, 0]) write_cc(str(number), text_height);
            } else {
                trans_x = x_border + two_letter_width + x_spacing + (xi - 1) * (three_letter_width + x_spacing) + three_letter_width / 2.0;
                echo(number, " ", trans_x, " ", trans_y);
                translate([trans_x, trans_y, 0]) write_cc(str(number), text_height);
            }
            // Also, add the holes.
            translate([hole_offset_from_edge, trans_y, 0])
            cylinder( h = text_thickness, r = hole_radius, center = true);
            translate([stencil_width - hole_offset_from_edge, trans_y, 0])
            cylinder( h = text_thickness, r = hole_radius, center = true);
        }
    }
}

// The main cube
module main_cube() {
    // translate([-stencil_width/2, -stencil_height/2, -stencil_thickness/2])
    translate([0, 0, -stencil_thickness/2])
    chamferCube(stencil_width, stencil_height, stencil_thickness);
}

// Difference maincube with numbers and holes... 
module main() {
    difference() {
        main_cube();
        numbers();
    }
}

main();