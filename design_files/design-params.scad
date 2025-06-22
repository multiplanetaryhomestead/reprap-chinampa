// printer parameters
include <printer-params.scad>

// design parameters
scale_factor = 1.0;

t_wall = d_nozzle;
t_wall_clearance = d_nozzle;

perimeter_buffer = 10;

d_buoy = (2*y_limit/sqrt(3) - perimeter_buffer)*scale_factor;
h_buoy = z_limit*scale_factor;

d_drain_pipe = 20;
h_drain_pipe = 140*scale_factor;

overhang_angle = 60;
d_buoy_cavity = d_buoy-4*t_wall;
h_conical_cavity = tan(90-overhang_angle)*(d_buoy_cavity/2-d_drain_pipe/2);
h_bottom_shell = 3*h_layer;

d_planter = d_buoy_cavity-2*t_wall_clearance;
d_planter_cavity = d_planter-2*t_wall;

d_water_injection_port_cavity_buoy = d_drain_pipe;
d_water_injection_port_buoy = d_water_injection_port_cavity_buoy + 4*t_wall;
x_water_injection_port = d_buoy/2-(d_water_injection_port_cavity_buoy/2)*sin(30)/sin(75);

d_drain_hole=3*d_nozzle;
r_drain_hole_dist = 3*d_drain_hole;
d_wicking_chamber_short_base = d_planter/4;

r_fillet = 2*d_water_injection_port_buoy;
h_bottom_fillet_offset = 0.25*r_fillet;
