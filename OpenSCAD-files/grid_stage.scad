use <utilities.scad>;
use <compact_nut_seat.scad>;
use <fibre_stage_three_legs.scad>;
use <base.scad>;
use <grid_slideglass_hold.scad>
include <parameters.scad>;

module exterior_brim(r=4, h=0.2){
    // Add a "brim" around the outside of an object *only*, preserving holes in the object
    children();
    
    if(r>0) linear_extrude(h) difference(){
        offset(r) projection(cut=true) translate([0,0,-d]) children();
       
        offset(-r) offset(r) projection(cut=true) translate([0,0,-d]) children();
    }
}
module z_base(){
    // Trapezoid that forms the base of the Z stage
    t = xy_bottom_travel;
    w = z_stage_base_w;
    hull(){
        translate([-pw,-pw-t,0]) cube([2*pw,d,d]); // inner edge
        translate([-w/2, -stage[1]/2-t, 0]) cube([w, d, d]);
        translate([-w/2, z_stage_base_y, 0]) cube([w, d, d]);
    }
}
module z_stage(){
    // This is the part that moves in Z only, connected to the middle
    // "shelf" of the XY table
    // The triangular base of this part must fit between the 
    // pushsticks for the XY motion, which constrains the tip position
    // and also means we must bring the sides out at 45 degrees.
    difference(){
        sequential_hull(){
            z_base();
            translate([0,0,stage[2]]) z_base();
            translate([0,0,shelf_z1 + stage[2]/2]) cube(stage,center=true);
        }
        
        // clearance for Z pushstick (see below)
        translate([-pw/2-1.5, -99, z_pushstick_z - 2 - z_travel]){
            cube([pw+3, 999, pushstick[2]+3.5+2*z_travel]);
        }
    }
    // Join the stage to the anchor with some flexures at the bottom
    reflect([1,0,0]) translate([-z_stage_base_w/2,z_anchor_bottom_y-d,0])
        cube([zflex[0], z_lever + zflex[1]+2*d, zflex[2]]);
    translate([-z_stage_base_w/2,z_anchor_bottom_y+zflex[1],0])
        cube([z_stage_base_w, z_lever - zflex[1], pushstick[2]]);
    // And more flexures at the top
    reflect([1,0,0]) translate([-stage[0]/2,-stage[1]/2,shelf_z1]) mirror([0,1,0]){
        translate([0,-d,0]) cube([zflex[0], z_lever + zflex[1]+2*d, zflex[2]]);
        translate([0,zflex[1],dz]) cube([stage[0]/2+d,z_lever - zflex[1], stage[2]-dz]);
    }
    // The actuating "pushstick" attaches to this lever
    hull(){
        translate([-pw/2, z_stage_base_y - z_lever, 0]) cube([pw, z_lever - zflex[1], stage[2]]);
        translate([-pw/2, z_stage_base_y - 3 - zflex[1], 0]) cube([pw, 3, shelf_z1 - 3]);
    }
    // This is the actuating "pushstick"
    translate([-pw/2, z_stage_base_y, z_pushstick_z]){
        l = z_actuator_pivot_y - z_stage_base_y;
        cube([pw, l, pushstick[2]]);
        translate([0,-zflex[1]*2,0]) cube([pw, l + 4*zflex[1], zflex[2]]);
    }
}

// Overall structure
module grid_main_body(){
    translate([0,0,platform_z-17])grid_hold();

    // XY pushsticks and actuators
    // Z stage (the part that moves only in Z) and actuator
    z_stage();
    translate([0,z_actuator_pivot_y,0]){
        untilted_actuator(z_pushstick_z, z_actuator_pivot_w, z_lever * z_reduction);
    }
    //reinforcement through the void in the centre
    %reflect([1,0,0]) translate([0,0,pushstick[2] + 4 + z_travel]) hull(){
        translate([pw/2+3, z_actuator_pivot_y - wall_t, 0]) cube([4,d,4]);
        translate([stage[0]/2 + zflex[0] + zflex[1] + xy_bottom_travel, -stage[1]/2,0]) cube([0.5,4,4]);
    }
    
    // Casing (also provides a lot of the structural integrity)
    casing();
    
}//*/
brim_r=0;
exterior_brim(r=brim_r) grid_main_body();
//translate([0,0,-20])base();
//translate([0,0,-20])base();