#!/bin/sh

svg2dxf () {
inkscape -E /dev/stdout $1 | pstoedit -dt -f 'dxf:-polyaslines -mm' - ${1%svg}dxf
}

# create dxf from svg
svg2dxf pied.svg
svg2dxf support.svg

# export parts as STL
openscad -DPARTNO=1 -o pied.stl model.scad
openscad -DPARTNO=2 -o barre.stl model.scad
openscad -DPARTNO=3 -o support.stl model.scad
openscad -DPARTNO=4 -o camera.stl model.scad
openscad -DPARTNO=5 -o camera_support.stl model.scad


# export image of all the parts combined
openscad -DPARTNO=0 -o model.png model.scad
