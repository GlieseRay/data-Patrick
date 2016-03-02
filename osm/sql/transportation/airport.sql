BEGIN;

INSERT INTO transportation.osm_airport (
feature,
osm_class,
osm_type,
name,
iata,
icao,
scalerank,
geometry
)
SELECT
    type,
    class,
    type,
    name,
    iata,
    icao,
    12 AS scalerank,
    geometry
FROM
    public.osm_airport;

CREATE INDEX ON transportation.osm_airport
    USING gist
    (geometry);
CREATE INDEX ON transportation.osm_airport
    (feature);


COMMIT;
