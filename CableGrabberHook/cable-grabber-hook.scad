// Thingies, that can grab eachother, for use in the carport.

// Three parts are provided:
// * An anchor, which is mounted to a wire.
// * A "grabber" which is mounted to a flat surface
// * Another grabber, which is mounted to a type2 connector

anchor_thickness = 8;
anchor_width = 60;
anchor_length = 70;
anchor_arm_width = 8;
anchor_wire_diameter = 6;
anchor_wire_hole_offset = 5; // From edge of hole to end of anchor.

surface_pivot_length = 30;
surface_pivot_height = 14;
surface_pivot_thickness = 10;
surface_pivot_keel_diameter = 30;
surface_pivot_keel_thickness_surface = 2;
surface_pivot_keel_thickness_slope = 2;

screw_hole_diameter = 4;
screw_counter_sunk_diameter = 8;
// screw_counter_sunk_angle = 45; Always assumed

// Calculated fields
screw_hole_radius = screw_hole_diameter / 2.0;
screw_counter_sunk_radius = screw_counter_sunk_diameter / 2.0;

handle_hole_width = 6;
handle_hole_height = 1.8;
handle_hole_end_offset = 2;
handle_feet_thickness = 1.5;
handle_feet_width = 3;

pad = 0.05;
$fn = 50;

module half_anchor() {
    // cube([anchor_length, anchor_width, anchor_thickness], center = true);
    linear_extrude(height = anchor_thickness) {
        polygon( points=[
                [0,0],
                [anchor_length,0],
                [anchor_length-anchor_arm_width*0.35, anchor_width/2-anchor_arm_width*0.2],
                [anchor_length - anchor_arm_width, anchor_width/2],
                [anchor_length - anchor_arm_width*3, anchor_width/2-anchor_arm_width/2],
                [anchor_length - anchor_arm_width*2.9, anchor_width/2-anchor_arm_width],
                [anchor_length - anchor_arm_width*1.2, anchor_width/2-anchor_arm_width],
                [anchor_length - anchor_arm_width, anchor_arm_width/2],
                [0, anchor_arm_width/2],

            ] );
    }
}

module anchor() {
    difference() {
        minkowski() {
            translate([0,0,-anchor_thickness/2]) {
                half_anchor();
                mirror([0,1,0]) half_anchor();
            }
            sphere(1);
        }
        // hole for wire
        translate([anchor_wire_diameter/2+anchor_wire_hole_offset,0,0])
        rotate([90,0,0])
        cylinder(r = anchor_wire_diameter / 2, h = anchor_arm_width * 2, center = true);
    }
}


// Make a simple screwhole
module screw_hole() {
    translate([0,0,-screw_counter_sunk_radius/2.0]) {
        translate([0,0,-screw_counter_sunk_radius/2.0])
        cylinder(r1 = 0, r2 = screw_counter_sunk_radius, h = screw_counter_sunk_radius);
    
        translate([0,0,-1000])
        cylinder(r = screw_hole_radius, h = 1000);
    }
}


module keel_part() {
    // And, a linear extrude. There is probably an easier way to do this.
    rotate([0,90,0])
    linear_extrude(height = (surface_pivot_length - surface_pivot_thickness)/2) {
        polygon( points = [
                [0,0],
                [0,surface_pivot_thickness / 2],
                [surface_pivot_keel_thickness_slope, surface_pivot_keel_diameter/2],
                [surface_pivot_keel_thickness_slope+surface_pivot_keel_thickness_surface, surface_pivot_keel_diameter/2],
                [surface_pivot_keel_thickness_slope+surface_pivot_keel_thickness_surface, 0]
            ] );
    }
}

module surface_pivot_end() {
    translate([-(surface_pivot_length - surface_pivot_thickness)/2,0,-surface_pivot_height/2]) {
        // The round stuff.
        cylinder(r = surface_pivot_thickness / 2, h = surface_pivot_height/2);
        translate([0,0,-surface_pivot_keel_thickness_slope])
        cylinder(r2 = surface_pivot_thickness / 2, r1 = surface_pivot_keel_diameter / 2,
            h = surface_pivot_keel_thickness_slope);
        translate([0,0,-surface_pivot_keel_thickness_slope-surface_pivot_keel_thickness_surface])
        cylinder(r = surface_pivot_keel_diameter / 2,
            h = surface_pivot_keel_thickness_surface); 
        // The non-round stuff
        translate([surface_pivot_thickness/2,0,surface_pivot_height/4])
        cube([(surface_pivot_length - surface_pivot_thickness)/2, surface_pivot_thickness, surface_pivot_height/2], center = true);
        keel_part();
        mirror([0,1,0]) keel_part();
    }
}

module surface_pivot_end_full() {
    difference() {
        union() {
            surface_pivot_end();
            mirror([0,0,1]) surface_pivot_end();
        }
        // Substract a screw hole
        translate([-(surface_pivot_length-surface_pivot_thickness)/2,0,surface_pivot_height/2+surface_pivot_keel_thickness_surface+surface_pivot_keel_thickness_slope+pad])
        screw_hole();
    }
}

module surface_pivot() {
    surface_pivot_end_full();
    mirror([1,0,0]) surface_pivot_end_full();
}


module handle_pivot_end() {
    surface_pivot_end();
}

module handle_pivot_end_full() {
    difference() {
        union() {
            handle_pivot_end();
            mirror([0,0,1]) handle_pivot_end();
        }
        // Room for hole
        translate([handle_hole_width/2 -(surface_pivot_length)/2 + handle_hole_end_offset,
                0,
                -surface_pivot_height/2])
        cube([handle_hole_width, 1000, handle_hole_height], center = true);

    }
    // Room for feet
    translate([
            (-surface_pivot_length/2+surface_pivot_thickness/2)/2,
            surface_pivot_keel_diameter/2-handle_feet_width/2,
            -handle_feet_thickness/2 - surface_pivot_height/2 - surface_pivot_keel_thickness_surface - surface_pivot_keel_thickness_slope])
    cube([surface_pivot_length/2-surface_pivot_thickness/2, handle_feet_width, handle_feet_thickness], center = true);
}

module handle_pivot() {
    handle_pivot_end_full();
    mirror([1,0,0]) handle_pivot_end_full();
}

//translate([0,50,0])
//surface_pivot();

//translate([0,-50,0])
handle_pivot_end_full();

// anchor();
