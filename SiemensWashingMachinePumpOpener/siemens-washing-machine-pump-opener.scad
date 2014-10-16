// Make a small "key" to open the pump system for a siemens washing machine.

module key() {
       
       
       translate([0,11,0]) cube([25,52,14], center = true);
       translate([12.5,0,0]) cylinder( h = 14, r = 15, center = true );
       translate([-12.5,0,0]) cylinder( h = 14, r = 15, center = true );

}

module cut() {
       translate([0,30,0]) cube([30,30,8], center = true);

}

difference() {
           key();
           cut();
}