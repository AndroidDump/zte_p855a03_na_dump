#!/system/bin/sh

#dumpPath="/data/misc/display/zte_frame_dump_primary"
dumpPath="/data/misc/display/zte_dump_layer"
rm -rf $dumpPath/*

setprop zte.dumplayer 1
dumpsys SurfaceFlinger

cd $dumpPath

#echo $dumpPath
for dumpFile in $dumpPath/*.raw
do
  filename=${dumpFile##*/}
  echo "filename="$filename
  filename=${filename%%.raw}                                                      #remove postfix of file name

  width=${filename%x*}
  width=${width##*_}
  echo "width="$width

  height=${filename#*x}
  height=${height%%_*}
  echo "height="$height

  format=${filename#*x}                                                           #remove characters before x
  format=${format#*_}
  echo "format="$format
  format=${format##*_}
  #echo "format="$format

  outfilename=${filename#*_}																											#remove input
  if [ "$format" = "8888" ] ; then
    yuvtool G $dumpFile un_ubwc_${outfilename}.raw $width $height
  fi
  if [ "$format" = "565" ] ; then
    yuvtool B $dumpFile un_ubwc_${outfilename}.raw $width $height
  fi
done
setprop zte.dumplayer 0
