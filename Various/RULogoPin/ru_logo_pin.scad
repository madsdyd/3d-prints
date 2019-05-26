// RU Logo pin

tag_radius = 15; // Not really a radius - this is a diameter. Sigh.
tag_thickness = 2.8; // Thickness of what, really?
tag_chamfer = 0.2;
corner_fraction = 4;
hole_radius = 4;
hole_offset = 8; // From edge

use <PraxisEF-Bold.otf>
use <PraxisEF-Regular.otf>
text_letter = "?"; 
text_size = 13;
text_thickness = 2.4;
font="PraxisEF:style=Bold";
//font="PraxisEF:style=Regular";


$fn=200;

// Cube with rounded corners
module roundedRect(size, radius)
{
    x = size[0];
    y = size[1];
    z = size[2];

    linear_extrude(height=z)
    hull()
    {
        // place 4 circles in the corners, with the given radius
        translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
        circle(r=radius);

        translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
        circle(r=radius);

        translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
        circle(r=radius);

        translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
        circle(r=radius);
    }

}


module main() {
    scale([0.80,0.80,1,])
    union() {
        translate([0,0,-tag_thickness-0.05])
        roundedRect([tag_radius, tag_radius, tag_thickness], tag_radius/corner_fraction);
        // roundedRect([tag_radius, tag_radius, tag_thickness], 1);
        #linear_extrude(text_thickness) {
            text(text = text_letter, halign = "center", valign = "center", size=text_size,
                font=font);
        }
    }
    // This is something to grab, when using it to create a negative
    translate([0,0,-30-tag_thickness+0.25])
    cylinder(h=30, r = tag_radius/2 + 5);
}

main();