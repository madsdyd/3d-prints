
$fn=100;

// Make a d-shaft
// @length The length of the shaft
// @diameter The diameter of the shaft
// @remain The amount of material left on one side, after cutting it flat
// @pad Padding for printing, recommended 0.05-0.1
module D_shaft(height, diameter, remain, pad) {
    difference() {
        cylinder(h=height, r=diameter/2+pad/2, center = true);
        translate([0,diameter/2+pad/2+remain+pad,0])
        cube([diameter+pad,diameter+pad,height*2], center=true);
    }
}



difference() {
    difference() {
        cylinder(r=15, h=3, center=true);
        D_shaft(6, 2.3, 0.55, 0.2);
    }
    translate([-8,3,0])
    linear_extrude(height = 4) {
        text("0.2", size = 8);
    }
}

