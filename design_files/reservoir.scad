// design parameters
include <design-params.scad>
use <helper-functions.scad>

t_wall_clearance = 2*d_nozzle;

h_reservoir = z_limit*scale_factor;
d_o = d_buoy+2*t_wall+2*t_wall_clearance;
d_i = d_buoy+2*t_wall_clearance;

// Hidden variables:
res_cyl = 24;
res_fil = 96;
$fn = res_fil;

translate([0, 0, -h_bottom_fillet_offset])
difference() {
    bottomFillet(b=0, r=r_fillet, s=400)
    linear_extrude(h_reservoir+h_bottom_fillet_offset)
    rounding2d(r_fillet)
    hexagon2d(r=d_o/2);

    // remove layers that would otherwise print steep overhangs due to fillet
    linear_extrude(h_bottom_fillet_offset)
    hexagon2d(r=d_o/2);
}
