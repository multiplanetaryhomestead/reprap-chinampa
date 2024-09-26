// printer parameters
d_nozzle = 0.8;
h_layer = 0.6;
z_limit = 210;
// TODO: needs to be refactored to use include statement https://github.com/openscad/openscad/issues/605#issuecomment-32962394

// design parameters
scale_factor = 0.2;
d_i = 200;
h_reservoir = 210;
wall_thickness = 2*d_nozzle;
t_wall_clearance = 0.1;

difference()
{
    cylinder(r=d_i/2*scale_factor+wall_thickness+t_wall_clearance, h=h_reservoir*scale_factor, $fn=6);
    translate([0, 0, wall_thickness])
    cylinder(r=d_i/2*scale_factor+t_wall_clearance, h=h_reservoir*scale_factor, $fn=6);
}
