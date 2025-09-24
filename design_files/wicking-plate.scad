// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_wicking_plate = d_buoy_cavity-2*t_wall_clearance;
d_water_injection_port_cavity_wicking_plate = d_water_injection_port_buoy+2*t_wall;

d_wicking_chamber_long_base = d_drain_pipe-4*t_wall_clearance;
d_wicking_chamber_tip = d_wicking_chamber_long_base-2*t_wall;
d_conical_tip = d_drain_hole+2*t_wall;
h_conical_tip = (d_wicking_chamber_tip/2-d_conical_tip/2)*tan(45);
h_wicking_chamber_long = h_drain_pipe-h_conical_tip;
h_wicking_chamber_short = h_conical_cavity;
t_clearance = 0.2;

// Hidden variables:
$fn=96;

module wicking_chamber_cavity() {
    // wicking chamber cavity (long section)
    translate([0, 0, h_wicking_chamber_short])
    cylinder(r1=d_wicking_chamber_long_base/2-t_wall, r2=d_wicking_chamber_tip/2-t_wall, h=h_wicking_chamber_long);

    // wicking chamber cavity (short section)
    cylinder(r1=d_wicking_chamber_short_base/2-t_wall-2*t_clearance, r2=d_wicking_chamber_long_base/2-t_wall-2*t_clearance, h=h_wicking_chamber_short);
}

module wicking_chamber() {
    // conical tip
    translate([0, 0, h_conical_cavity+h_drain_pipe-h_conical_tip])
    difference() {
        rotate([0, 0, 30])
        cylinder(h=h_conical_tip, r1=d_wicking_chamber_tip/2, r2=d_conical_tip/2);
        rotate([0, 0, 30])
        cylinder(h=h_conical_tip, r1=d_wicking_chamber_tip/2-t_wall, r2=d_conical_tip/2-t_wall);
    }

    // wicking chamber (long section)
    difference() {
        translate([0, 0, h_wicking_chamber_short])
        cylinder(r1=d_wicking_chamber_long_base/2, r2=d_wicking_chamber_tip/2, h=h_wicking_chamber_long);

        wicking_chamber_cavity();
    }

    // wicking chamber (short section)
    difference() {
        cylinder(r1=d_wicking_chamber_short_base/2, r2=d_wicking_chamber_long_base/2, h=h_wicking_chamber_short);

        wicking_chamber_cavity();
    }
}

module support_beams(t=t_wall+2*t_clearance) {
    for (i = [0:1:1]) {
        rotate([0, 0, 60*i])
        difference() {
            h_taper = tan(90-overhang_angle)*d_drain_pipe/2;
            union() {
                // base hexagonal pyramid
                cylinder(r1=d_buoy_cavity/2, r2=d_drain_pipe/2, h=h_conical_cavity);

                // top hexagonal pyramid to mitigate unusual bridging behavior
                translate([0, 0, h_conical_cavity])
                cylinder(r1=d_drain_pipe/2, r2=0, h=h_taper);
            }

            for ( i = [0:1:2]) {
                rotate([0, 0, i*120])
                translate([d_buoy_cavity/2+t*2/sqrt(3), 0, 0])
                cylinder(r=d_buoy_cavity/2, h=h_conical_cavity+h_taper, $fn=6);
            }
            wicking_chamber_cavity();

            // water injection port cavity
            for (i = [0:1:6]) {
                rotate([0, 0, 60*i])
                translate([x_water_injection_port-t_wall-2*t_clearance+t, 0, 0])
                water_injection_port_cavity(r=d_water_injection_port_cavity_wicking_plate/2, h=z_limit);
            }
        }
    }
}

// wicking chamber
difference() {
    wicking_chamber();
    support_beams(t_clearance);
}

// support beams
difference() {
    support_beams();
    translate([0, 0, -h_layer])
    support_beams(t_clearance);
}
