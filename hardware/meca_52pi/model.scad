/* support pour picamera v2 & écran 7'' 52pi */

PARTNO = 0; // default part number

$fn=100;

module pied() {
	angle_pied = 15; // angle du pied par rapport à la verticale
	debut_attaches = 25; // hauteur (verticale) du 1er trou de maintien du support.stl
	epaisseur = 7; // epaisseur du pied

	difference() {
		linear_extrude(height=epaisseur) {
			import(file="pied.dxf");
		}

		// corps de vis du bas
		translate ([12,debut_attaches,epaisseur/2])
			rotate ([0,90,-15])
				cylinder (d=3.3, h=30, center=true);
		// tête de vis du bas
		translate ([debut_attaches*tan(angle_pied)+9,debut_attaches-0.5,epaisseur/2])
			rotate ([0,90,-15])
				cylinder (d=6, h=3, center=true);

		// corps de vis du haut
		translate ([22,debut_attaches+40*cos(angle_pied),epaisseur/2])
			rotate ([0,90,-15])
				cylinder (d=3.3, h=30, center=true);
		// tête de vis du haut
		translate ([(debut_attaches+40)*tan(angle_pied)+8,debut_attaches+39*cos(angle_pied),epaisseur/2])
			rotate ([0,90,-15])
				cylinder (d=6, h=3, center=true);
	}
} // pied()

module barre() {
	h_barre = 7;

	translate ([20,0,0]) { // excentre le support de boule
		difference() {
			// supports cotés boule
			for (i=[-1:2:1]) {
				hull() {
					translate ([i*7.5,0,10+h_barre])
						rotate ([0,90,0])
							cylinder (d=15, h=3, center=true);
					translate ([i*9,0,h_barre])
						cube([6,15,2], center=true);
				}
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
} //barre()

module support() {
	linear_extrude(height=5) {
		import(file="support.dxf");
	}
}// support()


module camera_boule() {
	difference() {
		translate ([0, 0,  5]) sphere(d=15); // shpere
		translate ([0, 0, -2]) cube ([14, 14, 4], center=true); // coupe le dessous
		translate ([0, 0,  10]) cube ([5.5, 5.5, 6], center=true); // ajoute un trou pour le pilier
	}
}//camera_boule()

module camera_support() {
		difference() {
			cube ([24, 25, 3]); // facade ppal
			translate ([10, 8, 0]) cube ([9, 9, 3]); // trou objectif
			// trous fixation
			translate ([2, 2, 0]) cylinder (d=2.3, h=3);
			translate ([2, 23, 0]) cylinder (d=2.3, h=3);
			translate ([14.5, 2, 0]) cylinder (d=2.3, h=3);
			translate ([14.5, 23, 0]) cylinder (d=2.3, h=3);
		}
		// liaison pilier
		hull() {
			translate([24, 0, 0]) cube ([2, 25, 5]);
			translate([26, 10, 0]) cube ([2, 5, 5]);
		}
		// pilier
		translate([28, 10, 0]) cube ([14, 5, 5]);
}// camera support()

// module camera pour impression
module camera() {
	translate ([0, 40, 0]) camera_boule();
	camera_support();
} //camera()

if (PARTNO == 1) pied();
if (PARTNO == 2) barre();
if (PARTNO == 3) support();
if (PARTNO == 4) camera();

// optionally use 0 for whole object, in place for viewing
if (PARTNO == 0) {
	rotate([90,0,90]) pied();
 	translate ([112,0,0]) rotate([90,0,90]) pied();
	translate ([0, 23.5, 8]) rotate([90-15,0,0]) support();
	translate ([59.5, 45, 89]) barre();
	translate ([92, 42.5, 146]) rotate([0, 90, 90]) camera_support();
	translate ([79.5, 45, 103]) camera_boule();
}
