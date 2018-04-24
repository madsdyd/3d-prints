// Module to replace a disco ball "plate" with on that produces stars


// Diameter is really set to my print area.
diameter = 180;
thickness = 1.5;
inner_diameter = 8;

star_points = 5;
// These are scaled later
star_inner_r = 0.15;
star_outer_r = 0.5;

$fn=200;

////////////////////////////////////////////////////////////////////////////////
// Copied from https://gist.github.com/anoved/9622826
// points = number of points (minimum 3)
// outer  = radius to outer points
// inner  = radius to inner points
module Star(points, outer, inner) {
    
    // polar to cartesian: radius/angle to x/y
    function x(r, a) = r * cos(a);
    function y(r, a) = r * sin(a);
    
    // angular width of each pie slice of the star
    increment = 360/points;
    
    union() {
	for (p = [0 : points-1]) {
	    
	    // outer is outer point p
	    // inner is inner point following p
	    // next is next outer point following p

	    assign(	x_outer = x(outer, increment * p),
		y_outer = y(outer, increment * p),
		x_inner = x(inner, (increment * p) + (increment/2)),
		y_inner = y(inner, (increment * p) + (increment/2)),
		x_next  = x(outer, increment * (p+1)),
		y_next  = y(outer, increment * (p+1))) {
		polygon(points = [[x_outer, y_outer], [x_inner, y_inner], [x_next, y_next], [0, 0]], paths  = [[0, 1, 2, 3]]);
	    }
	}
    }
}

////////////////////////////////////////////////////////////////////////////////
// The main plate
module plate() {
    difference() {
        cylinder(r = diameter / 2, h = thickness, center = true);
        cylinder(r = inner_diameter / 2, h = thickness * 2, center = true);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Place a star four places "on the plate"
// Angle is between 0-90 here.
module place_star(angle, distance, size, rotation) {
    rotate([0,0,angle])
    translate([distance,0,-thickness])
    rotate([0,0,rotation])
    scale([size, size, 1])
    linear_extrude( heigth = thickness * 2)
    Star(star_points, star_outer_r, star_inner_r);
}

module place_planet(angle, distance, size) {
    rotate([0,0,angle])
    translate([distance,0,0])
    scale([size, size, 1])
    cylinder(h = thickness * 2, r = 0.5, center = true);
}

module place_moon(angle, distance, size, rotation) {
    rotate([0,0,angle])
    translate([distance,0,0])
    rotate([0,0,rotation])
    scale([size, size, 1])
    difference() {
        cylinder(h = thickness * 2, r = 0.5, center = true);
        translate([-0.21,0,0])
        cylinder(h = thickness * 2, r = 0.55, center = true);
    }
}

// Duplicate this, rotated.
module kvadrant() {
    place_star( 5, 70, 6,  55);
    place_star(10, 25, 10, 00);
    place_star(12, 75,  8, 50);
    place_star(20, 85,  5, 25);
    place_star(25, 45,  3, 25);
    place_star(30, 55,  7, 20);
    place_star(45, 18,  5, 10);
    place_star(55, 65, 10, 50);
    place_star(80, 80,  8, 35);
    place_star(65, 85,  4, 25);
    place_star(70, 55,  6, 25);

    place_planet(15, 17, 4);
    place_planet(25, 67, 2);
    place_planet(65, 34, 7);

    place_moon(20, 34, 11, 8);
    place_moon(45, 77,  7, 14);
    place_moon(80, 56,  8, 50);
}

difference() {
    plate();
    kvadrant();
    rotate([0,0,90]) kvadrant();
    rotate([0,0,180]) kvadrant();
    rotate([0,0,270]) kvadrant();
}


