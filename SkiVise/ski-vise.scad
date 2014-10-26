// Ski vise


// The vise is basically very simple, and is a cube that is hollowed out.
// These are the basic dimensions for this cube
vise_height = 180;
vise_width = 40;
// This should/could be adjusted to accommodate wider skis
// 140 is very wide. You should probably not go lower than 80
vise_depth = 140;

// We need a cutout to allow for a clamp, for clamping to a table.
// This should match the clamp available for you
// Offset from the table you mount to
clamp_offset = 20;
clamp_height = 20;
clamp_width = 30;
clamp_depth = 60; // This could be a percent?





// This is for the slot to place the ski, when 


// This is to avoid breaking the manifold
pad = 0.1;


module base() {
    // Place centered in x,y
    translate( [0,0,vise_height / 2.0]) cube([vise_width, vise_depth, vise_height], center = true);
}

module clamp_hollower() {
    // Translate to match front of main/base, and offset
    translate( [0, -vise_depth/2.0 + clamp_depth / 2.0 - pad, clamp_offset + clamp_height / 2.0] ) cube([clamp_width, clamp_depth+pad, clamp_height], center = true);
    
}
    
// For now, main.
difference() {
    base();
    # clamp_hollower();
}
    