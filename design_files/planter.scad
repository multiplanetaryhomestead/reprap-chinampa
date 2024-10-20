// design parameters
include <design-params.scad>

t_wall_clearance = 0.1;

h_planter = z_limit*scale_factor;
d_wicking_chamber = 50.8*scale_factor;
h_wicking_chamber = 40*scale_factor;
d_drainpipe = 4*d_nozzle;

overhang_angle = 45;
h_conical_cavity = tan(overhang_angle)*(d_planter/2-2*t_wall-d_wicking_chamber/2);

h_drainpipe = h_bottom_shell;
t_vert_wall = h_planter-h_conical_cavity-h_wicking_chamber;


// HELPERS (used for rendering drain mesh)
// This work builds off @leemes design for a parametric net pot. Original work can be found at https://www.thingiverse.com/thing:790339 licensed under CC-BY-SA 3.0 https://creativecommons.org/licenses/by-sa/3.0/
module cyl_sect(r1, r2, h) {
    difference() {
        cylinder(r=r1, h=h);
        translate([0,0,0])
            cylinder(r=r2, h=h);
    }
}
module connect(r, w, h, phi) {
    rotate(phi, [0,0,1])
        translate([0,-w/2,0])
            cube([r,w,h]);
}
module make_bottom_holes(begin,end,pie_segments) {
    width_connections=3;
    translate([0,0,0])
    difference() {
        cyl_sect(r1=end*d_wicking_chamber, r2=begin*d_wicking_chamber, h=h_bottom_shell);
        for (i=[0:pie_segments]) {
            connect(r=d_wicking_chamber,
                    w=width_connections,
                    h=h_bottom_shell,
                    phi=i*360/pie_segments);
        }
    }
}

// Hidden variables:
$fn=6;

difference() {
    cylinder(r=d_planter/2, h=h_planter);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_wicking_chamber+h_drainpipe])
    cylinder(h=t_vert_wall, r=d_planter/2.5-2*t_wall);

    // conical cavity
    translate([0, 0, h_wicking_chamber+h_drainpipe])
    cylinder(r1=d_wicking_chamber/2, r2=d_planter/2.5-2*t_wall, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_drainpipe])
    cylinder(r=d_wicking_chamber/2, h=h_wicking_chamber);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_drainpipe);

    // drain mesh
    make_bottom_holes(.08, .18, 12);
    make_bottom_holes(.22, .32, 24);
    make_bottom_holes(.36, .46, 32);

    // keyhole for vasemode printing
    translate([-t_wall_clearance/2, -d_planter/2, 0])
    cube([t_wall_clearance, d_planter/2, h_planter]);

    // water injection port
    translate([0, -d_drainpipe-d_planter/2, 0])
    rotate([0, 0, 45])
    cube([d_planter/9, d_planter/9, h_planter]);
}
