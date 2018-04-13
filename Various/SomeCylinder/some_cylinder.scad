// From Facebook.
difference() {
    cylinder(r1 = 305/2, r2 = 315/2, h = 300, center = true);
    translate([0,0, (300-273)/2])
    cylinder(r1 = 250/2, r2 = 266/2, h = 273, center = true);
}