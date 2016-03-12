// Jesper stl fence

staff_thickness = 1.6;
// The holder is the horizontal parts.
holder_thickness = 1.0;
staff_width = 2.5;
staff_spacing = 2.5;
top_vertical_percent = 55;
bottom_vertical_percent = 15;

// Support is below fence...
support_height = 10;

target_length = 50;
target_height = 22.5;

pad=0.5;

// Calculated constants
section_width = staff_width + staff_spacing;
number_of_staffs = floor( target_length / section_width );
total_length = number_of_staffs * ( staff_width + staff_spacing ) - staff_spacing;

module staff() {
    // The staff top
    translate([0,0,target_height-staff_width/sqrt(2)])
    rotate([0,45,0])
    cube([staff_width/sqrt(2),staff_thickness, staff_width/sqrt(2)]);
    // The staff bottom
    cube([staff_width, staff_thickness, target_height-staff_width/sqrt(2)]);
    // Stuff to insert into the ground
    translate([0,0,-support_height + pad])
    cube([staff_width, staff_thickness, support_height]);
}

// The horizontal holders.
module holder() {
    translate([0, staff_thickness-holder_thickness, target_height*top_vertical_percent/100])
    cube([total_length, holder_thickness, staff_width]);
    translate([0, staff_thickness-holder_thickness, target_height*bottom_vertical_percent/100])
    cube([total_length, holder_thickness, staff_width]);
}


module fence() {
    for ( i = [ 0 : 1 : number_of_staffs -1 ] ) {
        translate([i * section_width, 0, 0])
        staff();
    }
    holder();
}


fence();