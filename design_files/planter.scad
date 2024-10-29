// design parameters
include <design-params.scad>
include <helper-functions.scad>

t_wall_clearance = 0.1;

h_planter = z_limit*scale_factor;
d_drainpipe = 4*d_nozzle;

t_vert_wall = h_planter-h_conical_cavity-h_wicking_chamber;

// Hidden variables:
$fn=6;

difference() {
    cylinder(r=d_planter/2, h=h_planter);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_wicking_chamber+h_bottom_shell])
    cylinder(h=t_vert_wall, r=d_planter_cavity/2);

    // conical cavity
    translate([0, 0, h_wicking_chamber+h_bottom_shell])
    cylinder(r1=d_wicking_chamber/2, r2=d_planter_cavity/2, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_bottom_shell])
    cylinder(r=d_wicking_chamber/2, h=h_wicking_chamber);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_bottom_shell);

    // drain mesh
    for ( i = [0:1:3])
    make_bottom_holes(0.06+i*.11, .12+i*.11, 6*(i+1), d_wicking_chamber);

    // keyhole for vasemode printing
    translate([-t_wall_clearance/2, -d_planter/2, 0])
    cube([t_wall_clearance, d_planter/2, h_planter]);

    // water injection port
    translate([0, -d_drainpipe-d_planter/2, 0])
    rotate([0, 0, 45])
    cube([d_planter/9, d_planter/9, h_planter]);
}
