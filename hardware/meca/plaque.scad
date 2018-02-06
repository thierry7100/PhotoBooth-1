/** plaque deco */

$fn = 100;

module logo() {
	translate([-14,-8,0])
		linear_extrude(height = 4)
			scale ([0.25,0.25,1])
				import (file="logo.dxf");
}

module plaque(long, larg) {
	difference() {
		resize ([long, larg, 0])
			cylinder (d=40, h=4);
		translate([0,0,2])
			resize ([long-2, larg-2, 0])
				cylinder (d=40, h=4);
	}
}

module trous(diam, long, larg) {
	pos = long/2 - 1.5*diam;
	translate([pos, 0, -1]) cylinder (d=diam, h=4);
	translate([-pos, 0, -1]) cylinder (d=diam, h=4);
}

logo();
difference() {
	plaque(40, 27);
	trous (3, 40, 27);
}
