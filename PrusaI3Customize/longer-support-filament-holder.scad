// Longer support thingy for filament holder, Prusa I3 Hephestos

// Like it round, as it needs to rotate.
$fn = 50;
difference() {
  cylinder( h = 100, r = 12 );
  cylinder( h = 100, r = 10.25 );
}
