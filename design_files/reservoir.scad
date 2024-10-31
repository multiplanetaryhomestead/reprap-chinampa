// design parameters
include <design-params.scad>

t_wall_clearance = 2*d_nozzle;

h_reservoir = z_limit*scale_factor;
d_o = d_buoy+2*t_wall+2*t_wall_clearance;
d_i = d_buoy+2*t_wall_clearance;

difference()
{
    cylinder(r=d_o/2, h=h_reservoir, $fn=6);
    translate([0, 0, t_wall])
    cylinder(r=d_i/2, h=h_reservoir, $fn=6);
}
