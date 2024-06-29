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

//h_wicking_chamber = 55*scale_factor;
d_wicking_chamber = 50.8;
d_drainpipe = d_wicking_chamber*scale_factor;
overhang_angle = 60;

// Hidden variables:
$fn=120;

module conical_cavity() {
    translate([0, 0, -tan(overhang_angle)*(d_raft/2-t_wall-d_drainpipe/2)])
    // cone
    cylinder(r1=d_drainpipe/2, r2=d_raft/2-2*t_wall, h=tan(overhang_angle)*(d_raft/2-t_wall-d_drainpipe/2));

}

module donut() {
    difference() {
        cylinder(r=d_raft/2, h=h_raft);
        cylinder(r=d_drainpipe/2, h=h_raft);
    }
}

difference() {
    donut();
    
    // conical cavity
    translate([0, 0, h_raft-t_vert_wall])
    conical_cavity();

    // cylinder
    translate([0, 0, h_raft-t_vert_wall])
    cylinder(h=t_vert_wall, r=d_raft/2-2*t_wall);

    // keyhole for vasemode printing
    translate([-t_wall_clearance/2, -d_raft/2, 0])
    cube([t_wall_clearance, d_raft/2, h_raft]);
}
