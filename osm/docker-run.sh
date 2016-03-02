#!/usr/bin/env bash

set -e

OSM_DATA_HOME=${OSM_DATA_HOME:=/tmp/data/}

PGHOST=${PGHOST:=localhost}
PGPORT=${PGPORT:=5432}
PGUSER=${pguser:=postgres}
PGDATABASE=${PGDATABASE:=}

cat <<EOF
Loading Natural Data...

Environments:
- PGHOST: $PGHOST
- PGPORT: $PGPORT
- PGUSER: $PGUSER
- PGDATABASE: $PGDATABASE

- OSM_DATA_HOME: $OSM_DATA_HOME

EOF

if [ -z $PGDATABASE ]; then
    echo "Missing Database Name: Please set environment variable 'PGDATABASE'";
    exit 1
fi

if [ -z $PGPASSWORD ]; then
    echo "Missing Database Password: Please set environment variable 'PGPASSWORD'";
    exit 1
fi


function import_shapefile() {
    local srid=$1
    local encoding=$2
    local shapefile=$3
    local tablename=$4
    
    if [ -f $shapefile ]; then
	echo "Loading: $shapefile ..."
	shp2pgsql -s $srid -c -g geometry -D -I -W $encoding $shapefile $tablename | psql -d $PGDATABASE -w
    else
	echo "Loading: $shapefile not exists...skipped!"
    fi
}

import_shapefile 3857 'UTF-8' $OSM_DATA_HOME/osmd/water-polygons-split-3857/water_polygons.shp public.osm_ocean


echo 'Loading: Extracting data from osm...'
imposm3 import -connection postgis://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/$PGDATABASE -mapping $OSM_DATA_HOME/osm/mapping.json \
	-read $OSM_DATA_HOME/osm/osm.pbf -cachedir $OSM_DATA_HOME/osm/cache -overwritecache -write
imposm3 import -connection postgis://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/$PGDATABASE -mapping $OSM_DATA_HOME/osm/mapping.json \
    -deployproduction