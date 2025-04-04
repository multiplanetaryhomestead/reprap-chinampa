// isometric grid for drain mesh
// implemented as 3x rectilinear grid patterns stacked on top of each other and rotated 60 degrees apart
module isometric_grid_generator(r=30, w=0.8, h_layer=0.2, h_bottom_shell=3*0.2) {
    n_bottom_shell = h_bottom_shell/h_layer;
    rotate([0, 0, 30])
    for (i = [0:1:n_bottom_shell-1]) {
        translate([0, 0, i*h_layer])
        rotate([0, 0, i*60])
        rectilinear_grid_generator(r=r, w=w, h=h_layer, n=6);
    }
}

// used for generating isometric grid
module rectilinear_grid_generator(r=30, w=0.8, h=0.2, n=3) {
    difference() {
        rotate([0, 0, 90])
        cylinder(h, r=r, $fn=n);
        for (i = [0: 2*w: 2*r]) {
            translate([i-w/2, -r-w, 0])
            cube([w, 3*r, h]);
            translate([-i-w/2, -r-w, 0])
            cube([w, 3*r, h]);
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
module water_injection_port_cavity(r, h) {
    rotate([0, 0, 30])
    cylinder(r=r, h=h, $fn=6);
    for (i = [-1:2:1]) {
        rotate([0, 0, 30*i])
        translate([sqrt(3)*r/2, 0, 0])
        cylinder(r=r, h=h, $fn=6);
    }
}

// water injection port walls
module water_injection_port(r_o, r_i, h) {
    difference() {
        union() {
            rotate([0, 0, 30])
            cylinder(r=r_o, h=h, $fn=6);
            for (i = [-1:2:1]) {
                rotate([0, 0, 30*i])
                translate([sqrt(3)*r_o/4, 0, 0])
                cylinder(r=r_o, h=h, $fn=6);
            }
        }

        // water injection port cavity
        water_injection_port_cavity(r_i, h);
    }
}

// shell used to remove protruding water injection port walls
module invisible_shell(r_o, r_i, h) {
    difference() {
        cylinder(r=r_o, h=h);
        cylinder(r=r_i, h=h);
    }
}
