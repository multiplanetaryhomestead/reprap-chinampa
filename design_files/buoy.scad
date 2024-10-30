// design parameters
include <design-params.scad>
include <helper-functions.scad>

h_buoy = z_limit*scale_factor;
d_drainpipe = 4*d_nozzle;

t_vert_wall = h_buoy-h_conical_cavity-h_wicking_chamber;

// Hidden variables:
$fn=6;

difference() {
    // water injection port walls
    translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
    water_injection_port(r_o=d_water_injection_port_buoy/2, r_i=d_water_injection_port_cavity_buoy/2);

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

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_bottom_shell);

    // drain mesh
    for ( i = [0:1:3])
    make_bottom_holes(0.06+i*.11, .12+i*.11, 6*(i+1), d_wicking_chamber);

    // keyhole for vasemode printing
    keyhole();
}
