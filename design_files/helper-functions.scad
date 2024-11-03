// for generating drain mesh
module honeycomb_generator(n=5, r_hex=0.8, r_dist=1.6, h=0.2) {
    angle=60;
    for (i = [1:1:6]) {
        if (angle*i % angle == 0 && n > 0) {
            rotate([0, 0, angle*i])
            translate([0, r_dist*n, 0])
            cylinder(r=r_hex, h=h, $fn=6);
        }
        if (n % 2 == 0) {
            rotate([0, 0, angle*i])
            translate([r_dist*n*1.5/sqrt(3), 0, 0])
            cylinder(r=r_hex, h=h, $fn=6);
        }
        if (n % 2 == 0 && n > 3) {
            for (j = [-(n-2):2:(n-2)]) {
                rotate([0, 0, angle*i])
                translate([r_dist*n*1.5/sqrt(3), j*r_dist/2, 0])
                cylinder(r=r_hex, h=h, $fn=6);
            }
        }
        if (n % 2 != 0 && n > 2) {
            for (j = [-(n-2):2:(n-2)]) {
                rotate([0, 0, angle*i])
                translate([r_dist*n*1.5/sqrt(3), j*r_dist/2, 0])
                cylinder(r=r_hex, h=h, $fn=6);
            }
        }
    }
    if (n > 0) {
        honeycomb_generator(n=n-1, r_hex=r_hex, r_dist=r_dist, h=h);
    }
}

// water injection port cavity
module water_injection_port_cavity(r) {
    cylinder(r=r, h=z_limit);
    for ( i = [1:1:4]) {
        translate([r*i, 0, 0])
        cylinder(r=r, h=z_limit);
    };
}

// water injection port walls
module water_injection_port(r_o, r_i, h) {
    difference() {
        cylinder(r=r_o, h=h);

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
