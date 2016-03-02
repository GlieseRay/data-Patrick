#!/usr/bin/env bash

set -e

USGS_DATA_HOME=${USGS_DATA_HOME:=/tmp/data/}

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

- USGS_DATA_HOME: $USGS_DATA_HOME

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

echo 'Loading: Custom Elevation Rank...'
psql -d $PGDATABASE -w -f $USGS_DATA_HOME/elevation_rank.sql


echo 'Loading: USGS Small Scale DataSet...'
psql -d $PGDATABASE -w -c "CREATE SCHEMA usa1m;"
import_shapefile 3857 'ISO-8859-1' $USGS_DATA_HOME/countyl010g_shp_nt00964/countyl010g.shp usa1m.countyl010g
import_shapefile 3857 'ISO-8859-1' $USGS_DATA_HOME/countyp010g.shp_nt00934/countyp010g.shp usa1m.countyp010g
import_shapefile 3857 'ISO-8859-1' $USGS_DATA_HOME/statesp010g.shp_nt00938/statesp010g.shp usa1m.statesp010g


echo 'Loading: Extracting GNIS data...'
psql -d $PGDATABASE -w -c "CREATE SCHEMA gnis;"
ogr2ogr -s_srs EPSG:4269 -t_srs EPSG:3857 -f "PostgreSQL" \
    PG:"host=$PGHOST user=$PGUSER dbname=$PGDATABASE password=$PGPASSWORD" \
    /vsizip/$USGS_DATA_HOME/gnis/NationalFile_20151201.zip \
    -lco GEOMETRY_NAME=geometry \
    -lco FID=id \
    -nln "gnis.domestic_names" \
    NationalFile_20151201_PRIM


