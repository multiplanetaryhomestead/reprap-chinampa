// design parameters
include <design-params.scad>
include <helper-functions.scad>

// Hidden variables:
$fn=6;

// baseplate
difference() {
    cylinder(r=d_planter_cavity/2, h=h_bottom_shell);

    // drain mesh
    make_bottom_holes(.11, .12, 6*7, d_planter);
    make_bottom_holes(.13, .14, 6*8, d_planter);
    make_bottom_holes(.15, .16, 6*9, d_planter);
    make_bottom_holes(.17, .18, 6*10, d_planter);
    make_bottom_holes(.19, .20, 6*11, d_planter);
    make_bottom_holes(.21, .22, 6*12, d_planter);
    make_bottom_holes(.23, .24, 6*13, d_planter);
    make_bottom_holes(.25, .26, 6*14, d_planter);
    make_bottom_holes(.27, .28, 6*15, d_planter);
    make_bottom_holes(.29, .30, 6*16, d_planter);
    make_bottom_holes(.31, .32, 6*17, d_planter);
    make_bottom_holes(.33, .34, 6*18, d_planter);
    make_bottom_holes(.35, .36, 6*19, d_planter);
    make_bottom_holes(.37, .38, 6*20, d_planter);

    cylinder(r=d_wicking_chamber/2, h=h_bottom_shell);

}

// wicking chamber
difference() {
    cylinder(r1=d_wicking_chamber/2, r2=d_wicking_chamber/4, h=h_conical_cavity+h_wicking_chamber);
    cylinder(r1=d_wicking_chamber/2-t_wall, r2=d_wicking_chamber/4-t_wall, h=h_conical_cavity+h_wicking_chamber);
}
