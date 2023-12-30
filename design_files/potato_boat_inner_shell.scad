bucket_diameter = 230;
bucket_height = 210;
wall_thickness = 1.2;

module cutout() {
    cylinder(r=2*wall_thickness, h=wall_thickness, $fn=12);
    difference()
    {
        cylinder(r=bucket_diameter/2, h=wall_thickness, $fn=12);
        cylinder(r=(bucket_diameter/2 - 4*wall_thickness), h=wall_thickness, $fn=48);
    }
}

module shell() {
    difference()
    {
        cylinder(r=bucket_diameter/2, h=bucket_height, $fn=6);
        translate([0, 0, wall_thickness])
        cylinder(r=(bucket_diameter/2 - 2*wall_thickness), h=bucket_height, $fn=6);
    }
}

difference() {
    shell();
    cutout();
}