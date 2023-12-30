raft_diameter = 230;
raft_height = 30;
wall_thickness = 1.2;

module chamfer() {
    //cylinder(r=2*wall_thickness, h=raft_height, $fn=12);
    difference()
    {
        cylinder(r=raft_diameter/2, h=raft_height, $fn=12);
        cylinder(r=(raft_diameter/2 - 4*wall_thickness), h=raft_height, $fn=48);
    }
}

module hexagon() {
    difference() {
        cylinder(r=raft_diameter/2, h=raft_height, $fn=6);
    chamfer();
    }
}

difference() {
    hexagon();
    cylinder(r=2*wall_thickness, h=raft_height, $fn=12);
}