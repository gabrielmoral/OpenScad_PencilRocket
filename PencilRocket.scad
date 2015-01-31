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

$fn = 40;

NUMBER_OF_FINS = 3;  
FIN_THICKNESS = 1;  
FIN_INSET = 0.5;  
FIN_SCALE = 0.75;

PENCIL_DIAMETER = 7.6;
PENCIL_BASE_THICKNESS = 2;
PENCIL_SUPPORT_HEIGHT = 10;

ARRAY_BASE_CORRECTION = -1;

UP_X = [180,0,0];
RIGTH_X = [90,0,0];
RIGTH_Z = [0,0,30];

module pencilRocket()
{
	rotate(UP_X) 
		union() 
		{
			pencilSupport();	
			fins();
		}
}

function half(dimension) = dimension / 2;
function radius(diameter) = half(diameter) + PENCIL_BASE_THICKNESS;

module pencilSupport()
{
	offsetZ = 8;
	supportPosition = [0,0,offsetZ];

	translate(supportPosition) 
		difference() 
		{
			cylinder(h=PENCIL_SUPPORT_HEIGHT, r=radius(PENCIL_DIAMETER));
			configureNut();
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
	
	offsetX = radius(PENCIL_DIAMETER) - FIN_INSET;
	offset = [offsetX, 0, 0];

	scaleMeasures = [FIN_SCALE,FIN_SCALE,1];

	rotate(tilt) 
		translate(offset) 
			rotate(RIGTH_X) 
				scale(scaleMeasures) 
					fin(); 
}


module fin() {
	translate([-20,-11.8,0]) 
	union() 
	{
		difference() 
		{ 
			cylinder(h=FIN_THICKNESS, r=40, center=true);
			
			translate([0,-18,0]) 
				cylinder(h=FIN_THICKNESS+1, r=36, center=true);
	
			translate([-25,0,0]) 
				cube([90,90,FIN_THICKNESS+1], center=true);

			translate([36,-16,0]) 
				cube([10,10,FIN_THICKNESS+1], center=true);
		}

		rocketSupport();
	}
}

module rocketSupport()
{	
	offset = [36.75,-12,0];

	translate(offset) 
		cylinder(h=FIN_THICKNESS, r=2.5, center=true);
}

function nutSide(diameter) = diameter * tan( 180/6 );

module configureNut()
{
	offsetZ = PENCIL_SUPPORT_HEIGHT / 2;
	offset = [0,0,offsetZ];

	translate(offset) 
		rotate(RIGTH_Z) 
			nut();	
}

module nut() 
{
 	cubes = 2;

	nutHeigthCorrector = 1;

	nutHeigth = PENCIL_SUPPORT_HEIGHT + nutHeigthCorrector;
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