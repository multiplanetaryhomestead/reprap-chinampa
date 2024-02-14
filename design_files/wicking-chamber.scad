// This work builds off @leemes design for a parametric net pot, but modified to house a 50mm diameter peat moss pellet for use as a water-wicking medium. Original work can be found at https://www.thingiverse.com/thing:790339 licensed under CC-BY-SA 3.0 https://creativecommons.org/licenses/by-sa/3.0/

diameter_top=50.8;
diameter_bottom=50.8;

height=55;

thickness_bottom=0.8;
thickness_walls=0.8;

overhang_extent=4*thickness_walls;
overhang_height=1;
overhang_angle=45;

width_connections=3;

pie_segments_1=12;
pie_segments_2=24;
pie_segments_3=32;

pie_segments_wall=32;

interface_depth=2*thickness_walls;

// Hidden variables:
$fn=30;

// HELPERS
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



// OBJECT PARTS
module positive() {
    cylinder(r1=diameter_bottom/2, r2=diameter_top/2, h=height+interface_depth);

    // Overhang
    translate([0,0,height-overhang_height]) {
        cylinder(r=diameter_top/2+overhang_extent, h=overhang_height);
        // printing aid (overhang_angle degrees of overhang are assumed to be printable)
        mirror([0,0,1]) {
            intersection() {
                cylinder(r2=0, r1=diameter_top/2+overhang_extent,
                         h=(diameter_top/2+overhang_extent)/tan(overhang_angle));
                cylinder(r=diameter_top/2+overhang_extent, h=height-overhang_height);
            }
        }
    }
}

module negative() {
    module make_bottom_holes(begin,end,pie_segments) {
        translate([0,0,0])
        difference() {
            cyl_sect(r1=end*diameter_bottom, r2=begin*diameter_bottom, h=thickness_bottom+2);
            for (i=[0:pie_segments]) {
                connect(r=diameter_bottom,
                        w=width_connections,
                        h=thickness_bottom+2,
                        phi=i*360/pie_segments);
            }
        }
    }
    module make_wall_holes(begin,end,pie_segments) {
        translate([0,0,begin*height])
        difference() {
            cylinder(r=diameter_bottom+diameter_top, h=(end-begin)*height);
            for (i=[0:pie_segments]) {
                connect(r=diameter_bottom+diameter_top,
                        w=width_connections,
                        h=(end-begin)*height,
                        phi=i*360/pie_segments);
            }
        }
    }

    union() {
        // inside
        difference() {
            cylinder(r1=diameter_bottom/2-thickness_walls, r2=diameter_top/2-thickness_walls, h=height+interface_depth);
            cylinder(r=diameter_top+diameter_bottom, h=thickness_bottom);
        }

        // holes on wall
        union() {
            make_wall_holes(.05, .25, pie_segments_wall);
            make_wall_holes(.30, .50, pie_segments_wall);
            make_wall_holes(.55, .75, pie_segments_wall);
        }

        // holes on bottom
        union() {
            make_bottom_holes(.08, .18, pie_segments_1);
            make_bottom_holes(.22, .32, pie_segments_2);
            make_bottom_holes(.36, .46, pie_segments_3);
        }
    }
}

// MAIN
difference() {
    positive();
    negative();
}
