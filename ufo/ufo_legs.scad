// Classic UFO (flying saucer) with tripod landing legs — 3D-printable
// Prints feet-down; the legs themselves splay ~35 degrees and print fine,
// but the hull's flat underside hangs in mid-air — enable supports when slicing.

$fn = 120;

// ---- Parameters ----
saucer_d      = 80;   // overall saucer diameter (mm)
saucer_h      = 18;   // total height of the saucer body
dome_d        = 32;   // cockpit dome diameter
dome_squash   = 0.75; // vertical squash of the cockpit dome
rim_bump_d    = 5;    // diameter of the "lights" around the rim
rim_bump_n    = 0;   // number of rim lights
flat_cut      = 2;    // how much to slice off the bottom of the hull

leg_n         = 3;    // tripod
leg_d         = 6;    // leg thickness
leg_h         = 18;   // ground clearance under the hull's flat bottom
leg_attach_r  = 20;   // radius where legs meet the hull
leg_foot_r    = 34;   // radius of the feet on the ground
foot_pad_d    = 12;   // foot pad diameter
foot_pad_h    = 3;    // foot pad height

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
        // slice the bottom flat
        translate([0, 0, -saucer_d / 2 - saucer_h / 2 + flat_cut])
            cube(saucer_d, center = true);
    }
}

// z of the hull's flat bottom once the saucer is lifted onto its legs
hull_bottom = leg_h;
saucer_lift = hull_bottom + saucer_h / 2 - flat_cut;

module leg() {
    // round strut from inside the hull down to a ball above the foot pad
    hull() {
        translate([leg_attach_r, 0, hull_bottom + 3])
            sphere(d = leg_d);
        translate([leg_foot_r, 0, foot_pad_h + leg_d / 2 - 1])
            sphere(d = leg_d);
    }
    translate([leg_foot_r, 0, 0])
        cylinder(d = foot_pad_d, h = foot_pad_h);
}

module ufo_with_legs() {
    translate([0, 0, saucer_lift])
        ufo();
    for (i = [0 : leg_n - 1])
        rotate([0, 0, i * 360 / leg_n])
            leg();
}

ufo_with_legs();
