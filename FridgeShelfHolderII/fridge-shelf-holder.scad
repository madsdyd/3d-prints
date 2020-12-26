// Stab two at fridge-shelf-holder

// Out measures of holder
length = 40;
width = 37;
height = 15;
underside_height = 3;
solid_width = 21;

// Corner fillet radius
//fillet = 1;

// shelf thickness, + padding
shelf_thickness = 4 + 0.1;


// Alternative measures
thickness_plate = 20;    // Thickness across the part that holds the class plate
thickness_support = 10;  // Thickness of the support
width = 45;              // Total width of the part
width_plate = 20;        // Width of cutout for plate
width_support = 20;      // Width of part for support
width_transition = width - width_plate - width_support;
thickness_transition = thickness_plate - thickness_support;
corner_radius = 1;       // Add roundness to the corners.
// These makes more sense, when looking at the polygon below.


module main () {
    difference(){
    cube([length,height,width], center = true);

    // And, cut it with this

    translate([0,height/2-shelf_thickness/2-underside_height,solid_width])
    cube([length + 10, shelf_thickness, width], center = true);
    }
}

/*

Ascii art of profile

p1  +----+ p2
    |     \
    |   p3 +----+ p4
    |           |
p0  +-----------+ p5

extruded, mirroed, and gets a partial cutout

*/
module alt_base_shape(length) {
    linear_extrude(height=length, center=true) {
        polygon(points = [
                [corner_radius,0], // p0
                [corner_radius, thickness_plate / 2.0 - corner_radius], // p1
                [corner_radius + width_plate / 2.0, thickness_plate / 2.0 - corner_radius], // p2
                [corner_radius + width_plate / 2.0 + width_transition / 2.0, thickness_support / 2.0 - corner_radius], // p3
                [width / 2.0 - corner_radius, thickness_support / 2.0 - corner_radius],
                [width / 2.0 - corner_radius, 0]
            ]);
    }
}

$fn = 50;
module alternative(length, padding) {
    minkowski() { // Basic shape, without cutout
        union() {
            alt_base_shape(length);
            mirror([0,1,0]) {
                alt_base_shape(length);
            }
        }
        cylinder(r = corner_radius);
    }
}
    

alternative(20, 10);

// main();