// printer parameters
d_nozzle = 0.8;
h_layer = 0.6;
z_limit = 210;
// TODO: needs to be refactored to use include statement https://github.com/openscad/openscad/issues/605#issuecomment-32962394

// design parameters
scale_factor = 0.2;
tolerance = 0.5;

t_wall = d_nozzle;
d_raft = 200*scale_factor;
d_funnel = d_raft-4*t_wall;

t_wall_clearance = t_wall;

overhang_extent=4*t_wall;
overhang_angle = 70;

h_wicking_chamber = 55*scale_factor;
d_wicking_chamber = 50.8;
d_drainpipe = d_wicking_chamber*scale_factor;

h_cone=tan(overhang_angle)*(d_funnel/2-d_drainpipe/2);

t_top = 6*h_layer;
t_bottom = z_limit*scale_factor-h_cone-t_top;

// Hidden variables:
$fn=120;

module chamfer() {
    h_chamfer=tan(overhang_angle)*overhang_extent+tolerance;

    // cone along wicking chamber
    cylinder(r2=d_drainpipe/2+tolerance, r1=d_drainpipe/2+overhang_extent+tolerance, h=h_chamfer);
}

module funnel() {
    // top donut
    translate([0, 0, h_cone+t_bottom])
    difference() {
        cylinder(r=d_drainpipe/2-tolerance, h=t_top);
        cylinder(r=d_drainpipe/2-2*t_wall-tolerance, h=t_top);
    }

    // conical donut
    difference() {
        translate([0, 0, t_bottom])
        cylinder(r2=d_drainpipe/2-tolerance, r1=d_funnel/2-tolerance, h=h_cone);

//    // keyhole wall 1
//    translate([t_wall, -d_funnel/2, 0])
//    cube([t_wall, d_funnel/2-d_drainpipe/2, h_cone+t_bottom]);

//    // keyhole wall 2
//    translate([-2*t_wall, -d_funnel/2, 0])
//    cube([t_wall, d_funnel/2-d_drainpipe/2, h_cone+t_bottom]);

        // drainage donut below wicking chamber
        translate([0, 0, h_wicking_chamber])
        cylinder(r2=d_drainpipe/2-2*t_wall-tolerance, r1=d_drainpipe/2+tolerance, h=h_cone+t_bottom-h_wicking_chamber);

        // wicking chamber donut
        cylinder(r=d_drainpipe/2+tolerance, h=h_wicking_chamber);
    }

//    // support donut
//    difference() {
//        cylinder(r=d_funnel/2+t_wall, h=h_cone+t_bottom);
//        cylinder(r=d_funnel/2, h=h_cone+t_bottom);
//    }

    // base cylinder
    difference() {
        cylinder(r=d_funnel/2-tolerance, h=t_bottom);
        cylinder(r=d_drainpipe/2+tolerance, h=t_bottom);
    }
}

difference() {
    funnel();

    chamfer();

    // keyhole for vasemode printing
    w_keyhole = d_funnel/2-d_drainpipe/2-overhang_extent;
    h_vert_cut = h_cone+t_top+t_bottom;
    translate([-t_wall_clearance/2, -d_funnel/2, 0])
    cube([t_wall_clearance, d_funnel/2, h_vert_cut]);

//    // keyhole with triangle cutout
//    translate([0, -d_drainpipe/2-overhang_extent-w_keyhole*1.55, 0])
//    rotate([0, 0, 90])
//    cylinder(h=tan(overhang_angle)*w_keyhole, r1=w_keyhole, r2=0, $fn=6);
}
