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

translate([0, 0, -h_bottom_fillet_offset])
difference() {
    bottomFillet(b=0, r=r_fillet, s=200)
    cylinder(r=d_o/2, h=h_reservoir+h_bottom_fillet_offset);

    // remove layers that would otherwise print steep overhangs due to fillet
    cylinder(h=h_bottom_fillet_offset, r=d_o/2);
}
