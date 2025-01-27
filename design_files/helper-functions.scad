// used for generating isometric grid
module rectilinear_grid_generator(r=30, w=0.4, h=0.1, n=3) {
    difference() {
        cylinder(h, r=r, $fn=n);
        for (i = [0: 2*w: 2*r]) {
            translate([-r + i, -r, 0])
            cube([w, 2*r, h]);
        }
    }
}

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
    rotate([0, 0, 30])
    cylinder(r=r, h=z_limit);
    for (i = [-1:2:1]) {
        rotate([0, 0, 30*i])
        translate([r, 0, 0])
        cylinder(r=r, h=z_limit);
    }
}

// water injection port walls
module water_injection_port(r_o, r_i, h) {
    difference() {
        rotate([0, 0, 30])
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
