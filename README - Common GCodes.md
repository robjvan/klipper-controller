# Common G-Code Commands

## Cooldown (turn off fans)

M107

## Home

G28 X Y Z

## Move toolhead (travel)

G0 X<pos> Y<pos> Z<pos> E<speed> F<speed>

## Move toolhead

G1 X<pos> Y<pos> Z<pos> E<speed> F<speed>

## Extrude filament

## Turn off motors

M84

## Set relative coordinates

G91

## Set absolute coordinates

G90

## Set acceleration

M204 S<value>

## Get extruder temp

M105

## Set extruder temp

M104 T<index> S<temperature>

## Set bed temp

M140 S<temperature>

## Set extruder temp and wait

M109 T<index> S<temperature>

## Set bed temp and wait

M190 S<temperature>

## Set fan speed

M106 S<value>

## Emergency stop

M112
