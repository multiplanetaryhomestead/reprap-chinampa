// printer parameters
include <printer-params.scad>

// design parameters
scale_factor = 1.0;

t_wall = d_nozzle;
perimeter_buffer = 10;
d_planter = (2*y_limit/sqrt(3) - perimeter_buffer)*scale_factor;

d_wicking_chamber = 50.8*scale_factor;
h_wicking_chamber = 40*scale_factor;

overhang_angle = 45;
h_conical_cavity = tan(overhang_angle)*(d_planter/2-2*t_wall-d_wicking_chamber/2);
d_planter_cavity = 2*(d_planter/2.5-2*t_wall);
