// support ecran+carte
$fn=100;

// crochet pour retenir l'écran
module crochet() {
	translate ([0,0, 0]) cube ([5, 9, 5]);
	translate ([5,4,0])  cube ([5, 5, 5]);
}

// attaches vers le boitier
module attache() {
	difference() {
		translate ([0,-25,0]) cube ([12, 25, 15]);
		translate([6,0,10]) rotate([90,0,0]) cylinder(d=4, h=27);
	}

}

// trous d'attache pour la carte
module carte() {
rotate([90,0,0]) cylinder (d=3, h=7);
translate([59,0,0]) rotate([90,0,0]) cylinder (d=3, h=7);
}

// support
module support() {
	union() {
		difference() {
			cube ([110, 5, 5]); // barre ppale
			translate ([25,0,0]) cube ([15, 5, 5]);
			translate ([85,0,0]) cube ([15, 5, 5]);
		}
		difference () { // barre d'écartement
			translate ([0,-5,0]) cube ([110, 5, 5]);
			translate([32.5, 0, 2.5]) carte();
		}
		translate([0,0,0]) attache();
		translate([98,0,0]) attache();
		translate ([0,5,0]) crochet();
		translate([110,5,0]) mirror ([1,0,0]) crochet();
	}
}

support();
// 2eme support avec decoupe pour prise d'alim
translate([0,40,0]) {
	difference() {
		support();
		translate([95,-25,5]) cube ([20,25,16]);
	}
}
