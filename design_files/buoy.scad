// design parameters
include <design-params.scad>
use <helper-functions.scad>

t_vert_wall = h_buoy-h_conical_cavity-h_drain_pipe;

// Hidden variables:
$fn=6;

// keyhole for vasemode printing
module keyhole() {
    t_wall_clearance = 0.1;
    translate([0, -t_wall_clearance/2, 0])
    cube([y_limit/2, t_wall_clearance, z_limit]);
}

// water injection port walls
translate([0, 0, r_fillet+h_bottom_fillet_offset])
difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port(r_o=d_water_injection_port_buoy/2, r_i=d_water_injection_port_cavity_buoy/2, h=h_buoy-r_fillet);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_buoy, r_i=d_buoy/2, h=z_limit);

    // keyhole for vasemode printing
    keyhole();
}

// buoy
difference() {
    // bottom fillet for mitigating cracking
    bottomFillet(b=0, r=r_fillet, s=200)
    difference() {
        cylinder(r=d_buoy/2, h=h_buoy+h_bottom_fillet_offset);

        // top hexagonal cavity
        translate([0, 0, h_conical_cavity+h_drain_pipe+h_bottom_shell+h_bottom_fillet_offset])
        cylinder(r=d_buoy_cavity/2, h=t_vert_wall);

        // conical cavity for wicking plate
        translate([0, 0, h_drain_pipe+h_bottom_shell+h_bottom_fillet_offset])
        cylinder(r1=d_drain_pipe/2, r2=d_buoy_cavity/2, h=h_conical_cavity);

        // cavity for drain pipe
        cylinder(r=d_drain_pipe/2, h=h_buoy, $fn=96);

        // keyhole for vasemode printing
        keyhole();

        // remove bottom layers to avoid printing initial overhangs in mid-air from fillet
        cylinder(h=h_bottom_fillet_offset, r=d_buoy/2);
    }

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=z_limit+h_bottom_shell+h_bottom_fillet_offset);
    }
}
