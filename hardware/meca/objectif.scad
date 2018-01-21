
$fn=100;

module facade() {
	difference() {
		cylinder (d=70, h=3); // facade
		translate ([0, 0, -1]) cylinder (d=10, h=5); // trou objectif
		// trous fixation
		translate ([-12.5, -10.5, -1]) cylinder (d=2.3, h=3.5);
		translate ([-12.5, 10.5, -1]) cylinder (d=2.3, h=3.5);
		translate ([0, -10.5, -1]) cylinder (d=2.3, h=3.5);
		translate ([0, 10.5, -1]) cylinder (d=2.3, h=3.5);
		fixations();
	}
}

// indentations bague
module bague_ident() {
	for (i = [0:22.5:360] ) {
		rotate (a = [0,0,i]) translate([-1, 27, 5]) cube ([2, 12, 2]);
	}
}

module bague() {
	difference() {
		translate ([0, 0, 3]) cylinder (d=70, h=3); // facade
		translate ([0, 0, 2]) cylinder (d=60, h=5); // facade
		bague_ident();
	}

}

// trous de fixation
module fixations() {
	for (i = [0:360/3:360] ) {
		rotate (a = [0,0,i]) translate ([-25,0,-1]) cylinder (d=4, h=5);
	}
}

module logo() {
	linear_extrude(height=4) {
		import(file="logo.dxf");
	}
}

union() {
	facade();
	bague();
// 	translate ([15/2+35/2,-10,0]) rotate([0,0,90]) resize ([20,15]) logo();
}
