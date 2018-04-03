// Deck file for M

// Major constants

// Border is a special kind of brædder
border_height = 115 + 20;
border_width = 28 + 7;

// Substracting the border is a little bit of a cheat to make the house "fit"
deck_length = 13100 - border_width;
deck_width = 3800 - border_width; 
// If you change width, you need to recalculate the number of braedder
braedder_rows = 31;
// And, possibly also this
spaer_rows = 3;
spaer_distance = 1200;
// And, this will also depends, etc.
// It is the number of stroer pr. braedde, but all will be sharing two stroer, so it is really one more for each braedde.
stroer_per_braedde = 6;

// The "house" is present on the drawing. Sort of. Its a block, where the "deck" is cut out from.
house_length = 15000;
house_width = 3000;
house_cut_width = 2000;
house_cut_length = deck_length;
house_height = 2800;
house_negative = 300; // House goes to the ground. The deck is raised.
ground_length = house_length;
ground_width = house_width + deck_width;

// The foundation is build as two layers, with crosses
// Bottom layer is called "Spær" in Danish
// Middle layer is called "Strøer" in Danish
// Connecting to the house is called "Rem" in Danish.
// And, the top layer is called brædder
spaer_height       = 95;
spaer_width        =  95;
spaer_suppoert_min = 1500;

stroer_height      = 100;
stroer_width       = 50;

// 125 x 32 is actually 28x115
braedder_width  = 115;
braedder_height = 28;
braedder_gap    = deck_width / braedder_rows - braedder_width;
// The "pap" is used between different parts to stop water / moisture from moving
pap_thickness = 3;

// Some limitations
braedder_min_distance = 5;
braedder_max_distance = 8;
braedder_max_length = 3300;

// NOTE: MUST BE CHANGED / CALCULATED
braedder_span_number = 4;
braedder_length = deck_length / braedder_span_number;
braedder_count = braedder_span_number * braedder_rows;

braedder_length_gap = 2; // This is for visual feedback only.
stroer_distance = braedder_length / stroer_per_braedde;
stroer_length = deck_width-stroer_width-pap_thickness;
// Must add one in the end
stroer_count = braedder_span_number * stroer_per_braedde + 1;

// Calculating lengths for borders
border_a_length = deck_width - house_cut_width + border_width;
border_b_length = deck_length + 2 * border_width;
border_c_length = deck_width + border_width;

// Lengths for spaer
spaer_length = deck_length;

module information() {
    // Spaer
    echo("Spær");
    echo(str("  Dimensioner: ", spaer_width, "x", spaer_height, "x", spaer_length, ", stk: ", spaer_rows));
    echo(str("    Afstand imellem midten af hvert spær = ", spaer_distance));

    // Rem
    echo("Rem");
    echo(str("  Dimensioner: ", stroer_width, "x", stroer_height, "x", deck_length, ", stk: ", 1)); 
    
    // Strøer
    echo("Strøer");
    echo(str("  Dimensioner: ", stroer_width, "x", stroer_height, "x", stroer_length, ", stk: ", stroer_count)); 
    echo(str("    Antal strøer pr. bræt = ", stroer_per_braedde));
    echo(str("    Afstand imellem midten af hver strø = ", stroer_distance));

    echo("Dæk");
    echo(str("  Dimensioner: ", braedder_width, "x", braedder_height, "x", braedder_length, ", stk: ", braedder_count)); 
    echo(str("    Mellemrum imellem brædder = ", braedder_gap));

    echo("Afslutning");
    echo(str("  Dimensioner: ", border_width, "x", border_height, "x", border_a_length, ", stk: ", 1)); 
    echo(str("  Dimensioner: ", border_width, "x", border_height, "x", border_b_length, ", stk: ", 1)); 
    echo(str("  Dimensioner: ", border_width, "x", border_height, "x", border_c_length, ", stk: ", 1)); 
   
    
}


gap = 0.5;

// Note: 0,0 is bottom left corner of the deck. Also the house.

// First the house
module house() {
    difference() {
        // House block
        color([1,1,1])
        translate([-(house_length-deck_length-border_width),-(house_width-house_cut_width), -house_negative])
        cube([house_length, house_width, house_height]);

        // Cutout for the deck
        translate([0,0,-house_height/2])
        cube([deck_length+2*gap+border_width, deck_width+border_width+gap, 2*house_height + 2*gap]);
    }
}

