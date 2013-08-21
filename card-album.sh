#!/bin/bash

imgs="*.JPG"
bkgnd="PIC_2119.JPG"
width=800
height=600
output="test.swf"

pushd .
lst=$(ls ${imgs})
tmpdir=/tmp/$$
echo $tmpdir
mkdir $tmpdir
for ff in ${lst}
do
  echo "Resizing $ff"
  convert ${ff} -thumbnail ${width}x${height} -border 2 ${tmpdir}/${ff}
done
cd $tmpdir
echo "Processing background image..."
convert ${bkgnd} -emboss 50 -modulate 50,20,0 _
echo ".flash bbox=\"${width}x${height}\" version=6 fps=30 name=\"${output}\" compress" >> album.sc
echo "  .jpeg background \"_\"" >> album.sc
echo "  .put background x=0 y=0" >> album.sc
count=0
for ff in $lst
do
  echo "  .jpeg pic${count} ${ff}" >> album.sc
  ((count++))
done

frame=1
((x=width/8))
((y=height/8))
rot=0
idx=$count
while ((idx--))
do
  echo "  .frame $frame" >> album.sc
  echo "  .put pic${idx} x=${x} y=${y} scale=25% rotate=${rot} pin=center" >> album.sc
  ((rot+=9))
  ((x+=width/32))
  ((y+=height/32))
  ((frame+=30))
done

((cx=width / 2))
((cy=height / 2))
for ((idx=0; idx<count; idx++))
do
  ((rot-=9))
  ((x -= width / 32))
  ((y -= height / 32))
  echo "  .frame $frame" >> album.sc
  echo "  .move pic$idx x=$x y=$y" >> album.sc
  echo "  .change pic$idx scale=25% rotate=$rot alpha=100%" >> album.sc
  ((frame += 30))
  echo "  .frame $frame" >> album.sc
  echo "  .move pic$idx x=$cx y=$cy" >> album.sc
  echo "  .change pic$idx scale=100% rotate=0 alpha=100%" >> album.sc
  ((frame += 100))
  echo "  .frame $frame" >> album.sc
  echo "  .move pic$idx x=$cx y=$cy" >> album.sc
  echo "  .change pic$idx scale=100% rotate=0 alpha=100%" >> album.sc
  ((frame += 30))
  echo "  .frame $frame" >> album.sc
#		puts $ff "  .move pic$idx x=[expr $width - $x] y=[expr $height - $y]"
  echo "  .change pic$idx scale=25% rotate=-90 alpha=0%" >> album.sc
  ((frame ++))
done
echo ".end" >> album.sc
echo "Generating swf file..."
swfc $tmpdir/album.sc
popd
mv ${tmpdir}/${output} .
rm -rf $tmpdir


