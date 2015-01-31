/*
 * Convertible Pencil Rocket / Pencil Stand
 *
 * by Alex Franke (CodeCreations), Nov 2012
 * http://www.theFrankes.com
 * 
 * Licenced under Creative Commons Attribution - Non-Commercial - Share Alike 3.0 
 * 
 * INSTRUCTIONS: Choose some values in the "User-defined values" section, render, and print. 
 * 
 * v1.00, Nov 28, 2012: Initial Release.
 *
 * TODO: 
 *   * Nothing at this time. 
 */

FIN_THICKNESS = 1;
NUMBER_OF_FINS = 3;    
FIN_INSET = 0.5;  
FIN_SCALE = 0.75; // Scale the fins larger (>1) or smaller (<1)
PENCIL_DIAMETER = 7.6;
PENCIL_BASE_THICKNESS = 2;
bandHeight = 10;   // The height of the band
bandTranslation = 8;    // The distance the band is translated toward the top of the fins

$fn = 40;   // Overall curve quality

ARRAY_BASE_CORRECTION = -1;

UP = [180,0,0];
RIGTH = [90,0,0];

module pencilRocket()
{
	rotate(UP) 
		union() 
		{
			pencilBase();	
			fins();
		}
}

module pencilBase()
{
	translate([0,0,bandTranslation]) 
				difference() 
				{
					cylinder(h=bandHeight, r=PENCIL_DIAMETER/2+PENCIL_BASE_THICKNESS);
	
					translate([0,0,(bandHeight)/2]) 
						rotate([0,0,30]) 
							nut();
	
				}
}

module fins()
{
	for( i=[0:NUMBER_OF_FINS + ARRAY_BASE_CORRECTION] ) 
	{	
		configureFin(i);
	}
}

module configureFin(finNumber)
{
	totalDegrees = 360;
	tiltZ = (totalDegrees / NUMBER_OF_FINS)* finNumber;
	tilt = [0,0,tiltZ];
	
	offsetX = PENCIL_DIAMETER / 2 + PENCIL_BASE_THICKNESS - FIN_INSET;
	offset = [offsetX, 0, 0];

	scaleMeasures = [FIN_SCALE,FIN_SCALE,1];

	rotate(tilt) 
		translate(offset) 
			rotate(RIGTH) 
				scale(scaleMeasures) 
					fin(); 
}


module fin() {
	translate([-20,-11.8,0]) 
	union() {
		difference() { 
			cylinder(h=FIN_THICKNESS, r=40, center=true);
			
			translate([0,-18,0]) 
				cylinder(h=FIN_THICKNESS+1, r=36, center=true);
	
			translate([-25,0,0]) 
				cube([90,90,FIN_THICKNESS+1], center=true);

			translate([36,-16,0]) 
				cube([10,10,FIN_THICKNESS+1], center=true);
		}

		translate([36.75,-12,0]) 
			cylinder(h=finThickness, r=2.5, center=true);
	}
}

function nutSide(diameter) = diameter * tan( 180/6 );

module nut() 
{
 	cubes = 2;

	nutHeigthCorrector = 1;

	nutHeigth = bandHeight + nutHeigthCorrector;
	side = nutSide(PENCIL_DIAMETER);

	degrees = 120;
	axisZ = [0, 0, 1];

	for ( i = [0 : cubes] ) 
	{
		rotate( i*degrees, axisZ) 
			cube( [side, PENCIL_DIAMETER, nutHeigth], center=true );
	}	
}

pencilRocket();