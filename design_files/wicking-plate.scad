// design parameters
include <design-params.scad>
include <helper-functions.scad>

d_wicking_plate = d_buoy_cavity-2*t_wall_clearance;
d_water_injection_port_cavity_wicking_plate = d_water_injection_port_buoy+2*t_wall_clearance;

// Hidden variables:
$fn=6;

module wicking_chamber_cavity() {
    cylinder(r1=d_wicking_chamber/2-t_wall, r2=d_wicking_chamber/4-t_wall, h=h_conical_cavity+h_wicking_chamber, $fn=6.1);
}

module support_beams() {
    difference() {
        cylinder(r1=d_wicking_plate/2, r2=d_wicking_chamber/4, h=h_conical_cavity);

        for ( i = [0:1:2])
            rotate([0, 0, i*120])
            translate([d_buoy_cavity/2+t_wall, 0, 0])
            cylinder(r=d_buoy_cavity/2, h=h_conical_cavity);

        wicking_chamber_cavity();
    }
}

// baseplate
difference() {
    // base
    cylinder(r1=d_wicking_plate/2, r2=d_wicking_plate/2-h_bottom_shell*tan(overhang_angle), h=h_bottom_shell);

    // drain mesh
    rotate([0, 0, 30])
    honeycomb_generator(n=23*scale_factor, r_hex=d_drain_hole/2, r_dist=r_drain_hole_dist, h=h_bottom_shell);

    // cutout for wicking chamber
    cylinder(r=d_wicking_chamber/2-t_wall, h=h_bottom_shell);

    // water injection port cavity
    translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
    water_injection_port_cavity(d_water_injection_port_cavity_wicking_plate/2);
}

// wicking chamber
difference() {
    cylinder(r1=d_wicking_chamber/2, r2=d_wicking_chamber/4, h=h_conical_cavity+h_wicking_chamber);

    wicking_chamber_cavity();
}

// support beams
support_beams();
difference() {
    mirror([1, 0, 0])
    support_beams();

    // water injection port cavity
    translate([d_buoy/2-d_water_injection_port_buoy/2, 0, 0])
    water_injection_port_cavity(d_water_injection_port_cavity_wicking_plate/2);
}
