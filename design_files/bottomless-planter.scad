// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_wicking_plate = d_buoy_cavity-2*t_wall_clearance;
d_water_injection_port_cavity_wicking_plate = d_water_injection_port_buoy;
h_planter = z_limit*scale_factor;
d_drainpipe = 4*d_nozzle;

d_water_injection_port_cavity_planter = d_water_injection_port_buoy;

d_water_injection_port_planter = d_water_injection_port_cavity_planter+2*t_wall;

d_interface_rim = d_planter_cavity - d_water_injection_port_buoy*sqrt(3)/2 - (d_water_injection_port_cavity_buoy/2)*sin(30)/sin(75) - 2*t_wall;

// Hidden variables:
$fn=6;

// water injection port walls
difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port(r_o=d_water_injection_port_planter/2+t_wall, r_i=d_water_injection_port_cavity_planter/2+t_wall, h=h_buoy);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_planter, r_i=d_planter/2, h=z_limit);
}

// planter walls
difference() {
    cylinder(r=d_planter/2, h=h_planter);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_planter/2+t_wall, h=z_limit);
    }

    // hexagonal cavity
    translate([0, 0, 0])
    cylinder(r=d_planter_cavity/2, h=h_planter);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_bottom_shell);
}

// planter brim
difference() {
    cylinder(r=d_planter/2, h=h_bottom_shell);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_planter/2+t_wall, h=z_limit);
    }

    // hexagonal cavity
    translate([0, 0, 0])
    cylinder(r=d_planter_cavity/2-sqrt(3)*d_drain_hole/2, h=h_planter);
}

// water injection port brim
difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port(r_o=d_water_injection_port_planter/2+d_drain_hole, r_i=d_water_injection_port_cavity_planter/2+t_wall, h=h_bottom_shell);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_planter, r_i=d_planter/2, h=z_limit);
}


// drain mesh
difference() {
    // drain mesh
    //isometric_grid_generator(r=d_planter/2, w=d_nozzle, h_layer=h_layer, h_bottom_shell=h_bottom_shell, d_hole=1.5*d_nozzle);
    cylinder(h=h_bottom_shell, r=d_planter/2);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_planter/2+t_wall, h=z_limit);
    }

    // drain mesh interface
    cylinder(r=d_interface_rim/2 - 8*t_wall, h=2*h_bottom_shell, $fn=96);
}
