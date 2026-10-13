// =====================================================================
//  iPod touch 6 – "Alarmy-Lock-Case"
//  Gehäuse, das den Power-Knopf (Standby/Ein-Aus) vollständig abdeckt,
//  Kamera, Display, Home-Button und Lightning/Kopfhörer frei lässt und
//  nach dem Zusammenstecken nicht mehr zerstörungsfrei geöffnet werden kann.
//
//  Zwei Teile:
//    1) Schale  (part = "tray") – Rücken, Seiten, Oberkante, Frontrahmen
//    2) Deckel  (part = "cap")  – Unterkante mit Port-Öffnung + 2 Schnapp-
//                                  zungen, die in Kanälen INNERHALB der
//                                  Seitenwände einrasten (von außen nicht
//                                  erreichbar).
//
//  Koordinaten: x = Breite, y = Länge (y=0 Unterkante / Lightning),
//               z = Dicke (z=0 Rückseite, z=H Display-Seite).
//  Blick von vorne (aufs Display): x nach rechts, y nach oben.
// =====================================================================

part = "both";            // "tray", "cap", "both" (Druckplatte), "assembled" (Vorschau)

/* ---------- iPod touch 6 (Apple-Datenblatt) ---------- */
dev_w = 58.6;             // Breite
dev_l = 123.4;            // Höhe
dev_t = 6.1;              // Dicke
dev_r = 8.0;              // Eckenradius (ca.)

/* ---------- Toleranzen ---------- */
clr   = 0.30;             // seitliches Spiel je Seite
clr_l = 0.40;             // Spiel in der Länge (gesamt)
clr_t = 0.40;             // Spiel in der Dicke (gesamt)

/* ---------- Wandstärken ---------- */
wall  = 4.0;              // Seiten- und Oberwand (enthält die Schnappkanäle)
fl    = 1.6;              // Rückwand
lip_t = 1.4;              // Dicke Frontrahmen
lip   = 2.5;              // wie weit der Frontrahmen übers Glas greift
end_t = 3.0;              // Dicke Deckel (Unterkante)
shelf = 1.2;              // Boden-Absatz der Schale unter dem Deckel

/* ---------- Kamera (Rückseite) ----------
   Von hinten gesehen oben links = von vorne gesehen oben rechts.
   Maße = Abstand vom Geräte-Rand (rechts) bzw. von der Oberkante.     */
cam_x_from_edge = [2.5, 26];   // von .. bis (mm vom rechten Rand, Frontansicht)
cam_y_from_top  = [2.5, 18];   // von .. bis (mm von der Oberkante)
cam_r           = 5.5;
cam_chamfer     = true;        // Fase nach außen -> kein Vignettieren

/* ---------- Power-Knopf (Oberkante, rechts) ----------
   Innen eine Tasche, damit Druck aufs Case den Knopf NICHT auslöst.   */
pwr_x_from_edge = [6, 34];     // mm vom rechten Rand
pwr_depth       = 1.2;

/* ---------- Lautstärketasten (linke Seite) ----------
   Standard: abgedeckt (sonst kann man den Wecker leiser drehen).
   Innen ebenfalls eine Freitasche, damit sie nicht dauerhaft gedrückt sind. */
vol_open        = false;       // true = Öffnung statt Abdeckung
vol_y_from_top  = [10, 55];
vol_depth       = 1.0;

/* ---------- Unterkante: Lightning, Kopfhörer, Lautsprecher ---------- */
port_margin = 7.0;             // Abstand der Öffnung von der Außenkante (x)
port_h      = 5.6;             // Höhe der Öffnung (z)

/* ---------- Schnappzungen ---------- */
tng_len  = 14;            // Länge der Zunge
tng_x    = 1.2;           // Stärke (Biegerichtung)
tng_z    = 4.0;           // Höhe
hook_h   = 0.5;           // Hakenüberstand
hook_l   = 2.4;           // Hakenlänge (inkl. Rampe 1.8)
s_clr    = 0.15;          // Spiel im Kanal
ch_out   = 0.7;           // Restwand außen am Kanal

$fn = 64;

/* ---------- abgeleitete Maße ---------- */
cav_w = dev_w + 2*clr;
cav_l = dev_l + clr_l;
cav_t = dev_t + clr_t;
cav_r = dev_r + clr;
W  = cav_w + 2*wall;
L  = end_t + cav_l + wall;
H  = fl + cav_t + lip_t;
cx0 = wall;  cx1 = wall + cav_w;          // Innenraum x
cy0 = end_t; cy1 = end_t + cav_l;         // Innenraum y
cz0 = fl;    cz1 = fl + cav_t;            // Innenraum z
R_top = cav_r + wall;                     // äußerer Radius oben
R_bot = 2.0;                              // äußerer Radius unten (eckiger, damit der Einschub passt)

echo(str("Außenmaße: ", W, " x ", L, " x ", H, " mm"));

// 2D-Rechteck mit unterschiedlichen Radien unten/oben
module rr(x0, y0, x1, y1, rb, rt) {
    hull() {
        for (p = [[x0, y0, rb], [x1, y0, rb], [x0, y1, rt], [x1, y1, rt]]) {
            r = p[2];
            if (r > 0.01)
                translate([p[0] + (p[0] == x0 ? r : -r), p[1] + (p[1] == y0 ? r : -r)]) circle(r = r);
            else
                translate([p[0] - (p[0] == x0 ? 0 : 0.01), p[1] - (p[1] == y0 ? 0 : 0.01)]) square(0.01);
        }
    }
}

