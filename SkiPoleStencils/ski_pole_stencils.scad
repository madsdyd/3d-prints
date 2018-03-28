use <Writescad/write.scad>

stencil_thickness = 3;

// Sort of try to make it an elipse / oval
stencil_radius1 = 15;
stencil_radius2 = 20;

text_height = 9;


// Table
// 15=3.3, 12 = 2.6, 9 = 2, 6 = 1.3, 3 = 0.65, 2 = 0.43, 1 = 0.21


// Calculated stuff.

text_thickness = stencil_thickness * 2 ;

// An oval, centered, with the number in.

module stencil_inner(number) {
    difference() {
        scale([1, stencil_radius1/stencil_radius2, 1]) cylinder(h=stencil_thickness, r=stencil_radius1, center = true);
        // Translate to middle of text height. 6 is emperical on the stencil font.
        // Translate X to middle of string - Empircal
        // two letters (i < 100), factor i 0.22
        // Lucky, even works with other lenghts! :-)

        translate([-(text_height*0.22),-text_height/6,0])
        write(str(number), t = text_thickness, h = text_height, space = 1.2, center= true);
    }
}

// Full stencil, with handle.
module stencil(number) {
    stencil_inner(number);
}


i_start = 70;
i_end = 135;
i_step = 5;

module main() {
    for (i = [i_start:i_step:i_end] ) {
        my_step = (i-i_start)/i_step;
        translate([0, my_step * (stencil_radius2 + 5), 0]) stencil(i);
    }
}


// main();
stencil(125);