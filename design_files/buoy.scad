// design parameters
include <design-params.scad>
use <helper-functions.scad>

// Hidden variables:
fillet_steps = 400;
res_cyl = 24;
res_fil = 96;
$fn = res_fil;
z_fighting = 0.01;

// used for cutting out filleted hole
module filleted_hole(r_hole, r_fil) {
    difference() {
        cylinder(h=r_fil, r=4*r_hole, $fn=res_cyl);

        bottomFillet(b=0, r=r_fil, s=fillet_steps)
        difference() {
            cylinder(h=r_fil, r=8*r_hole, $fn=res_fil);
            cylinder(h=r_fil, r=r_hole, $fn=res_fil);
        }
    }
}

// bottom fillet along keyhole and wall edges
module keyhole_fillet(r_fil) {
    r_fillet_offset = 3*r_fil/sqrt(3);
    corner_to_drainpipe_angle = 24.2; //asin((d_drain_pipe/2)/(d_buoy/2 - r_fillet_offset));
    module equilateraltriangle_corner_fillet() {
        difference() {
            // base triangular block
            translate([r_fillet_offset, -r_fil, 0])
            linear_extrude(h_buoy + h_bottom_fillet_offset + z_fighting)
            equilateraltriangle2d(r=d_buoy/2);

            // filleted triangular block
            bottomFillet(b=0, r=r_fil, s=fillet_steps)
            linear_extrude(h_buoy + h_bottom_fillet_offset + z_fighting)
            rounding2d(r_fil)
            equilateraltriangle2d(r=d_buoy/2);

            // negative x-axis corner
            translate([-d_buoy, 0, 0])
            cube([d_buoy, d_buoy/2, h_buoy + h_bottom_fillet_offset + z_fighting]);

            // positive y-axis edge
            translate([d_buoy/2 - r_fillet_offset, r_fil, 0])
            rotate([0, 0, 30])
            cube([d_i_buoy/2, d_buoy/2, h_buoy + h_bottom_fillet_offset + z_fighting]);

            // positive y-axis corner
            translate([0, r_fil, 0])
            cube([d_buoy/2 - r_fillet_offset, d_i_buoy/2, h_buoy + h_bottom_fillet_offset + z_fighting]);
        }
    }

    // main mold
    difference() {
        equilateraltriangle_corner_fillet();

        // pos-x neg-y
        translate([-r_fillet_offset, -d_buoy/2, 0])
        cube([d_buoy + r_fil, d_buoy/2, h_buoy + h_bottom_fillet_offset + z_fighting]);
    }

    // filleted wedge to remove sharp corner along intersection of drainpipe and keyhole walls
    difference() {
        translate([d_buoy/2 - r_fillet_offset, r_fil, 0])
        rotate([0, 0, -corner_to_drainpipe_angle])
        translate([-d_buoy/2 + r_fillet_offset, -r_fil, 0])
        equilateraltriangle_corner_fillet();

        // pos-x neg-y
        translate([-2*r_fil, -d_buoy/2, 0])
        cube([d_buoy, d_buoy/2, h_buoy + h_bottom_fillet_offset + z_fighting]);

        // pos-y neg-x
        rotate([0, 0, -corner_to_drainpipe_angle])
        translate([-d_buoy/2, -d_buoy/2, 0])
        cube([d_buoy/2, d_buoy, h_buoy + h_bottom_fillet_offset + z_fighting]);
    }
}

// keyhole for vasemode printing
module keyhole() {
    t_wall_clearance = 0.1;
    translate([0, -t_wall_clearance/2, 0])
    cube([d_buoy/2, t_wall_clearance, h_buoy + z_fighting]);
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
    invisible_shell(r_o=d_buoy/2+d_water_injection_port_buoy, r_i=d_buoy/2, h=h_buoy+z_fighting, r_fil=r_fillet);

    // keyhole for vasemode printing
    keyhole();

    // bottom fillet along keyhole and wall edges
    keyhole_fillet(r_fil=r_fillet);
    mirror([0, 1, 0])
    keyhole_fillet(r_fil=r_fillet);
}

// conical cavity walls
difference() {
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    linear_extrude(h_conical_cavity)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy/2);

    // top hexagonal cavity
    translate([0, 0, h_drain_pipe+h_bottom_shell])
    linear_extrude(h_conical_cavity)
    rounding2d(r_fillet)
    hexagon2d(r=d_buoy_cavity/2);

    // water injection port cavity
    for (i = [0:1:6]) {
        rotate([0, 0, i*60])
        translate([x_water_injection_port, 0, 0])
        water_injection_port_cavity(r=d_water_injection_port_cavity_buoy/2, h=h_buoy+z_fighting);
    }

    // keyhole for vasemode printing
    keyhole();

    // bottom fillet along keyhole and wall edges
    keyhole_fillet(r_fil=r_fillet);
    mirror([0, 1, 0])
    keyhole_fillet(r_fil=r_fillet);
}

// buoy
translate([0, 0, -h_bottom_fillet_offset])
difference() {
    // base hexagon with filleted edges to mitigate cracking
    bottomFillet(b=0, r=r_fillet, s=fillet_steps)
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
    filleted_hole(r_hole=d_drain_pipe/2, r_fil=r_fillet);

    // bottom fillet along keyhole and wall edges
    keyhole_fillet(r_fil=r_fillet);
    mirror([0, 1, 0])
    keyhole_fillet(r_fil=r_fillet);

    // remove layers that would otherwise create undesireable infill behavior
    linear_extrude(h_bottom_fillet_offset)
    hexagon2d(r=d_buoy/2+t_wall);
}