module outer2d() { rr(0, 0, W, L, R_bot, R_top); }

// Schnappkanal + Zunge, für die linke Seite definiert, rechts gespiegelt
x_t   = ch_out + hook_h + s_clr;      // Außenkante der Zunge (Ruhelage)
y_tip = end_t + tng_len;
y_ret = y_tip - hook_l;               // Haltefläche des Hakens

module channel_left() {
    // Einführbereich: Zunge + Platz zum Ausweichen nach innen
    translate([x_t - s_clr, end_t - 1, shelf])
        cube([tng_x + hook_h + 2*s_clr, (y_ret - 0.15) - (end_t - 1), tng_z + 0.25]);
    // Rastkammer (innenliegend, von außen unerreichbar)
    translate([ch_out, y_ret - 0.15, shelf])
        cube([x_t + tng_x + hook_h + s_clr - ch_out, y_tip + 0.4 - (y_ret - 0.15), tng_z + 0.25]);
}

module tongue_left() {
    translate([x_t, end_t - 0.01, shelf]) cube([tng_x, tng_len + 0.01, tng_z]);
    // Haken: Rampe zur Spitze, senkrechte Haltefläche
    translate([0, 0, shelf])
        linear_extrude(tng_z)
            polygon([[x_t + 0.01, y_tip], [x_t - hook_h, y_tip - 1.8],
                     [x_t - hook_h, y_ret], [x_t + 0.01, y_ret]]);
}

module both_sides() { children(); translate([W, 0, 0]) mirror([1, 0, 0]) children(); }

/* ================= SCHALE ================= */
module tray() {
    difference() {
        linear_extrude(H) outer2d();

        // Deckelbereich (über dem Boden-Absatz)
        translate([-1, -1, shelf]) cube([W + 2, end_t + 1, H]);

        // Innenraum: oben gerundet, unten gerade und offen zum Einschieben
        translate([0, 0, cz0]) linear_extrude(cav_t)
            union() {
                rr(cx0, cy0, cx1, cy1, 0, cav_r);
                translate([cx0, cy0 - 2]) square([cav_w, cav_r + 2]);
            }

        // Displayfenster
        translate([0, 0, cz1 - 0.01]) linear_extrude(lip_t + 1)
            rr(cx0 + lip, cy0 + lip, cx1 - lip, cy1 - lip, cav_r - lip, cav_r - lip);

        // Kamera
        cam_x0 = cx1 - clr - cam_x_from_edge[1];
        cam_x1 = cx1 - clr - cam_x_from_edge[0];
        cam_y0 = cy1 - cam_y_from_top[1];
        cam_y1 = cy1 - cam_y_from_top[0];
        hull() {
            translate([0, 0, fl - 0.01]) linear_extrude(1)
                rr(cam_x0, cam_y0, cam_x1, cam_y1, cam_r, cam_r);
            c = cam_chamfer ? fl : 0;
            translate([0, 0, -1]) linear_extrude(1.01)
                rr(cam_x0 - c, cam_y0 - c, cam_x1 + c, cam_y1 + c, cam_r + c, cam_r + c);
        }

        // Freitasche Power-Knopf (Oberkante) – Wand bleibt geschlossen
        translate([cx1 - clr - pwr_x_from_edge[1], cy1 - 0.1, cz0 + 0.8])
            cube([pwr_x_from_edge[1] - pwr_x_from_edge[0], pwr_depth + 0.1, cav_t - 1.6]);

        // Lautstärketasten (linke Seite, Frontansicht)
        if (vol_open)
            translate([-1, cy1 - vol_y_from_top[1], cz0 + 0.8])
                cube([wall + 2, vol_y_from_top[1] - vol_y_from_top[0], cav_t - 1.6]);
        else
            translate([cx0 - vol_depth, cy1 - vol_y_from_top[1], cz0 + 0.8])
                cube([vol_depth + 0.1, vol_y_from_top[1] - vol_y_from_top[0], cav_t - 1.6]);

        // Schnappkanäle in beiden Seitenwänden
        both_sides() channel_left();
    }
}

/* ================= DECKEL ================= */
module cap() {
    difference() {
        intersection() {
            linear_extrude(H) outer2d();
            translate([-1, -1, shelf]) cube([W + 2, end_t + 1 - 0.0, H]);
        }
        // Öffnung für Lightning, Kopfhörer und Lautsprecher
        pz = cz0 + cav_t / 2;
        hull() for (x = [port_margin + port_h/2, W - port_margin - port_h/2])
            translate([x, -1, pz]) rotate([-90, 0, 0]) cylinder(d = port_h, h = end_t + 2);
    }
    both_sides() tongue_left();
}

/* ================= Ausgabe ================= */
if (part == "tray") tray();
else if (part == "cap")
    // Druckausrichtung: Rückseite nach unten, Zungen liegen flach auf dem Bett
    translate([0, 0, -shelf]) cap();
else if (part == "assembled") {
    color("SteelBlue") tray();
    color("Orange") cap();
}
else if (part == "both") {
    tray();
    translate([W + 8, 0, -shelf]) cap();
}
