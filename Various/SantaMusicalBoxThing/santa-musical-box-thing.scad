// Parameters

box_width = 45;
box_depth = 36; // 32 + 2 * 2
santa_bottom_depth = 32;
box_height = 14;
box_wall_thickness = 2;
box_front_radius = 11;
box_side_wall_thickness = 4;


box_fastener_support_thickness = 5;
box_fastener_support_width = 8;
// LID
lid_overlap= 3; // Minus the sidewall overlap. Sigh.
lid_tolerance = 0.25;


////////////////////////////////////////
// SCREW MODULE STUFF

// Screw stuff
// Screw diameter
screw_diameter = 3.6;
// Screw head diameter -- also used for hex nut cutout
screw_head_diameter = 6;
// Screw cutout length. This should really be calculated...
screw_cutout_length = 15;
nut_thickness = 2;
space = 0.0;
screw_head_thickness = 2;
inner_hole_adjustment = 0.25;


screw_radius = screw_diameter / 2.0;
screw_head_radius = screw_head_diameter / 2.0;



pad = 0.05;
$fn=50;

// Create a screw cutout of a given length
// Center is center of cutout. Translate for only nut or head.
module screw_hole(hole_length) {
    rotate([0, 90, 0]) {
        // Room for screw
        cylinder(r = screw_radius + space, h = hole_length * 2, center = true);
        // Screw head cutout
        translate([0, 0, hole_length / 2.0 + screw_head_thickness / 2.0]) {
            cylinder(r1 = screw_radius + space, r2 = screw_head_radius + inner_hole_adjustment, h = screw_head_thickness
            , center = true);
        }
        // Extension of head cutout
        translate([0, 0, hole_length / 2.0 + 25 + screw_head_thickness - pad]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true
            );
        }
        // Hex nut cutout
        translate([0, 0, - (hole_length / 2.0 + 25)]) {
            cylinder(r = screw_head_radius + inner_hole_adjustment, h = 50, center = true
            , $fn = 6);
        }
    }
}


module front() {
    // Add a front
    rotate([0,90,0])
    translate([0, box_front_radius - front_cutoff_thickness -box_depth/2.0+pad,0])
    difference() {
        cylinder(r = box_front_radius, h = box_width, center = true, $fn=240);
        cube([100, 2*front_cutoff, box_width + pad], center=true);
        translate([0,front_cutoff,0])
        cube([100, 2*front_cutoff, box_width + pad], center=true);

    }
}

module inner_extrude() {
    rotate([90,0,0])
    linear_extrude(height = box_depth-2*box_wall_thickness, center=true)
    polygon(points=[[-pad,box_height/2.0-box_wall_thickness],
            [box_width/2.0-box_side_wall_thickness, box_height/2.0-box_wall_thickness],
            [box_width/2.0-box_side_wall_thickness, box_height/2.0-box_wall_thickness],
            [box_width/2.0-box_wall_thickness, box_height/2.0-box_side_wall_thickness],
            [box_width/2.0-box_wall_thickness, -box_height/2.0+box_wall_thickness],
            [-pad,-box_height/2.0+box_wall_thickness]]);

}


// Front cylinder cutoff calculations
front_cutoff = sqrt(box_front_radius^2 - (box_height/2.0)^2);
front_cutoff_thickness = box_front_radius - front_cutoff;
echo(front_cutoff);
module box() {
    difference() {
        cube([box_width, box_depth, box_height], center = true);
        

        // Inner cutout
        inner_extrude();
        mirror([1,0,0])
        inner_extrude();

        // Top hole
        translate([0,-0.5*(box_depth-santa_bottom_depth),box_height/2.0-box_wall_thickness/2.0])
        cube([box_width - 2*box_side_wall_thickness, santa_bottom_depth - 2*box_wall_thickness,
                box_wall_thickness + 2*pad], center=true);

        // Backplate hole
        translate([0,box_depth/2.0-box_wall_thickness/2.0,0])
        cube([box_width - 2* box_wall_thickness, box_wall_thickness + 2*pad,
                box_height - 2*box_wall_thickness], center=true);


        
        
    }

    // Support for screw in one side
    translate([box_width/2.0-box_wall_thickness-box_fastener_support_width/2.0,
            box_depth/2.0-box_wall_thickness-box_fastener_support_thickness/2.0,
            0])

    difference() {

    cube([box_fastener_support_width,
            box_fastener_support_thickness,
            box_height-pad,],center=true);
    translate([0,nut_thickness,0])
    rotate([0,0,90])
    screw_hole(box_fastener_support_thickness);
}

    
    // Support for lid in other side
    translate([-box_width/2.0+box_wall_thickness+lid_overlap/2.0,
            box_depth/2.0-box_wall_thickness/2.0,
            0])
    cube([lid_overlap,box_wall_thickness,box_height-pad,],center=true);
    
    front();
    
}


module lid() {

    lid_width_e = box_width-2*box_wall_thickness-2*lid_tolerance-lid_overlap;

    cube([lid_width_e,
            box_wall_thickness,
            box_height-2*box_wall_thickness-2*lid_tolerance], center = true);
    translate([-lid_width_e/2.0+0.5*lid_overlap,-box_wall_thickness-lid_tolerance/2.0+pad,0])
    cube([lid_overlap,
            box_wall_thickness + lid_tolerance,
            box_height-2*box_wall_thickness-2*lid_tolerance], center = true);
    translate([-lid_width_e/2.0+lid_tolerance,
            -box_wall_thickness-lid_tolerance+pad,
            -box_side_wall_thickness/2.0+box_wall_thickness/2.0])
    cube([lid_overlap*2-2*lid_tolerance,
            box_wall_thickness,
            box_height-box_wall_thickness-box_side_wall_thickness-2*lid_tolerance], center = true);
    
}


translate([0,0,box_height/2.0])
box();


// translate([-box_width-10,0,box_height/2.0])
translate([lid_overlap/2.0,box_depth/2.0-0.5*box_wall_thickness,box_height/2.0])
#lid();