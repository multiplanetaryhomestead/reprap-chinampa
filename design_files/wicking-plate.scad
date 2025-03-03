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
d_wicking_chamber_short_base = d_planter/4;
h_wicking_chamber_short = h_conical_cavity;

// Hidden variables:
$fn=6;

module wicking_chamber_cavity() {
    // wicking chamber cavity (long section)
    translate([0, 0, h_wicking_chamber_short])
    cylinder(r1=d_wicking_chamber_long_base/2-t_wall, r2=d_wicking_chamber_tip/2-t_wall, h=h_wicking_chamber_long, $fn=6.1);

    // wicking chamber cavity (short section)
    cylinder(r1=d_wicking_chamber_short_base/2-t_wall, r2=d_wicking_chamber_long_base/2-t_wall, h=h_wicking_chamber_short, $fn=6.1);
}

module wicking_chamber() {
    // conical tip
    translate([0, 0, h_conical_cavity+h_drain_pipe-h_conical_tip])
    difference() {
        rotate([0, 0, 30])
        cylinder(h=h_conical_tip, r1=d_wicking_chamber_tip*sqrt(3)/4, r2=d_conical_tip/2, $fn=6);
        rotate([0, 0, 30])
        cylinder(h=h_conical_tip, r1=d_wicking_chamber_tip*sqrt(3)/4-t_wall, r2=d_conical_tip/2-t_wall, $fn=6);
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

module support_beams() {
    for (i = [0:1:1]) {
        rotate([0, 0, 60*i])
        difference() {
            cylinder(r1=d_buoy_cavity/2, r2=d_drain_pipe/2, h=h_conical_cavity);

            for ( i = [0:1:2])
                rotate([0, 0, i*120])
                translate([d_buoy_cavity/2+t_wall, 0, 0])
                cylinder(r=d_buoy_cavity/2, h=h_conical_cavity);

            wicking_chamber_cavity();
        }
    }
}

// wicking chamber
wicking_chamber();

// support beams
difference() {
    support_beams();

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, 60*i])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_wicking_plate/2, h=z_limit);
    }
}
