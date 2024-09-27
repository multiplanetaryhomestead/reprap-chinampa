// printer parameters
include <printer-params.scad>

// design parameters
scale_factor = 0.2;

t_wall = d_nozzle;
perimeter_buffer = 10;
d_planter = (2*y_limit/sqrt(3) - perimeter_buffer)*scale_factor;
