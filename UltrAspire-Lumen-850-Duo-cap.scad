// Protective Cap for UltrAspire Lumen 850 Duo - Prevents Accidental button presses

// Features:
// - External rim at bottom (grip)
// - Internal retention rim near the open top, protruding inside the cap.  This clicks over the body of the light

// Version 3 - VLo code refactor

// Include BOSL2 library (requires downloading BOSL2 files)
include <BOSL2/std.scad>

facets                  = 100;      // Number of facets to render
inner_diameter          = 24.8;     // mm - nominal inner diameter (fits over light body)
wall_thickness          = 1.6;      // mm - sidewall thickness
light_length            = 13.5;     // mm - depth that slips over the body and allows click retention
bottom_thickness        = 3.0;      // mm - fully solid flat lid thickness
bottom_standoff_height  = 3.0;      // mm - inner standoff to prevent the part from being able to touch the light's button
bottom_standoff_dia     = 3.0;      // mm - inner standoff diameter
clearance               = 0.25;     // mm - base inner clearance (tolerance adjustment)
outer_diameter          = inner_diameter + 2 * wall_thickness;	// Calculation of outer diameter

// Rim parameters
rim_thickness           = 1.6;      // mm - vertical height of both rims (external grip and internal retention)
outer_rim_diameter      = 2.8;      // mm - Outer rim Diameter
internal_protrusion     = 0.4;      // mm - how far the internal rim extends inward
total_height            = bottom_thickness + bottom_standoff_height + light_length + rim_thickness;     // mm - overall part height

// Positions
external_rim_pos  = 0;              // Bottom Grab ring location
internal_rim_pos  = total_height - rim_thickness;     // Inner Retention ring near top

// Bottom Torus
r1=18.8;
r2=3;

// Top Torus
r3=16.4;
r4=3;

// Main structure
union() {

    difference() {
        // Outer body + solid lid
        cylinder(h = total_height, d = outer_diameter, $fn = facets);
        
        union() {
            // Hollow out the main inner cavity
            translate([0, 0, bottom_thickness + bottom_standoff_height])
                cylinder(h = light_length + .1, d = inner_diameter + clearance, $fn = facets);
            
            // Hollow out an inner cavity to create a inner ring on the cap side
            translate([0, 0, bottom_thickness])
                cylinder(h = total_height, d = inner_diameter - bottom_standoff_dia + clearance, $fn = facets);
            
            // Hollow out an inner cavity to create the retention ring on the inside
            translate([0, 0, bottom_thickness + bottom_standoff_height])
                cylinder(h = total_height - rim_thickness, d = inner_diameter - internal_protrusion + clearance, $fn = facets);
            
            // Round the opening to make the cap easier to put on the light
            translate([0, 0, total_height + 4.8])
                sphere(d = inner_diameter +2.2, $fn = facets);
            
            // Torus to chamfer the edge of protrusion
            translate([0, 0, total_height + 1.4])
                torus(r3, r4, $fn=facets);
            
        }
    }
    
    // External rim at bottom (outward protrusion)
    difference() {
        // (outward protrusion)
        translate([0, 0, external_rim_pos])
            rotate_extrude($fn = facets)
                offset(r = -0.01)                     // small negative offset for manifold helper
                translate([outer_diameter/2, 0, 0])
                    square([outer_rim_diameter, rim_thickness]);

        // Torus to chamfer the edge of protrusion
        translate([0, 0, 3.5])
            torus(r1, r2, $fn=facets);
    }

}


/* PRINT RECOMMENDATIONS (TPU):
 - Print flat on open end (external rim down, lid up)
 - No supports needed — internal rim is short and near top
 - Infill: 30-50% gyroid (flexible + strong)
 - Walls/perimeters: 5–6 for good rim definition
 - Speed: 20–30 mm/s, slight over-extrusion (105%) helps snap strength
 - Test: The internal rim should give a satisfying "click" when fully seated
*/
