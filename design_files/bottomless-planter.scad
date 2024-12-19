// design parameters
include <design-params.scad>
include <helper-functions.scad>

h_planter = z_limit*scale_factor;
d_drainpipe = 4*d_nozzle;

d_water_injection_port_cavity_planter = d_water_injection_port_buoy+2*t_wall_clearance;

d_water_injection_port_planter = d_water_injection_port_cavity_planter+2*t_wall;

// Hidden variables:
$fn=6;

// shell used to remove protruding water injection port walls
module invisible_shell() {
    difference() {
        cylinder(r=d_buoy/2+2*t_wall, h=h_planter);

        // hexagonal cavity
        cylinder(r=d_planter/2, h=h_planter);
    }
}

difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
        water_injection_port(r_o=d_water_injection_port_planter/2, r_i=d_water_injection_port_cavity_planter/2, h=h_buoy);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(d_water_injection_port_planter);
}

// planter
difference() {
    cylinder(r=d_planter/2, h=h_planter);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
        water_injection_port_cavity(d_water_injection_port_cavity_planter/2);
    }

    // hexagonal cavity
    translate([0, 0, 0])
    cylinder(r=d_planter_cavity/2, h=h_planter);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_bottom_shell);
}
