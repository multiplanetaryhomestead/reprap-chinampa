raft_diameter = 200;
raft_height = 10;
wall_thickness = 1.6;

thickness_walls = 0.8;

tolerance_offset = 0.1;

overhang_extent=4*thickness_walls+tolerance_offset;
overhang_angle = 45;
overhang_height=1;

wicking_chamber_diameter = 50.8;
hole_cutout_diameter = wicking_chamber_diameter + overhang_extent;

// Hidden variables:
$fn=60;

module donut() {
    difference() {
        cylinder(r=raft_diameter/2, h=raft_height);
        cylinder(r=hole_cutout_diameter/2, h=raft_height);
    }
}

donut();