module ground() {
    color([0,0.5,0])
    translate([-(house_length-deck_length-border_width),-(house_width-house_cut_width),-house_negative-5])
    cube([ground_length+1000, ground_width, 5]);
}

// Braedde is always with topside z = 0
module braedde() {
    color([0.6, 0.5, 0.2])
    translate([0,0,-braedder_height])
    cube([braedder_length, braedder_width, braedder_height]);
}

module half_braedde() {
    color([0.6, 0.5, 0.2])
    translate([0,0,-braedder_height])
    cube([braedder_length/2, braedder_width, braedder_height]);
}

// Does a lot of braedder
module deck() {
    for ( row = [0:braedder_rows - 1]) {
        // Do something different for every other row
        if ( row % 2 == 0 ) {
            difference() {
                for ( col = [0: braedder_span_number - 1]) {
                    translate([ col* braedder_length, row * (braedder_width + braedder_gap), 0]) 
                    braedde();
                }
                // Then the gaps. This sucks, sort of.
                for ( col = [0: braedder_span_number - 1]) {
                    translate([ col* braedder_length - braedder_length_gap/2, row * (braedder_width + braedder_gap) -gap, -gap]) 
                    cube([braedder_length_gap, braedder_width + 2*gap, braedder_height + 2*gap]);
                }
            }
        } else {
            difference() {
                union() {
                    translate([ 0, row * (braedder_width + braedder_gap), 0]) 
                    half_braedde();
                    for ( col = [1: braedder_span_number - 1]) {
                        translate([ col* braedder_length - braedder_length/2, row * (braedder_width + braedder_gap), 0]) 
                        braedde();
                    }
                    translate([ braedder_span_number * braedder_length - braedder_length/2, row * (braedder_width + braedder_gap), 0]) 
                    half_braedde();
                }
                // Then the gaps. This sucks, sort of.
                for ( col = [1: braedder_span_number - 1]) {
                    translate([ col* braedder_length - braedder_length_gap/2 - braedder_length/2, row * (braedder_width + braedder_gap) -gap, -gap]) 
                    cube([braedder_length_gap, braedder_width + 2*gap, braedder_height + 2*gap]);
                }
            }
        }
    }
}

// Border is outside the deck
module border() {
    // outside house cut.
    color([0.6, 0.5, 0.2])
    translate([0,house_cut_width,-border_height])
    rotate([0,0,90])
    cube([border_a_length, border_width, border_height]);
    // Very long
    color([0.6, 0.5, 0.2])
    translate([-border_width,deck_width,-border_height])
    rotate([0,0,0])
    cube([border_b_length, border_width, border_height]);
    // End.
    color([0.6, 0.5, 0.2])
    translate([deck_length+border_width,0,-border_height])
    rotate([0,0,90])
    cube([border_c_length, border_width, border_height]);
}

// Time for the strøer

// The rem is where the stroer are mounted. It is offset by the pap
module rem() {
    color([0.4, 0.3, 0.1])
    translate([0,pap_thickness,-braedder_height-stroer_height])
    cube([deck_length, stroer_width, stroer_height]);
    // TODO: Add mounts for this?
    
}

module stroe() {
    color([0.4, 0.3, 0.1])
    translate([-stroer_width/2,stroer_width+pap_thickness,-braedder_height-stroer_height])
    cube([stroer_width, stroer_length, stroer_height]);
}

module stroer() {
    // First and last are special.
    translate([stroer_width/2,0,0])
    stroe();
    for (i = [1:stroer_count - 2]) {
        translate([stroer_distance*i,0,0])
        stroe();
    }
    translate([stroer_distance*braedder_span_number*stroer_per_braedde - stroer_width/2,0,0])
    stroe();
}

module spaer() {
    color([0.2, 0.1, 0.05])
    translate([0,0,-braedder_height-stroer_height-spaer_height-pap_thickness])
    cube([spaer_length, spaer_width, spaer_height]);

}

module spaers() {
    for( i = [1:spaer_rows] ) {
        translate([0,i*spaer_distance,0])
        spaer();
    }
}


house();
// ground();
spaers();
rem();
stroer();
deck();
border();

information();
