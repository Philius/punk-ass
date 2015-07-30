$fn=64;
use <MCAD/motors.scad>

support_thickness = 10;
support_height = 499 - support_thickness*2;
support_xdelta = 70;
support_xdelta2 = support_xdelta/2;

module square_tube(len)
{
	color("silver")
		translate([5,-10,-10])
			difference() {
				cube([len-10,20,20]);
				translate([-.5,.75,.75])
					cube([len+1,18.5,18.5]);
			}
	color("black")
		translate([0,-10,-10]) {
			cube([5,20,20]);
			translate([len-5,0,0])
				cube([5,20,20]);
		}
}
//translate([-200,.75,350])
//	square_tube(400);
tube_len_x = 307;
tube_len_y = 340;
tube_len_x2 = tube_len_x + 30; // Pulley protrusion.
tube_len_x3 = tube_len_x + 47.5; // Motor protrusion.

echo("tube_len_x2",tube_len_x2);
echo("tube_len_x3",tube_len_x3);
module TopSupport(h)
{
	translate([-tube_len_x2/2,tube_len_y/2-10,h])
		square_tube(tube_len_x2);
	translate([-tube_len_x3/2,-tube_len_y/2+10,h])
		square_tube(tube_len_x3);
	rotate([0,0,90]) {
	translate([-tube_len_y/2,tube_len_x/2-10,h-20])
		square_tube(tube_len_y);
	translate([-tube_len_y/2,-tube_len_x/2+10,h-20])
		square_tube(tube_len_y);
	}
}
/*
// Print area
color("blue")
	translate([0,0,support_height-40])
		cube([210,210,5], center=true);
*/
module belt_pulley(nteeth)
{
	// Pulleys match the 2mm belt teeth length.
	c = nteeth;
	r = c / PI * 1.125;
	h=7;
	difference() {
		union() {
			translate([0,0,7]) {
				difference() {
					cylinder(r=r, h = h);
					union() {
						for(i = [0:nteeth])
							translate([r*sin(i*360/nteeth), r*cos(i*360/nteeth),-.1])
								cylinder(r=1.5, h = h+.2);
					}
				}
				translate([0,0,h])
					cylinder(r=r+0.33, h=1);
			}
			translate([0,0,7])
				cylinder(r=r+0.33, h=1);
			cylinder(r=15/2-20/36+nteeth/36, h=7);
		}
		translate([0,0,-.1])
			cylinder(r=2.5, h=h+8.2);
	}
}

module BottomSupport(h)
{
	translate([-tube_len_x/2,tube_len_y/2-10,h+20])
		square_tube(tube_len_x);
	translate([-tube_len_x/2,-tube_len_y/2+10,h+20])
		square_tube(tube_len_x);
	rotate([0,0,90]) {
	translate([-tube_len_y/2,tube_len_x/2-10,h])
		square_tube(tube_len_y);
	translate([-tube_len_y/2,-tube_len_x/2+10,h])
		square_tube(tube_len_y);
	}
}
TopSupport(support_height-support_thickness);

module rod_support(xoffs, r=5)
{
	translate([xoffs-42/2,0,0])
	difference() {
		color("silver")
		cube([42,14,32.7]);
		union() {
			translate([-1,-1,6])
				cube([13,16,32.7-6+.1]);
			translate([30,-1,6])
				cube([13,16,32.7-6+.1]);
			translate([21,15,20])
				rotate([90,0,0])
					cylinder(r=r, h = 16);
		}
	}
}
module rod_support_round(xoffs, r=5)
{
	width = 43;
	height = 24;
	depth = 10;
	translate([xoffs-42/2,0,0])
		rotate([90,90,0])
			scale([1,2,1])
				cylinder(r=height/4,h=depth);
}
module rod_supports(xoffs, r=5)
{
	rod_support(xoffs, r);
	translate([0,tube_len_y-40-14,0])
		rod_support(xoffs, r);
}
translate([0,20-tube_len_y/2,support_height-20])
	rod_supports(tube_len_x/2-10);
translate([0,20-tube_len_y/2,support_height-20])
	rod_supports(-tube_len_x/2+10);

ycarriage_zdelta = -30;
yrod_length = 300;
yrod_radius = 5;
yrod_zoffset = 0;
yrod_xoffset = tube_len_x/2-10;

// Y motors
ymotor_xoffset = tube_len_x3/2 - 20;
ymotor_yoffset = -tube_len_y/2 - 20;
ymotor_zoffset = support_height;
translate([-ymotor_xoffset, ymotor_yoffset, ymotor_zoffset])
	rotate([0,0,0]) {
		stepper_motor_mount(17);
		color("orange")
			translate([0,0,9])
				rotate([0,0,0])
					belt_pulley(20);
	}
