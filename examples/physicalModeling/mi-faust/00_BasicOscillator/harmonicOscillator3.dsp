declare name    "Harmonic Oscillator v3";
declare author  "James Leonard";
declare date    "April 2020";

/* ========= DESCRITPION =============

The simplest mass-interaction construct: a harmonic oscillator, built by assembling four elements: 
a mass, a fixed point and a spring and a damper interaction.
The resulting model is identical to an mi.osc element (which integrates them together).
    - inputs: force impulse
    - outputs: oscillator' position.
    - controls: none.
*/

import("stdfaust.lib");
import("mi.lib");

in1 = button("Frc Input 1"): ba.impulsify * 0.25;  	//write a specific force input signal operation here

OutGain = 1;

model = (
	mass(1., 0, 0., 0.),
	ground(0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	spring(0.1, 0., 0.),
	damper(0.0003, 0., 0.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1) = /* routed positions */ m1, m0, m1, m0, /* outputs */ m0;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, p_out1, f_in1) = /* routed forces  */ f_in1 + l0_f2 + l1_f2, l0_f1 + l1_f1, /* pass-through */ p_out1;
	nbMass = 2;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);


/*
========= MIMS SCRIPT USED FOR MODEL GENERATION =============

# MIMS script file
# Script author: James Leonard

# Assembled harmonic oscillator with M = 1, K = 0.1, Z = 0.0003
@m mass 1. 0. 0.
@g ground 0.
@s spring @g @m 0.1
@d damper @g @m 0.0003

# Add force input to the model
@in1 frcInput @m

# Add position output from the oscillator
@out1 posOutput @m


# end of MIMS script

*/