// printer parameters
include <printer-params.scad>

// design parameters
scale_factor = 1.0;

t_wall = d_nozzle;
perimeter_buffer = 10;
d_planter = (2*y_limit/sqrt(3) - perimeter_buffer)*scale_factor;
h_layer = 0.3;
h_bottom_shell = 3*h_layer;
