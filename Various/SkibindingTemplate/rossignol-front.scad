// Template for the front binding of my rossignol skis

$fn = 50;

// Diameter of all holes. Note, the markings are the "New ones"
hole_diameter = 5.5; // Real is 5, but I need slightly larger because of print

marking_hole_diameter = 3.0; // Pencil marking, again, slightly larger than needed.

// There are two sets of holdes. This is the center distance between each set
front_center_distance = 42.5;
back_center_distance = 35.0;

// The distance between front and back rows
front_back_center_distance = 41.5;

// The offset for the duplicates/markings, positive is forward
offset = 20.0;

// The margin - extra printed stuff
margin = 10.0;

// Thickness
thickness = 2.0;

// Calculated
BASE_WIDTH = max( front_center_distance, back_center_distance ) + hole_diameter + 2 * margin;
BASE_LENGTH = front_back_center_distance + offset + 2 * margin;
BASE_THICKNESS = thickness;

// Cut everything from the base. Place it with y axis aligned to back row of holes
module base() {
    translate([BASE_LENGTH/2, 0, 0] ){
        cube([ BASE_LENGTH, BASE_WIDTH, BASE_THICKNESS ], center = true );
    }
}

module hole( radius ) {
    cylinder( r = radius, h = thickness * 2, center = true );
}

module hole_set( radius, offset, center_distance ) {
    translate([offset, 0, 0 ]) {
        translate([0, center_distance/2.0, 0]) {
            hole( radius );
        }
        translate([0, -center_distance/2.0, 0]) {
            hole( radius );
        }
    }
}

// Does four holes that matches the layout of the binding, but variable offset and radius.
module hole_set_simple( radius, offset ) {
    hole_set( radius, offset, back_center_distance );
    hole_set( radius, offset + front_back_center_distance, front_center_distance );
}

// main
difference() {
    base();
    hole_set_simple( hole_diameter/2.0, margin );
    hole_set_simple( marking_hole_diameter/2.0, margin + offset );
}