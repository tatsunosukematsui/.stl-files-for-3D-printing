include <parameters.scad>;
use <base_raspi_sangaboard.scad>;
use <delta_stage.scad>;
use <../openflexure-microscope/openscad/compact_nut_seat.scad>;
use <../openflexure-microscope/openscad/utilities.scad>;
use <../openflexure-block-stage-master/openscad/grid_stage.scad>;
cylinder_height=50;
cylinder_r=5;
box_size=120;
box_height=cylinder_height-20;
stage_height=70;


module top_mounting_point(){
// The supports attached to each leg that slot into the base.
            translate([0,0,6])cylinder(d = 6, h = 100, $fn=50);
            translate([0,0,-50])cylinder(d = 3.5, h = 100, $fn=50);
}
module stage_connect() {
    translate([-box_size/2, box_size/2+10,73])rotate([0,0,45])top_mounting_point();
    translate([box_size/2, box_size/2+10,73])rotate([0,0,-45])top_mounting_point();
    translate([-box_size/2, -box_size/2+10,73])rotate([0,0,135])top_mounting_point();
    translate([box_size/2, -box_size/2+10,73])rotate([0,0,-135])top_mounting_point();
}
module stage_base_top() {
    base_windowed();
}

module stage_connection(){
    // Creates 3 mounting posts to connect to the main body. The top of the post is in line with the top of the base, with the cutout circle 2mm down such that the main body sits 2mm under the top of the base.
    translate([0,0,base_height+1])
    {
        //each_base_mounting_point(){
            difference(){
                hull(){
                    translate([0,0,-2*d])repeat([0,0,-10],2){
                        minkowski(){
                            cube([7,7,d], center = true);
                            cylinder(r = 1, h = d, $fn = 50);
                        }
                    }
                    translate([0,nut_y+stage_r-mounting_point,-20]){
                        difference(){                                
                            linear_extrude(20){
                                projection(){
                                    minkowski(){
                                        screw_seat_shell(10);
                                        cylinder(r=wall_thickness-1,h=d);
                                    }
                                }
                            }
                        translate([-50,-99,-50])cube([100,100,100]);
                        }
                    }
                }
                translate([0,0,-2])cylinder(d = 8.5, h = 2, $fn=50);
                translate([0,0,-8+d])cylinder(d= 3.5, h = 8, $fn=50);
                translate([0,0,-10-8+d])trylinder_selftap(3, h=20, center=true);
                hull()repeat([0,100,0],2) translate([0,-20,-8]) cylinder(d=6.9,h=2.8,$fn=6); 
            }
        //}
    }
}
module stage_connection_bottom(){
difference(){
    stage_connection();
    translate([0,-20,0])cube([999,30,999],center=true);
    }
}

module stage_base_side() {
    rotate([0,0,120])translate([-box_size/2,-51.8,0])cube([box_size,2,base_height-10]);
    rotate([0,0,240])translate([-box_size/2,-51.8,0])cube([box_size,2,base_height-10]);
}

module stage_base_bottom() {
     resize([0,0,7])hull(){
         each_lever()translate([-box_size/2,-76.6,0])cube([box_size,2,81]);
     }
}

module stage_base() {
    difference(){
    stage_base_side();
    translate([0,-50,49])cube([85,10,85],center=true);
    }
    stage_base_top();
    translate([0,0,0])stage_base_bottom();
}


difference(){
    stage_base();
    translate([36,-40.5,15])cylinder(d=3.2*1.2,h=999,center=true);
    mirror([1,0,0])translate([36,-40.5,15])cylinder(d=3.2*1.2,h=999,center=true);
    translate([27,4.5,15])cylinder(d=3.2*1.2,h=999,center=true);
    mirror([1,0,0])translate([27,4.5,15])cylinder(d=3.2*1.2,h=999,center=true);
    #translate([36,-40.5,0])cylinder(d=7,h=5); #mirror([1,0,0])translate([36,-40.5,0])cylinder(d=7,h=5);
    #translate([27,4.5,0])cylinder(d=7,h=5);
    #translate([27,4.5,0])cylinder(d=7,h=5); #mirror([1,0,0])translate([27,4.5,0])cylinder(d=7,h=5);
}

//difference(){
//    stage_base();
//    translate([36,-40.5,15])cylinder(d=3.2*1.2,h=999,center=true);
//    mirror([1,0,0])translate([36,-40.5,15])cylinder(d=3.2*1.2,h=999,center=true);
//    translate([27,4.5,15])cylinder(d=3.2*1.2,h=999,center=true);
//    mirror([1,0,0])translate([27,4.5,15])cylinder(d=3.2*1.2,h=999,center=true);
//}

//rotate([0,0,180])translate([0,25,15])grid_main_body();
//translate([0,0,100])main_body();
