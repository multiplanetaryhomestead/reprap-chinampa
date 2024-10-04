// design parameters
include <design-params.scad>

t_wall_clearance = 0.1;

h_planter = z_limit*scale_factor;
d_wicking_chamber = 50.8*scale_factor;
h_wicking_chamber = 25*scale_factor;
d_drainpipe = 4*d_nozzle;

overhang_angle = 45;
h_conical_cavity = tan(overhang_angle)*(d_planter/2-2*t_wall-d_wicking_chamber/2);

h_conical_drainpipe = tan(overhang_angle)*d_wicking_chamber/2;
h_drainpipe = h_bottom_shell;
t_vert_wall = h_planter-h_conical_cavity-h_wicking_chamber-h_conical_drainpipe;

// Hidden variables:
$fn=6;

difference() {
    cylinder(r=d_planter/2, h=h_planter);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_wicking_chamber+h_conical_drainpipe+h_drainpipe])
    cylinder(h=t_vert_wall, r=d_planter/2.5-2*t_wall);

    // conical cavity
    translate([0, 0, h_wicking_chamber+h_conical_drainpipe+h_drainpipe])
    cylinder(r1=d_wicking_chamber/2, r2=d_planter/2.5-2*t_wall, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_conical_drainpipe+h_drainpipe])
    cylinder(r=d_wicking_chamber/2, h=h_wicking_chamber);

    // hexagonal cavity for conical drainpipe
    translate([0, 0, h_drainpipe])
    cylinder(r2=d_wicking_chamber/2, r1=d_drainpipe/2, h=h_conical_drainpipe);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_conical_drainpipe+h_drainpipe);

    // keyhole for vasemode printing
    translate([-t_wall_clearance/2, -d_planter/2, 0])
    cube([t_wall_clearance, d_planter/2, h_planter]);

    // water injection port
    translate([0, -d_drainpipe-d_planter/2, 0])
    rotate([0, 0, 45])
    cube([d_planter/9, d_planter/9, h_planter]);
}
