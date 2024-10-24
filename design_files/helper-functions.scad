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
