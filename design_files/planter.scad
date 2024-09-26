// printer parameters
d_nozzle = 0.8;
h_layer = 0.6;

// TODO: needs to be refactored to use include statement https://github.com/openscad/openscad/issues/605#issuecomment-32962394

// design parameters
scale_factor = 0.2;

d_raft = 200*scale_factor;
h_raft = 200*scale_factor;

t_wall = d_nozzle;
t_wall_clearance = d_nozzle;
t_vert_wall = 4*h_layer;

h_wicking_chamber = 55*scale_factor;
d_wicking_chamber = 50.8;
d_drainpipe = d_wicking_chamber*scale_factor;
overhang_angle = 45;
h_conical_cavity = tan(overhang_angle)*(d_raft/2-2*t_wall-d_drainpipe/2);

// Hidden variables:
$fn=6;

difference() {
    cylinder(r=d_raft/2, h=h_raft);
    // top hexagonal cavity
    translate([0, 0, h_raft-t_vert_wall])
    cylinder(h=t_vert_wall, r=d_raft/2.5-2*t_wall);

    // conical cavity
    translate([0, 0, h_raft-t_vert_wall-h_conical_cavity])
    cylinder(r1=d_drainpipe/2, r2=d_raft/2.5-2*t_wall, h=h_conical_cavity);

    // cavity for wicking wicking medium (e.g., peat moss)
    translate([0, 0, h_raft-t_vert_wall-h_conical_cavity-h_wicking_chamber])
    cylinder(r=d_drainpipe/2, h=h_wicking_chamber);

    // hexagonal cavity for conical drainpipe
    h_conical_drainpipe = tan(overhang_angle)*d_drainpipe/2;
    h_drainpipe = h_raft-t_vert_wall-h_conical_cavity-h_wicking_chamber-h_conical_drainpipe;
    translate([0, 0, h_drainpipe])
    cylinder(r2=d_drainpipe/2, r1=t_wall_clearance, h=h_conical_drainpipe);

    // hexagonal cavity for drainpipe
    cylinder(r=t_wall_clearance, h=h_drainpipe);

    // keyhole for vasemode printing
    translate([-t_wall_clearance/2, -d_raft/2, 0])
    cube([t_wall_clearance, d_raft/2, h_raft]);
}
