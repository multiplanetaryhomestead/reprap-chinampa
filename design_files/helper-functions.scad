// water injection port cavity
module water_injection_port_cavity(r) {
    cylinder(r=r, h=z_limit);
    translate([4*t_wall, 0, 0])
    cylinder(r=r, h=z_limit);
}

// water injection port walls
module water_injection_port(r_o, r_i) {
    difference() {
        cylinder(r=r_o, h=z_limit);

        // water injection port cavity
        water_injection_port_cavity(r_i);
    }
}

// keyhole for vasemode printing
module keyhole() {
    t_wall_clearance = 0.1;
    translate([0, -t_wall_clearance/2, 0])
    cube([y_limit/2, t_wall_clearance, z_limit]);
}

// HELPERS (used for rendering drain mesh)
// This work builds off @leemes design for a parametric net pot. Original work can be found at https://www.thingiverse.com/thing:790339 licensed under CC-BY-SA 3.0 https://creativecommons.org/licenses/by-sa/3.0/
module cyl_sect(r1, r2, h) {
    difference() {
        cylinder(r=r1, h=h);
        translate([0,0,0])
            cylinder(r=r2, h=h);
    }
}
module connect(r, w, h, phi) {
    rotate(phi, [0,0,1])
        translate([0,-w/2,0])
            cube([r,w,h]);
}
module make_bottom_holes(begin,end,pie_segments, diameter) {
    width_connections=3;
    translate([0,0,0])
    difference() {
        cyl_sect(r1=end*diameter, r2=begin*diameter, h=h_bottom_shell);
        for (i=[0:pie_segments]) {
            connect(r=diameter,
                    w=width_connections,
                    h=h_bottom_shell,
                    phi=i*360/pie_segments);
        }
    }
}
