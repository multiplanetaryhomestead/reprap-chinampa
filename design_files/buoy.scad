// design parameters
include <design-params.scad>
use <helper-functions.scad>

// Hidden variables:
res_cyl = 24;
res_fil = 96;
$fn = res_fil;
z_fighting = 0.01;

// used for cutting out filleted hole
module filleted_hole(r_hole, r_fil) {
    difference() {
        cylinder(h=r_fil, r=4*r_hole, $fn=res_cyl);

        bottomFillet(b=0, r=r_fil, s=200)
        difference() {
            cylinder(h=r_fil, r=8*r_hole, $fn=res_fil);
            cylinder(h=r_fil, r=r_hole, $fn=res_fil);
        }
    }
}

// fillet along keyhole
module keyhole_fillet(r_fil) {
    translate([-r_fil, 0, 0])
    difference() {
        cube([y_limit + 2*r_fil, 2*r_fil, r_fil]);

        bottomFillet(b=0, r=r_fil, s=100)
        cube([y_limit + 2*r_fil, 2*r_fil, r_fil]);

        cube([r_fil, 2*r_fil, r_fil]);

        translate([y_limit + r_fil, 0, 0, ])
        cube([r_fil, 2*r_fil, r_fil]);

        translate([0, r_fil, 0, ])
        cube([y_limit + 2*r_fil, r_fil, r_fil]);
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
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_buoy, r_i=d_buoy/2, h=z_limit, r_fil=r_fillet);

    // keyhole for vasemode printing
    keyhole();
}

// conical cavity walls
difference() {
    translate([0, 0, h_drain_pipe])
    linear_extrude(h_conical_cavity+h_bottom_shell)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy/2);

    // top hexagonal cavity
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    linear_extrude(h_conical_cavity+z_fighting)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy_cavity/2);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=h_buoy+z_fighting);
    }

}

// buoy
translate([0, 0, -h_bottom_fillet_offset])
difference() {
    // base hexagon with filleted edges to mitigate cracking
    bottomFillet(b=0, r=r_fillet, s=400)
    linear_extrude(h_buoy+h_bottom_fillet_offset)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy/2);

    // top hexagonal cavity
    translate([0, 0, h_conical_cavity+h_drain_pipe+h_bottom_fillet_offset])
    linear_extrude(h_buoy-h_conical_cavity-h_drain_pipe+z_fighting)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy_cavity/2);

    // conical cavity for wicking plate
    translate([0, 0, h_drain_pipe+h_bottom_shell+h_bottom_fillet_offset])
    cylinder(r1=d_drain_pipe/2, r2=d_buoy_cavity/2, h=h_conical_cavity, $fn=res_fil);

    // cavity for drain pipe
    cylinder(r=d_drain_pipe/2, h=h_buoy+h_bottom_fillet_offset, $fn=res_fil);

    // keyhole for vasemode printing
    keyhole();

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=h_buoy+h_bottom_fillet_offset+z_fighting);
    }

    // filleted hole
    r_bottom_hole_fillet = 0.5*r_fillet;
    h_bottom_hole_fillet_offset = 0.25*r_bottom_hole_fillet;
    filleted_hole(r_hole=d_drain_pipe/2, r_fil=r_bottom_hole_fillet);

    // bottom fillet along keyhole
    keyhole_fillet(r_fil=r_bottom_hole_fillet);
    mirror([0, 1, 0])
    keyhole_fillet(r_fil=r_bottom_hole_fillet);

    // remove layers that would otherwise create undesireable infill behavior
    linear_extrude(h_bottom_fillet_offset)
    hexagon2d(r=d_buoy/2+t_wall);
}
