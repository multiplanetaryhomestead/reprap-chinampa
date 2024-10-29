// design parameters
include <design-params.scad>
include <helper-functions.scad>

// Hidden variables:
$fn=6;

// baseplate
difference() {
    // base
    cylinder(r1=d_planter_cavity/2, r2=d_planter_cavity/2-h_bottom_shell, h=h_bottom_shell);

    // drain mesh
    for ( i = [0:1:6])
        make_bottom_holes(.035*i+.14, .035*i+.15, 6*(i+5), d_planter);

    // cutout for wicking chamber
    cylinder(r=d_wicking_chamber/2, h=h_bottom_shell);

}

// wicking chamber
difference() {
    cylinder(r1=d_wicking_chamber/2, r2=d_wicking_chamber/4, h=h_conical_cavity+h_wicking_chamber);
    cylinder(r1=d_wicking_chamber/2-t_wall, r2=d_wicking_chamber/4-t_wall, h=h_conical_cavity+h_wicking_chamber);
}
