# RepRap Chinampa

Passive self-watering 3D-printable floating vegetable pot, inspired by the chinampa (floating garden bed).

## 3D Printing Notes

### 3D Printer (Hardware) Configuration/Modifications

The models have been successfully printed in Natural PLA on a Prusa Mk3S+ using a 0.4mm nozzle with an upgraded part cooling duct (See https://www.printables.com/model/906613-highv-part-cooling-duct-for-prusa-i3-mk3s)

**NOTE**: The standard brass nozzle is **not considered food-safe**, as it wears out. A stainless-steel or titanium nozzle is recommended if you are even considering printing with food in mind.<sup>[1](#footnote1)</sup>

### Print Profile / Slicing

The models have been successfully printed using the following profile with "vase mode" enabled. Note that the profile is for a 0.8 mm nozzle, but have been physically tested on a 0.4 mm nozzle.

    Nozzle diameter: 0.8 mm nozzle
    Layer height: 0.3 mm
    Top fill pattern: Concentric
    Bottom fill pattern: Concentric
    Infill speed: 5 mm/s
    Solid infill speed: 5 mm/s
    Top solid infill speed: 5 mm/s
    First layer speed: 5 mm/s
    Max print speed: 30 mm/s
    Overhang speed:
        0% overlap(bridge): 15 mm/s
        25% overlap: 1 mm/s
        50% overlap: 1 mm/s
        75% overlap: 2 mm/s
    Extrusion multiplier: 1.2
    Nozzle temperature:
        First layer: 230 C
        Other layers: 230 C
    Bed temperature:
        First layer: 60 C
        Other layers: 60 C
    Fan speed:
        Min: 100%
        Max: 100%
    Lift height: 0.8 mm

## Attributions

This project was either built on or inspired by the works of

- *Chinampas* pioneered by the native Aztec tribes and farmlands of southwestern region of the Valley of Mexico
- [Self-watering rectangular planter](https://www.printables.com/model/57885-self-watering-rectangular-planter-with-optional-la)
- [Avocado Boat - minimalistic](https://www.printables.com/model/179070-avocado-boat-minimalistic-vase-mode)
- [Parametric Net Pot (CC-BY-SA-3.0)](https://www.thingiverse.com/thing:790339)
- [The RepRap movement](https://reprap.org/)

---
This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/)

[![CC-BY-SA 4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-sa/4.0/)

<a name="footnote1">1</a>: https://help.prusa3d.com/article/food-safe-fdm-printing_112313
