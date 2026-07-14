// Classic UFO (flying saucer) — 3D-printable
// Prints flat-bottom-down, no supports needed at default settings.

$fn = 120;

// ---- Parameters ----
saucer_d      = 80;   // overall saucer diameter (mm)
saucer_h      = 18;   // total height of the saucer body
dome_d        = 32;   // cockpit dome diameter
dome_squash   = 0.75; // vertical squash of the cockpit dome
rim_bump_d    = 5;    // diameter of the "lights" around the rim
rim_bump_n    = 0;   // number of rim lights
flat_cut      = 2;    // how much to slice off the bottom (print bed contact)

// ---- Model ----
module saucer_body() {
    // lens shape: two squashed half-spheres joined at the rim
    scale([1, 1, saucer_h / saucer_d])
        sphere(d = saucer_d);
}

module cockpit() {
    translate([0, 0, saucer_h * 0.30])
        scale([1, 1, dome_squash])
            sphere(d = dome_d);
}

module rim_lights() {
    r = saucer_d * 0.35;
    // z of the saucer's top surface at radius r, so lights sit proud of the hull
    z = (saucer_h / 2) * sqrt(1 - pow(r / (saucer_d / 2), 2));
    for (i = [0 : rim_bump_n - 1])
        rotate([0, 0, i * 360 / rim_bump_n])
            translate([r, 0, z])
                sphere(d = rim_bump_d);
}

module ufo() {
    difference() {
        union() {
            saucer_body();
            cockpit();
            rim_lights();
        }
        // slice the bottom flat so it sits on the print bed
        translate([0, 0, -saucer_d / 2 - saucer_h / 2 + flat_cut])
            cube(saucer_d, center = true);
    }
}

// lift so the flat bottom sits at z = 0
translate([0, 0, saucer_h / 2 - flat_cut])
    ufo();
