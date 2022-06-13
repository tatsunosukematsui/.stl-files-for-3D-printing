use <utilities.scad>;
use <compact_nut_seat.scad>;
include <parameters.scad>;
use <utilities.scad>;
use <fibre_stage_three_legs.scad>;

//translate([0,0,0])rotate([0,0,0])grid_cover();
hold_hieght = 10;
slide_glass_thickness = 0.8;
slide_glass_width = 26;

module grid_cover() {
    l=0.5;//12.5
    difference() {
        difference(){
            union(){
                cube([18,3,hold_hieght-1],center=false);
                mirror([1,0,0]) {
                    cube([18,3,hold_hieght-1],center=false);
                }
            }
        translate([15,0,hold_hieght/2])rotate([90,0,0])cylinder(d=3.3*1.15,h=999, center=true);
        mirror([1,0,0]) {
            translate([15,0,hold_hieght/2])rotate([90,0,0])cylinder(d=3.3*1.15,h=999, center=true);
        }
        }
    }
    difference(){
        translate([0, 1.5, 16-l])difference(){
            translate([0,0,9])cube([20, 3, 35], center = true);
            translate([0, 0, 20]){
                cube([14, 4, 14], center = true);
                #cube([16, 1.2, 16], center = true);
        }
    }
   translate([0, 0, -40])cube([999,999,40],center=true); 
}
}
grid_cover();