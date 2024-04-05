#!/bin/bash
# motomap builder script

# redirect stderr to stdout
set -o errexit
exec 2>&1

# if we are on MacOS then alias the date command to gdate
# install the coreutils package to get this: brew install coreutils

if [[ "$(uname)" == "Darwin"* ]]; then
   date() { gdate "$@"; }
fi

#record our start date/time
startDatetime=$(date)
echo "INFO: Motomap Processing - Started with design : ${MAPS_DESIGN} for ${MAPS_LIST}"
# compute uniq family-id and mapname
random_base=$((1 + RANDOM % 1000))
family_id=$(( 17000 + random_base))
map_id=$(( 63241600 + random_base))
echo "INFO: Computing uniq value : family_id = ${family_id}, map_id = ${map_id}"

# Hook selected design
sed -i "s/^style-file=.*/style-file=\/motomap\/motomap\/design\/${MAPS_DESIGN}\/style\//" /motomap/motomap/motomap.cfg

# jump into the motomap base dir so we can find all our stuff
cd /motomap/
mkdir -p output

IFS=';' read -r -a map_array <<< "${MAPS_LIST}"
echo "INFO: Motomap Processing - Get "${#map_array[@]}" maps to process ..."
for element in "${map_array[@]}"
do
    final_name=$(basename "$element")
    mkdir -p workdir
    family_id=$(( family_id + 1 ))
    map_id=$(( map_id + 1))
    echo "INFO: Motomap Processing - Processing $element (name : ${final_name^})"
    echo "INFO: family_id = ${family_id}, map_id = ${map_id}"
    echo "INFO: Motomap Processing - Download OSM map"
    curl -L --output /motomap/workdir/map.osm.pbf https://download.geofabrik.de/"$element"-latest.osm.pbf

    echo "INFO: Motomap Processing - Splitting Map"
    # split each pbf file into segments so we don't run out of memory
    # allocating max of 4G heap space
    java -Xms4G -Xmx4G -jar /motomap/splitter/splitter-r653/splitter.jar --max-nodes=1400000 --output-dir="/motomap/workdir/" /motomap/workdir/map.osm.pbf

    echo "INFO: Motomap Processing - Generating Map"
    # gen the .img file from the split files
    java -Xms4G -Xmx4G -jar /motomap/mkgmap/mkgmap-r4918/mkgmap.jar --mapname="${map_id}" --family-id="${family_id}" --family-name="Motomap - ${final_name^}" --description="Motomap - ${final_name^}" --output-dir=/motomap/workdir/ --precomp-sea=/motomap/precomp-sea/sea-latest.zip --bounds=/motomap/bounds/bounds-latest.zip --generate-sea --route --housenumbers -c /motomap/motomap/motomap.cfg /motomap/workdir/6324*.osm.pbf /motomap/motomap/design/"${MAPS_DESIGN}"/typ/mapnik.txt
    mv workdir/gmapsupp.img /motomap/output/"$final_name".img

    # clean up
    rm -rf workdir
done

# log end of processing
endDatetime=$(date)
diffSeconds="$(($(date -d "${endDatetime}" +%s)-$(date -d "${startDatetime}" +%s)))"
diffTime=$(date -d @${diffSeconds} +"%Hh %Mm %Ss" -u)
echo "INFO: Motomap Processing - Complete in $diffTime"
