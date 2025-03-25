// design parameters
include <design-params.scad>
include <helper-functions.scad>

t_vert_wall = h_buoy-h_conical_cavity-h_drain_pipe;

// Hidden variables:
$fn=6;

module base_chamfer() {
    r_base_chamfer1 = d_buoy/2;
    r_base_chamfer2 = sqrt(3)*d_buoy/4 - sqrt(3)*d_water_injection_port_buoy/8 - 2*t_wall;
    h_base_chamfer = r_base_chamfer1 - r_base_chamfer2;
    difference() {
        cylinder(h=h_base_chamfer, r=r_base_chamfer1, $fn=96);
        cylinder(h=h_base_chamfer, r1=r_base_chamfer2, r2=r_base_chamfer1, $fn=96);
    }
}

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

    // base chamfer for mitigating cracking
    base_chamfer();

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

    // conical cavity for wicking plate
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    cylinder(r1=d_drain_pipe/2, r2=d_buoy_cavity/2, h=h_conical_cavity);

    // cavity for drain pipe
    translate([0, 0, h_bottom_shell])
    cylinder(r=d_drain_pipe/2, h=h_buoy, $fn=96);

    // conical cavity for mitigating cracking along bottom of drain pipe
    translate([0, 0, 0])
    cylinder(r1=d_drain_pipe, r2=0, h=d_drain_pipe*cos(45), $fn=96);

    // base chamfer for mitigating cracking
    base_chamfer();

    // keyhole for vasemode printing
    keyhole();
}
