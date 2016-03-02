#!/usr/bin/env bash

set -e

NATURALEARTH_DATA_HOME=${NATURALEARTH_DATA_HOME:=/tmp/data/naturalearth/}

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

- NATURALEARTH_DATA_HOME: $NATURALEARTH_DATA_HOME

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

echo 'Loading: Creating Schemas...'
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_110m_physical;"
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_110m_cultural;"
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_50m_physical;"
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_50m_cultural;"
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_10m_physical;"
psql -d $PGDATABASE -w -c "CREATE SCHEMA IF NOT EXISTS ne_10m_cultural;"


echo 'Loading: ne_110m_physical...'
for shp in $(find $NATURALEARTH_DATA_HOME/110m_physical/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_110m_physical.${tablename%.*}
done;

echo 'Loading: ne_110m_cultural...'
for shp in $(find $NATURALEARTH_DATA_HOME/110m_cultural/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_110m_cultural.${tablename%.*}
done;

echo 'Loading: ne_50m_physical...'
for shp in $(find $NATURALEARTH_DATA_HOME/50m_physical/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_50m_physical.${tablename%.*}
done;

echo 'Loading: ne_50m_cultural...'
for shp in $(find $NATURALEARTH_DATA_HOME/50m_cultural/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_50m_cultural.${tablename%.*}
done;

echo 'Loading: ne_10m_physical...'
for shp in $(find $NATURALEARTH_DATA_HOME/10m_physical/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_10m_physical.${tablename%.*}
done;

echo 'Loading: ne_10m_cultural...'
for shp in $(find $NATURALEARTH_DATA_HOME/10m_cultural/ -name *.shp); do
    tablename=$(basename $shp)
    import_shapefile 4326 'ISO-8859-1' $shp ne_10m_cultural.${tablename%.*}
done;
