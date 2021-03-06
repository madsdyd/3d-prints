// Thing for the remote to bed-goes-up, bed-goes-down.

use <MCAD/boxes.scad>

// Total inner length, should more or less be the width of the thing it rests on. Note, at least 23 mm.
bed_support_thickness = 23;

// The length of the thing going between the support and the matress.
tounge_length = 21;

// The rest here, should not need adjusting.
// Generel thickness of the thing.
thickness = 3;

// Generel width of the thing.
width = 28;

// Connection sizes - measured from the end that is inserted.
connector_offset = 20;

// Slack is extra length, to allow for slip on the bed support.
slack = 0;



// Weird cutout at the inside
cutout_outside_width = 6.0;
cutout_outside_height = 0.5;
cutout_inside_height = 2.2;
cutout_inside_width = 3.0 + 0.6;
cutout_outside_length = connector_offset;

cutout_left_thickness = 1.2;

// Total lenght, is the total length of one of base cube
total_length = connector_offset + slack + bed_support_thickness + thickness;

pad = 0.05;

// Various elements make it up.

$fn = 50;
// "Base"
// translate([total_length/2, 0, thickness / 2])

round_thickness = thickness + cutout_outside_height * 2; 

// This sucks. Rounds the base.
module round_it() {
    translate([round_thickness/2,0,-thickness/2])
    rotate([90,0,0])

    difference() {
    
        difference() {
            cube([round_thickness+pad*2,round_thickness+pad*2, width*1.5], center = true);
            cylinder(r = round_thickness / 2, h = width*2 + 2*pad, center = true);
            
        }
        translate([round_thickness,0,0])
        cube([round_thickness*2,round_thickness*2, width*2], center = true);
    }
}

// Lifted from the net. Thank you, nophead.
module fillet(r, h) {
    translate([r / 2, r / 2, 0])

    difference() {
        cube([r + 0.01, r + 0.01, h], center = true);

        translate([r/2, r/2, 0])
        cylinder(r = r, h = h + 1, center = true);

    }
}

// The round taps. 
round_tap_thickness = 1;
module round_tap() {
    translate([thickness/2,width/2 + round_tap_thickness/2, -thickness/2])
    rotate([90,0,0])
    cylinder(r = thickness / 2, h = round_tap_thickness + pad, center = true);
}

module round_taps() {
    round_tap();
    mirror([0,1,0]) round_tap();
}

module corner_fillet(r) {
    translate([-r, -r, 0])
    
    difference() {
        cube([r, r, r]);
        
        translate([r-pad, r-pad, r-pad])
        sphere(r = r, center = true);
        
    }
}


module base() {
    // Round all relevant corners
    difference() {
        // Difference with end of connector()
        difference() {
            difference() {
                // Base with cutout extra
                union() {
                    translate([total_length/2, 0, -(thickness / 2)])
                    cube([total_length, width, thickness], center = true);

                    translate([0,-(cutout_outside_width/2),0])
                    cube([cutout_outside_length, cutout_outside_width, cutout_outside_height]);
                }

                union() {
                    // Weird cutout
                    translate([-pad,-(cutout_inside_width/2),-(cutout_inside_height - cutout_outside_height)])
                    cube([cutout_outside_length+pad, cutout_inside_width, cutout_inside_height+pad]);

                    slits();
                }
            }
            round_it();
        }

        // Round cornes, made from fillets
        union() {
            // side
            translate([total_length / 2 + connector_offset, - width / 2, - thickness])
            rotate([0,270,0])
            fillet(thickness / 2, total_length);
            translate([total_length, - width / 2,0])
            rotate([0,180,0])
            fillet(thickness / 2, total_length);
            // Corners
            translate([total_length-thickness/2, -width/2+thickness/2, -thickness])
            rotate([0,0,90])
            corner_fillet(thickness/2);


            
            // other side
            mirror([0,1,0])
            union() {
                translate([total_length / 2 + connector_offset, - width / 2, - thickness])
                rotate([0,270,0])
                fillet(thickness / 2, total_length);
                translate([total_length, - width / 2,0])
                rotate([0,180,0])
                fillet(thickness / 2, total_length);
            // Corners
            translate([total_length-thickness/2, -width/2+thickness/2, -thickness])
            rotate([0,0,90])
            corner_fillet(thickness/2);
            }
            
            
            // End
            translate([total_length, 0, - thickness])
            rotate([0,270,90])
            fillet(thickness / 2, total_length);

            
            
        }
        
    }
    taps();

    round_taps();
}


// Tongue...
module tounge_old() {
  translate([thickness/2, 0, (tounge_length + thickness)/2])
  cube([thickness,width,tounge_length + thickness], center = true);
}
module tounge() {
    translate([thickness/2, 0, (tounge_length + thickness)/2])
    roundedBox([thickness,width,tounge_length + thickness], thickness/2, false);
}

// Taps
module tap() {
    cylinder( r = thickness / 2, h = thickness, center = true );

    // Cut off things sticking outside base cylinder
    difference() {
        // Hackish here. I do not care to look up the math.
        translate([-sin(20)*thickness/2,0,0])
        difference() {
            rotate([0,20,0])
            cylinder( r = thickness / 2, h = thickness * 2);
            cylinder( r = thickness / 2, h = thickness, center = true );
        }
        translate([thickness/2,-50,0])
        cube([100,100,100]);
    }
}

module single_tap() {
    translate([-thickness/2+connector_offset,-width/2,-thickness/2])
    rotate([270,0,90])
    tap();
}

module taps() {
    single_tap();
    mirror([0,1,0]) single_tap();
    
}


// Slits are at the sides
module slit() {
    translate([thickness,0,-thickness-pad])
    union() {
        cylinder(r = thickness / 2, h = thickness + 2 * pad);
        translate([0,-thickness/2,0])
        cube([total_length - thickness * 3, thickness, thickness + 2*pad]);
        translate([total_length - thickness*3,0,0])
        cylinder(r = thickness / 2, h = thickness + 2 * pad);
    }
}

module slits() {
    translate([0, width/2 - thickness,0]) slit();
    translate([0, -width/2 + thickness,0]) slit();
}

module main() {
    base();
    translate([total_length-thickness,0,-thickness])
    tounge();
    
}

// base();
main();
