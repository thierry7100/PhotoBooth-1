$fn = 100;

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

