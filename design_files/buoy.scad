// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_drainpipe = 4*d_nozzle;

t_vert_wall = h_buoy-h_conical_cavity-h_wicking_chamber;

// Hidden variables:
$fn=6;

difference() {
    // water injection port walls
    translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
    water_injection_port(r_o=d_water_injection_port_buoy/2, r_i=d_water_injection_port_cavity_buoy/2, h=h_buoy);

    // keyhole for vasemode printing
    keyhole();
}

// buoy
difference() {
    cylinder(r=d_buoy/2, h=h_buoy);

    // water injection port cavity
    translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
    water_injection_port_cavity(d_water_injection_port_cavity_buoy/2);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_wicking_chamber+h_bottom_shell])
    cylinder(r=d_buoy_cavity/2, h=t_vert_wall);

    // conical cavity
    translate([0, 0, h_wicking_chamber+h_bottom_shell])
    cylinder(r1=d_wicking_chamber/2, r2=d_buoy_cavity/2, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_bottom_shell])
    cylinder(r=d_wicking_chamber/2, h=h_wicking_chamber);

    // hexagonal cavity for drainage
    cylinder(r=d_wicking_chamber/2, h=h_bottom_shell);

    // keyhole for vasemode printing
    keyhole();
}

// drain mesh
difference() {
    cylinder(r=d_wicking_chamber/2, h=h_bottom_shell);

    // drain mesh holes
    r_hole=3*d_nozzle/2;
    rotate([0, 0, 90])
    honeycomb_generator(n=3, r_hex=d_drain_hole/2, r_dist=r_drain_hole_dist, h=h_bottom_shell);

}
