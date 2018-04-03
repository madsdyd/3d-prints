// Some small tags for luggage. Print in bright colors
use <chamfer.scad>
use <write.scad>

tag_radius = 30;
tag_thickness = 3;
hole_radius = 4;
hole_offset = 8; // From edge

text_letter = "D";
text_height = 25;


// Center corrected write helper funtion
module write_cc(text, height) {
    // Translate to middle of text height. 6 is emperical on the stencil font.
    // Translate X to middle of string - Empircal
    // two letters (i < 100), factor i 0.22
    // Lucky, even works with other lenghts! :-)
    translate([-(height*0.22),-height/6,0])
    write(text, t = tag_thickness*3, h = height, space = 1.2, center= true);
}


module main() {
    difference() {
        // tag
        chamferCylinder(radius = tag_radius, height = tag_thickness);
        // Writing
        write_cc(text_letter, text_height);
        
        // Hole
        translate([-(tag_radius-hole_offset),0,0])
        cylinder(r = hole_radius, h = tag_thickness * 3, center = true);
        

    }
}


main();