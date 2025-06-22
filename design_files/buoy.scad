// design parameters
include <design-params.scad>
use <helper-functions.scad>

t_vert_wall = h_buoy-h_conical_cavity-h_drain_pipe;

// Hidden variables:
$fn = 6;
res_cyl = 24;
res_fil = 96;

// used for cutting out filleted hole
module filleted_hole(r_hole, r_fil, h_bottom_offset) {
    translate([0, 0, -h_bottom_offset])
    difference() {
        cylinder(h=r_fil, r=4*r_hole, $fn=res_cyl);

        // remove layers that would otherwise print steep overhangs due to fillet
        cylinder(h=h_bottom_fillet_offset, r=r_hole);

        bottomFillet(b=0, r=r_fil, s=200)
        difference() {
            cylinder(h=r_fil, r=8*r_hole, $fn=res_fil);
            cylinder(h=r_fil, r=r_hole, $fn=res_fil);
        }
    }
}

// fillet along keyhole
module keyhole_fillet(r_fil, h_bottom_offset) {
    translate([-r_fil, 0, -h_bottom_offset])
    difference() {
        cube([y_limit/2 + r_fil, 2*r_fil, z_limit]);

        // remove layers that would otherwise print steep overhangs due to fillet
        cube([y_limit/2 + r_fil, 2*r_fil, h_bottom_offset]);

        cube([r_fil, 2*r_fil, z_limit]);

        translate([y_limit - r_fil, 0, 0, ])
        cube([r_fil, 2*r_fil, z_limit]);

        translate([0, r_fil, 0, ])
        cube([y_limit, r_fil, z_limit]);

        bottomFillet(b=0, r=r_fil, s=100)
        cube([y_limit, 2*r_fil, z_limit]);
    }
}

// keyhole for vasemode printing
module keyhole() {
    t_wall_clearance = 0.1;
    translate([0, -t_wall_clearance/2, 0])
    cube([y_limit/2, t_wall_clearance, z_limit]);
}

// water injection port walls
translate([0, 0, r_fillet])
difference() {
    // water injection port walls
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port(r_o=d_water_injection_port_buoy/2, r_i=d_water_injection_port_cavity_buoy/2, h=h_buoy-r_fillet);
    }

    // shell used to remove protruding water injection port walls
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_buoy, r_i=d_buoy/2, h=z_limit);

    // keyhole for vasemode printing
    keyhole();
}

// buoy
difference() {
    cylinder(r=d_buoy/2, h=h_buoy);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_drain_pipe+h_bottom_shell])
    cylinder(r=d_buoy_cavity/2, h=t_vert_wall);

    // conical cavity for wicking plate
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    cylinder(r1=d_drain_pipe/2, r2=d_buoy_cavity/2, h=h_conical_cavity);

    // cavity for drain pipe
    cylinder(r=d_drain_pipe/2, h=h_buoy, $fn=res_fil);

    // keyhole for vasemode printing
    keyhole();

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=z_limit+h_bottom_shell);
    }

    // bottom fillet for mitigating cracking
    // circular filleted cutout of outer bottom
    circular_outer_bottom_fillet(r_cyl=d_buoy/2, r_fil=r_fillet, h_bottom_offset=h_bottom_fillet_offset, res=res_fil);

    // filleted hole
    r_bottom_hole_fillet = 0.5*r_fillet;
    h_bottom_hole_fillet_offset = 0.25*r_bottom_hole_fillet;
    filleted_hole(r_hole=d_drain_pipe/2, r_fil=r_bottom_hole_fillet, h_bottom_offset=h_bottom_hole_fillet_offset);

    // bottom fillet along keyhole
    keyhole_fillet(r_fil=r_bottom_hole_fillet, h_bottom_offset=h_bottom_hole_fillet_offset);
    mirror([0, 1, 0])
    keyhole_fillet(r_fil=r_bottom_hole_fillet, h_bottom_offset=h_bottom_hole_fillet_offset);
}
