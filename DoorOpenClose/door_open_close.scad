
include <parametric_involute_gear_v5.0.scad>
include <MCAD/shapes.scad>

// From: https://www.thingiverse.com/thing:3575

$fn=50;

// Example
//==================================================
// Bevel Gears:
// Two gears with the same cone distance, circular pitch (measured at the cone distance) 
// and pressure angle will mesh

// Gear measurements.

gear1_teeth = 10;
gear2_teeth = 10;
axis_angle = 90;
// outside_circular_pitch vs estimated total radius
// Target radius 16-17 mm
// 350 ~ 12.5 mm
// 470 ~ 16.5
// My formula: outside_circular_pitch = ( target_radius * 360 ) / ( gear_teeth * Fudge )
// Where F = 1.28571428571428571428
// This is for the current values of thickness, face width, etc.

outside_circular_pitch=470;

gear_thickness = 5;
face_width = 5;
bore_diameter = 2.3 + 0.8;
backlash = 1;

// NB: Whenever a parameter is changed, you need to update this variable (calculated by the method). Yes, this sucks.
back_cone_descent = 6.98776;



// Calculated
outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
echo(str("outside_pitch_radius1 = ", outside_pitch_radius1));
echo(str("outside_pitch_radius2 = ", outside_pitch_radius2));
pitch_apex1 = outside_pitch_radius2 * sin (axis_angle)
             + (outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
echo(str("pitch_apex1           = ", pitch_apex1));
echo(str("pitch_apex2           = ", pitch_apex1));
echo(str("cone_distance         = ", cone_distance));
pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
echo(str("pitch_angle1          = ", pitch_angle1));
echo(str("pitch_angle2          = ", pitch_angle2));
echo(str("pitch_angle1 + pitch_angle2 = ", pitch_angle1 + pitch_angle2));

//////////////////////////////////////////////////////////////////////
// Gears. Motor gear and drive gear
// Bottom of bevel gear at z = 0

// gear 1
module motor_gear() {
    // translate ([0,0,pitch_apex1+7]) // 7 is a manual fudge factor.
    rotate([0,0,18]) // Rotate to mesh teeth with other gear.
    // translate([0,0,-pitch_apex1])
    bevel_gear (
        number_of_teeth=gear1_teeth,
        cone_distance=cone_distance,
        pressure_angle=25,
        outside_circular_pitch=outside_circular_pitch,
        gear_thickness = gear_thickness,
        face_width = face_width,
        bore_diameter = 0, // This one get a hexagon axle
        finish=bevel_gear_back_cone,
        backlash=backlash
    );
    // Add heaxgon axle.
    // 6 is the distance between two faces
    // 12 is the height of the motor thingy.
    translate([0,0,-5.99])
    hexagon(6, 12);
}

// gear 2
module drive_gear() {
    // rotate([0,-(pitch_angle1+pitch_angle2),0]) // Rotate up from Z plane, I think
    // translate([0,0,-pitch_apex2])
    bevel_gear (
        number_of_teeth=gear2_teeth,
        cone_distance=cone_distance,
        pressure_angle=25,
        outside_circular_pitch=outside_circular_pitch,
        gear_thickness = gear_thickness,
        face_width = face_width,
        bore_diameter = bore_diameter,
        finish=bevel_gear_back_cone,
        backlash=backlash
    );
}


module bevel_gears() {
    // rotate([0,0,90])
    translate ([0,0,pitch_apex1+7]) // 7 is a manual fudge factor.
    {
        rotate([0,0,18]) // Rotate to mesh teeth, I hope
        translate([0,0,-pitch_apex1])
        bevel_gear (
            number_of_teeth=gear1_teeth,
            cone_distance=cone_distance,
            pressure_angle=25,
            outside_circular_pitch=outside_circular_pitch,
            gear_thickness = gear_thickness,
            face_width = face_width,
            bore_diameter = 0, // This one get a hexagon axle
            finish=bevel_gear_back_cone,
            backlash=backlash
        );
        
        // rotate([18,0,0]) // Rotate to mesh teeth, I hope
        rotate([0,-(pitch_angle1+pitch_angle2),0]) // Rotate up from Z plane, I think
        translate([0,0,-pitch_apex2])
        bevel_gear (
            number_of_teeth=gear2_teeth,
            cone_distance=cone_distance,
            pressure_angle=25,
            outside_circular_pitch=outside_circular_pitch,
            gear_thickness = gear_thickness,
            face_width = face_width,
            bore_diameter = bore_diameter,
            finish=bevel_gear_back_cone,
            backlash=backlash
        );
    }

}


