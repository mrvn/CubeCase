module Disk(ghost=false, body=true) {
    width = 101.61;
    length = 147;
    height = 20;
    screw_x = width / 2 - 3.18;
    screw_y1 = length / 2 - 41.28;
    screw_y2 = screw_y1 - 44.45;
    screw_radius = 1;
    screw_height = 5;
    overlap = 0.123456789;

    screws = [
        [-screw_x, screw_y1], [screw_x, screw_y1],
        [-screw_x, screw_y2], [screw_x, screw_y2],
    ];

    module Body() {
        difference() {
            translate([-width / 2, -length / 2, 0])
                cube([width, length, height]);
            for (i = [0 : 3]) {
                translate([screws[i][0], screws[i][1], -overlap])
                    cylinder(r=screw_radius, h=screw_height + overlap, $fn=6);
            }
            translate([0, length / 2 - 5, -overlap])
                cube([40, 5 + overlap, 5 + overlap]);
        }
    }

    if (ghost) {
        if (body) %Body();
        for (i = [0 : 3]) {
            translate([screws[i][0], screws[i][1], -overlap])
                cylinder(r=screw_radius, h=screw_height + overlap, $fn=12);
        }
    } else {
        Body();
    }
    translate([4, length / 2 - 5, 1])
        cube([10, 5, 2]);
    translate([16, length / 2 - 5, 1])
        cube([20, 5, 2]);
}

module DiskPlate() {
    disk_width = 101.61;
    disk_length = 147;
    screw_x = disk_width / 2 - 3.18;
    screw_y1 = disk_length / 2 - 41.28;
    screw_y2 = screw_y1 - 44.45;
    screw_radius = 1;
    screw_height = 5;
    outer_width = 105;
    outer_length = 150;
    inner_width = 90;
    inner_length = 130;
    inner_y_offset = -2.5;
    cross_size = 10;
    overlap = 0.123456789;

    screws = [
        [-screw_x, screw_y1], [screw_x, screw_y1],
        [-screw_x, screw_y2], [screw_x, screw_y2],
    ];
    
    difference() {
        union() {
            difference() {
                square([outer_width, outer_length], center=true);
                translate([0, inner_y_offset, 0])
                    square([inner_width, inner_length], center=true);
            }
            for (i = [0 : 1]) {
                hull() {
                    translate([screws[i][0], screws[i][1], -overlap])
                        square([1, cross_size], center=true);
                    translate([screws[3 - i][0], screws[3 - i][1], -overlap])
                        square([1, cross_size], center=true);
                }
            }
        }
        for (i = [0 : 3]) {
            translate([screws[i][0], screws[i][1], -overlap])
                circle(r=screw_radius, $fn=6);
        }
        translate([0, disk_length / 2 - 5, 0])
            square([40, 10]);
    }
}

translate([0, 0, 3]) Disk(ghost=true);
linear_extrude(height=3) DiskPlate();
