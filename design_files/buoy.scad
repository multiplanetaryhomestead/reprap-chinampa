// design parameters
include <design-params.scad>
include <helper-functions.scad>

t_vert_wall = h_buoy-h_conical_cavity-h_drain_pipe;

// Hidden variables:
$fn=6;

// water injection port walls
difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port(r_o=d_water_injection_port_buoy/2, r_i=d_water_injection_port_cavity_buoy/2, h=h_buoy);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_buoy, r_i=d_buoy/2, h=z_limit);

    // keyhole for vasemode printing
    keyhole();
}

// buoy
difference() {
    cylinder(r=d_buoy/2, h=h_buoy);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=z_limit);
    }

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_drain_pipe+h_bottom_shell])
    cylinder(r=d_buoy_cavity/2, h=t_vert_wall);

    // conical cavity
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    cylinder(r1=d_drain_pipe/2, r2=d_buoy_cavity/2, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_bottom_shell])
    cylinder(r=d_drain_pipe/2, h=h_drain_pipe);

    // hexagonal cavity for drainage
    cylinder(r=d_drain_pipe/2, h=h_bottom_shell);

    // keyhole for vasemode printing
    keyhole();
}
