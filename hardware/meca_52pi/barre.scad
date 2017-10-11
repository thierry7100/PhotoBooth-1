h_barre = 7;

$fn=100;

translate ([20,0,0]) { // excentre le support de boule
	difference() {
		// supports cotés boule
		for (i=[-1:2:1]) {
			translate ([i*9,0,10+h_barre])
				rotate ([0,90,0])
					cylinder (d=15, h=6, center=true);
			translate ([i*9,0,5+h_barre])
				cube([6,15,10], center=true);
		}
		//boule a enlever
		translate ([0,0,12+h_barre])
			sphere(d=14.5,center=true);
	}
}

difference(){
	// barre de support
	translate ([0,0,h_barre/2])
		cube([105, 15, h_barre], center=true);

	// trous de vis
	for (i=[-1:2:1]) {
		translate ([i*50,5,h_barre/2])
			rotate([0,90,0])
				cylinder(d=3, h=10, center=true);
	}
	translate ([-22,2.5,h_barre/2])
		cube ([44,10,h_barre], center=true);
}

