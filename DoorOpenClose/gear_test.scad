// Gear Test by GregFrost
// It is licensed under the Creative Commons - GNU GPL license.
// © 2010 by GregFrost

include <gear.scad>

teeth1=13;
teeth2=7;
teeth3=17;
teeth4=47;
circular_pitch=10;

rad1=pitch_radius(num_teeth=teeth1,circular_pitch=circular_pitch);
rad2=pitch_radius(num_teeth=teeth2,circular_pitch=circular_pitch);
rad3=pitch_radius(num_teeth=teeth3,circular_pitch=circular_pitch);
rad4=pitch_radius(num_teeth=teeth4,circular_pitch=circular_pitch);

linear_extrude(height=8)
gear(num_teeth=teeth1,circular_pitch=circular_pitch);

translate([rad1+rad2,0])
linear_extrude(height=8)
gear(num_teeth=teeth2,circular_pitch=circular_pitch);

translate([rad1+2*rad2+rad3,0])
linear_extrude(height=8)
gear(num_teeth=teeth3,circular_pitch=circular_pitch);

translate([rad1+2*rad2+2*rad3,-circular_pitch*3.5])
linear_extrude(height=8)
rotate(90)
rack(num_teeth=7,circular_pitch=circular_pitch);

translate([rad4-rad1,0,0])
linear_extrude(height=8)
difference()
{
    circle(r=rad4+circular_pitch,$fn=teeth4*5);
    gear(num_teeth=teeth4,circular_pitch=circular_pitch,backlash=-0.5,clearance=-0.5);
}