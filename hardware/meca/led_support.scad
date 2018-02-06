/** attache sur pied micro */

$fn=100;

// base
base_diam = 60; // diametre du bas
base_haut = 5; // hauteur

// support
sup_larg = 35; // largeur
sup_haut = 40; // hauteur totale
sup_ep = 5; // epaisseur au plus fin (en haut)
sup_trou = 8.5; // diametre du trou de vis
sup_int = 8; // interval entre les 2 supports

// base
module base () {
	cylinder (d1=base_diam, d2=base_diam-2, h=base_haut);
}

// 1 support
module support() {
	difference() {
		hull() {
			translate([-1,0,0]) cube ([sup_haut-sup_larg+1, sup_larg, sup_ep+2]); // base du support
			translate([sup_haut-sup_larg/2,sup_larg/2,0]) cylinder (d=sup_larg, h=sup_ep); // haut du support
		}
		translate([sup_haut-sup_larg/2,sup_larg/2,-1]) cylinder (d=sup_trou, h=sup_ep+4); // trou de fixation
	}
}

// objet complet
difference() {
	union() {
		base();
		translate([(sup_int/2),sup_larg/2,base_haut]) rotate([0,-90,180]) support();
		translate([-(sup_int/2),-sup_larg/2,base_haut]) rotate([0,-90,0]) support();
	}
	// trous de fixation de la base
	for (i = [0:360/4:360] ) {
		rotate (a = [0,0,i]) translate ([base_diam/3, 0, -1]) cylinder (d=4, h=base_haut+2);
	}
}
