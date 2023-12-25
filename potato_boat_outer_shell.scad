bucket_diameter = 235;
bucket_height = 210;
wall_thickness = 1.2;

difference()
{
    cylinder(r=bucket_diameter/2, h=bucket_height, $fn=6);
    translate([0, 0, wall_thickness])
    cylinder(r=(bucket_diameter/2 - 2*wall_thickness), h=bucket_height, $fn=6);
}