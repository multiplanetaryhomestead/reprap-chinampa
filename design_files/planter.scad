// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_wicking_plate = d_buoy_cavity-2*t_wall_clearance;
d_water_injection_port_cavity_wicking_plate = d_water_injection_port_buoy;
h_planter = z_limit*scale_factor;
d_drainpipe = 4*d_nozzle;

d_water_injection_port_cavity_planter = d_water_injection_port_buoy;

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
        translate([d_buoy/2-sqrt(3)*d_water_injection_port_cavity_planter/4, 0, 0])
        water_injection_port(r_o=d_water_injection_port_planter/2+t_wall, r_i=d_water_injection_port_cavity_planter/2+t_wall, h=h_buoy);
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
        translate([d_buoy/2-sqrt(3)*d_water_injection_port_cavity_planter/4, 0, 0])
        water_injection_port_cavity(d_water_injection_port_cavity_planter/2+t_wall);
    }

    // hexagonal cavity
    translate([0, 0, 0])
    cylinder(r=d_planter_cavity/2, h=h_planter);

    // hexagonal cavity for drainpipe
    cylinder(r=d_drainpipe/2, h=h_bottom_shell);
}

// baseplate
difference() {
    // base
    cylinder(r=d_wicking_plate/2, h=h_bottom_shell);

    // drain mesh
    n_bottom_shell = h_bottom_shell/h_layer;
    for (i = [0:1:n_bottom_shell-1]) {
        translate([0, 0, i*h_layer])
        rotate([0, 0, i*60])
        rectilinear_grid_generator(r=d_planter/2, w=d_nozzle, h=h_layer, n=6);
    }
    //honeycomb_generator(n=15, r_hex=d_drain_hole/2, r_dist=r_drain_hole_dist, h=h_bottom_shell);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([d_buoy/2-sqrt(3)*d_water_injection_port_cavity_planter/4, 0, 0])
        water_injection_port_cavity(d_water_injection_port_cavity_wicking_plate/2+t_wall);
    }

    // wicking chamber cavity (short section)
    cylinder(r=d_wicking_chamber_short_base/2-t_wall, h=h_bottom_shell, $fn=6.1);
}

// wicking chamber lip
difference () {
    cylinder(r=d_wicking_chamber_short_base/2, h=h_bottom_shell, $fn=6.1);

// wicking chamber cavity (short section)
    cylinder(r=d_wicking_chamber_short_base/2-t_wall, h=h_bottom_shell, $fn=6.1);
}