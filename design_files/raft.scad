raft_diameter = 200;
raft_height = 160;
wall_thickness = 1.6;

thickness_bottom = 0.8;
thickness_walls = 0.8;

tolerance_offset = 0.1;

overhang_extent=4*thickness_walls+tolerance_offset;
overhang_angle = 45;
overhang_height=1;

wicking_chamber_diameter = 50.8;
hole_cutout_diameter = wicking_chamber_diameter + overhang_extent;

// Hidden variables:
$fn=60;

module chamfer() {
    translate([0,0,raft_height-overhang_height]) {
       cylinder(r=wicking_chamber_diameter/2+overhang_extent, h=overhang_height);
        // printing aid (overhang_angle degrees of overhang are assumed to be printable)
        mirror([0,0,1]) {
            intersection() {
                cylinder(r2=0, r1=wicking_chamber_diameter/2+overhang_extent,
                         h=(wicking_chamber_diameter/2+overhang_extent)/tan(overhang_angle));
                cylinder(r=wicking_chamber_diameter/2+overhang_extent, h=raft_height-overhang_height);
            }
        }
    }
}

module donut() {
    difference() {
        cylinder(r=raft_diameter/2, h=raft_height);
        cylinder(r=hole_cutout_diameter/2, h=raft_height);
    }
}

difference() {
    donut();
    chamfer();
}