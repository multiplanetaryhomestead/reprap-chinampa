// design parameters
include <design-params.scad>
use <helper-functions.scad>

t_wall_clearance = 2*d_nozzle;

h_reservoir = z_limit*scale_factor;
d_o = d_buoy+2*t_wall+2*t_wall_clearance;
d_i = d_buoy+2*t_wall_clearance;

// Hidden variables:
$fn = 6;
res_cyl = 24;
res_fil = 96;

difference()
{
    cylinder(r=d_o/2, h=h_reservoir, $fn=res_cyl);
    // circular filleted cutout of outer bottom
    circular_outer_bottom_fillet(r_cyl=d_o/2, r_fil=r_fillet, h_bottom_offset=h_bottom_fillet_offset, res=res_fil);
}
