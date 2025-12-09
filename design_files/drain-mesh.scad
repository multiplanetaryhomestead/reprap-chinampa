
// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_o_rim = d_planter_cavity - d_water_injection_port_buoy*sqrt(3)/2 - (d_water_injection_port_cavity_buoy/2)*sin(30)/sin(75) - 4*t_wall;
d_i_rim = d_o_rim - 8*t_wall;

d_i_wicking_chamber_interface = d_wicking_chamber_short_base - 2*t_wall;
d_o_wicking_chamber_interface = d_i_wicking_chamber_interface + 4*t_wall;
t_tolerance = 0.2;

// wicking chamber interface
module donut(r_o, r_i) {
    difference () {
        cylinder(r=r_o, h=h_bottom_shell, $fn=96);

    // wicking chamber cavity (short section)
        cylinder(r=r_i, h=h_bottom_shell, $fn=96);
    }
}

// drain mesh
difference() {
    // drain mesh
    isometric_grid_generator(r=d_o_rim/2, w=d_nozzle+t_tolerance, h_layer=h_layer, h_bottom_shell=h_bottom_shell, n=96, d_hole=1.5*d_nozzle);

    // wicking chamber cavity (short section)
    cylinder(r=d_wicking_chamber_short_base/2, h=2*h_bottom_shell, $fn=96);
}

// mesh rim
donut(r_o=d_o_rim/2, r_i=d_i_rim/2);

// wicking chamber interface
donut(r_o=d_o_wicking_chamber_interface/2, r_i=d_i_wicking_chamber_interface/2);
