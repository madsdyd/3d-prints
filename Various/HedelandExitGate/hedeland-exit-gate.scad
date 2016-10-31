// Some simple letters for the exit gate

$fn=30;

hole_diameter = 4;
hole_diameter_key = 3;


module sign_one(size, thickness) {
    difference() {
        // Adjust to center - try and keep size dependant.
        linear_extrude(thickness)
        translate([size/90.0-size/16.0,0,0])
        text("1", size=size, font = "Droid Sans", halign="center");

        // Substract two holes.
        translate([0,size*0.9,0])
        cylinder(r = hole_diameter / 2.0, h=thickness*2, center = true );
        // Substract two holes.
        translate([0,size*0.1,0])
        cylinder(r = hole_diameter / 2.0, h=thickness*2, center = true );

    }
}

module sign_two(size, thickness) {
    difference() {
        // Adjust to center - try and keep size dependant.
        linear_extrude(thickness)
        translate([size/90.0-size/60.0,0,0])
        text("2", size=size, font = "Droid Sans", halign="center");

        // Substract two holes.
        translate([0,size*0.9525,0])
        cylinder(r = hole_diameter / 2.0, h=thickness*2, center = true );
        // Substract two holes.
        translate([0,size*0.0555,0])
        cylinder(r = hole_diameter / 2.0, h=thickness*2, center = true );

    }
}
module key_one(size, thickness) {
    difference() {
        // Adjust to center - try and keep size dependant.
        linear_extrude(thickness)
        translate([size/90.0-size/16.0,0,0])
        text("1", size=size, font = "Droid Sans", halign="center");

        // Substract a hole.
        translate([0,size*0.9,0])
        cylinder(r = hole_diameter_key / 2.0, h=thickness*2, center = true );
    }
}

module key_two(size, thickness) {
    difference() {
        // Adjust to center - try and keep size dependant.
        linear_extrude(thickness)
        translate([size/90.0-size/60.0,0,0])
        text("2", size=size, font = "Droid Sans", halign="center");

        // Substract a hole.
        translate([0,size*0.9525,0])
        cylinder(r = hole_diameter_key / 2.0, h=thickness*2, center = true );
    }
}

translate([35,0,0]) {
    translate([35,0,0]) {
        translate([55,0,0])
        sign_one(80, 6);
        sign_two(80,6);
    }
    key_one(50,5);
}
key_two(50,5);
