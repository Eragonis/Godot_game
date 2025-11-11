[Aseprite](https://www.aseprite.org/) <br>
[Piskel](https://www.piskelapp.com/) <br>
[GraphicsGale](https://graphicsgale.com/us/) <br>
[Pixel Art](https://pixelartmaker.com/) <br>
[Image to Pizel](https://pixelartvillage.com/)
[pixel Tutreal](https://www.deviantart.com/sadfacerl/gallery/all?page=10)

# Godot projekt

## ideen suche
- Godot
- Character
    - Maid
    - 9 schwänziger fuchs mit tranformation
# 🎨 Detailliertes Sprite-Sheet Konzept (als Text-Blaupause)

Ziel: Ein einziges Sprite-Sheet, 64x64 Pixel pro Frame, 8 Zeilen x 8 Spalten (maximal).

Charakter: Fuchs-Mädchen, Maid-Outfit, weiß/silbernes Fell, blaue Augen (normal), rote Augen (transformiert), 9 Schwänze.

Reihe 0: Idle (Normal) - (4 Frames)

    Frame 0: Charakter steht ruhig, leichte "Atem"-Bewegung. Weiße Schwänze wippen minimal. (Wie Ihr Original-Frame 0, aber leicht animiert)

    Frame 1: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

    Frame 2: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

    Frame 3: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

Reihe 1: Transformation - (6 Frames)

    Frame 0: Charakter normal.

    Frame 1: Erste Anzeichen der Transformation (Augen werden rötlich, leichte Narben).

    Frame 2: Stärkere Narben, Augen leuchten rot, Schwänze beginnen rot zu werden.

    Frame 3: Vollständig transformiert, rote Schwänze, Narben, rote Augen (wie Ihr Original-Frame 6).

    Frame 4: Wie Frame 3, aber eine weitere Bewegung in der Transformation.

    Frame 5: Wie Frame 3, aber eine weitere Bewegung in der Transformation.

Reihe 2: Idle (Transformed) - (4 Frames)

    Frame 0: Charakter steht ruhig, aggressive/mystische Haltung. Rote Schwänze wippen minimal, rote Augen. (Wie Ihr Original-Frame 6, aber leicht animiert)

    Frame 1: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

    Frame 2: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

    Frame 3: Wie Frame 0, aber leicht andere Haltung/Schwanzposition.

Reihe 3: Walk (Normal) - (8 Frames)

    Frame 0-7: Ein kompletter 8-Frame-Gehzyklus.

        Figuren-Haltung: Aufrecht, Arme und Beine schwingen natürlich.

        Schwänze: Folgen der Körperbewegung, wippen mit.

        Augen: Blau.

        Füße: Deutlich der Bodenkontakt und das Abheben der Füße.
Reihe 4: Walk (Transformed) - (8 Frames)

    Frame 0-7: Ein kompletter 8-Frame-Gehzyklus im transformierten Zustand.

        Figuren-Haltung: Kann aggressiver oder schneller wirken.

        Schwänze: Rot, folgen der Körperbewegung, können dynamischer wirken.

        Augen: Rot.

Reihe 5: Jump (Normal) - (4 Frames)

    Frame 0 (Jump Start): Knie leicht gebeugt, Hände können leicht angehoben sein (Vorbereitung).

    Frame 1 (Jump Air): Charakter in der Luft, Beine leicht angewinkelt, Schwänze nach hinten/unten.

    Frame 2 (Jump Peak/Fall): Charakter erreicht Höhepunkt, beginnt zu fallen, Körper leicht gestreckt.

    Frame 3 (Jump Land): Charakter landet, Knie leicht gebeugt beim Aufprall.

Reihe 6: Jump (Transformed) - (4 Frames)

    Frame 0-3: Die gleiche Sprungsequenz wie oben, aber im transformierten Zustand (rote Augen, rote Schwänze, ggf. aggressivere Haltung).

Reihe 7: Death - (6 Frames)

    Frame 0: Charakter bricht zusammen (ähnlich Ihrem Original-Frame 7 unten links).

    Frame 1: Charakter liegt am Boden, kann leicht animiert werden (z.B. zucken).

    Frame 2: Charakter beginnt leicht zu verblassen (Transparenz nimmt zu).

    Frame 3: Charakter ist zur Hälfte verblasst.

    Frame 4: Nur noch ein schemenhafter Umriss.

    Frame 5: Charakter ist vollständig verschwunden.