translate([ymotor_xoffset, ymotor_yoffset, ymotor_zoffset])
	rotate([0,0,0]) {
		stepper_motor_mount(17);
		color("orange")
			translate([0,0,9])
				rotate([0,0,0])
					belt_pulley(20);
	}
// Y rods
module y_rod()
{
	rotate([90,0,0]) {
		color("green")
			cylinder(r=yrod_radius, h = yrod_length, center=true);
		color("silver") {
			translate([0,0,-42/2-29/2])
				cylinder(r=19/2, h = 29);
			translate([0,0,42/2-29/2])
				cylinder(r=19/2, h = 29);
		}
	}
}
translate([yrod_xoffset,0,support_height+yrod_zoffset])
	y_rod();
translate([-yrod_xoffset,0,support_height+yrod_zoffset])
	y_rod();

BottomSupport(support_thickness);
BottomSupport(support_thickness*2 + 50);

zrod_length = 499;
zrod_radius = 5;
zrod_zoffset = 0;
zrlx = tube_len_x/2-10;
zrly = tube_len_y/2-10;
zrld = 20;
// Z threaded rods
color("silver") {
translate([-zrlx,-zrly,0])
	cylinder(r=zrod_radius, h = zrod_length);
translate([zrlx, -zrly,0])
	cylinder(r=zrod_radius, h = zrod_length);
translate([-zrlx, zrly, 0])
	cylinder(r=zrod_radius, h = zrod_length);
translate([zrlx, zrly, 0])
	cylinder(r=zrod_radius, h = zrod_length);
}

zsr1x = -zrlx+zrld; zsr1y = -zrly;
zsr2x =  zrlx-zrld; zsr2y = -zrly;
zsr3x = -zrlx+zrld; zsr3y = zrly;
zsr4x = zrlx-zrld; zsr4y = zrly;
// Z smooth rods
// translate([zsr1x, zsr1y, 0])
// 	cylinder(r=zrod_radius, h = zrod_length);
// translate([zsr2x, zsr2y, 0])
// 	cylinder(r=zrod_radius, h = zrod_length);
// translate([zsr3x, zsr3y, 0])
// 	cylinder(r=zrod_radius, h = zrod_length);
// translate([zsr4x, zsr4y, 0])
// 	cylinder(r=zrod_radius, h = zrod_length);
/*
translate([0,0,250-6-6-24/2]) {
translate([zsr1x, zsr1y, 0])
	cylinder(r=15/2, h = 24);
translate([zsr2x, zsr2y, 0])
	cylinder(r=15/2, h = 24);
translate([zsr3x, zsr3y, 0])
	cylinder(r=15/2, h = 24);
translate([zsr4x, zsr4y, 0])
	cylinder(r=15/2, h = 24);
}
*/
/*
DRV8823-Q1 can control 2 stepper motors.
It can be updated about 100,000 times/sec via SPI.
It's PWM current control only updates @ 50kHz.
If we aim for 5000 updates/sec, what's our resolution/speed?
For a resolution of 0.05mm/step our speed is limited to
  5000x0.05 = 250mm/sec. Now that's off scale fast!
As a bonus, if there's some way to calibrate any x/y drift as a function of Z
then yay!
Maybe some rig involving SMD red leds and lasers would look way cool, but there
may also be some rotation around the Z axis to consider.
*/

// X rods
xrod_radius = 4;
xrod_length = 300;
/* The 8mm linear bearing diameter is 15, the 10mm one d=19. */
xrod_zoffset = 20+19/2;
xrl2 = xrod_length/2; // Extreme limit.
xdist = 21;
xdist2 = xdist/2;
color("red") rotate([0,0,90]) {
	translate([xdist,xrl2,support_height+xrod_zoffset])
		rotate([90,0,0])
		cylinder(r=xrod_radius, h = xrod_length);
	translate([-xdist,xrl2,support_height+xrod_zoffset])
		rotate([90,0,0])
		cylinder(r=xrod_radius, h = xrod_length);
}
rotate([0,0,90]) {
	translate([0,20-tube_len_y/2,support_height+xrod_zoffset-20])
		rod_supports(-21, 4);
	translate([0,20-tube_len_y/2,support_height+xrod_zoffset-20])
		rod_supports(21,4);
}
// Glass print bed.
translate([-tube_len_x/2,-tube_len_y/2,250])
	%cube([tube_len_x, tube_len_y,6]);

// Motor bracket import test.
//translate([-21, -21,support_height])
module motor_bracket()
{
	translate([-297/2, -210.0/2,0])
	linear_extrude(height = 5, convexity = 10)
		import("motor-bracket.dxf");
}
translate([-ymotor_xoffset, ymotor_yoffset, ymotor_zoffset])
	motor_bracket();
translate([ymotor_xoffset, ymotor_yoffset, ymotor_zoffset])
	motor_bracket();
