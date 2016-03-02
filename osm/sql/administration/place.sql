BEGIN;

INSERT INTO administration.osm_place (
    feature, osm_id, osm_class, osm_type, name, population, is_capital, geometry)
    SELECT
        type,
        osm_id,
        class,
        type,
        name,
        population,
        is_capital,
        geometry
    FROM public.osm_place;

CREATE INDEX ON administration.osm_place
    USING gist
    (geometry);
CREATE INDEX ON administration.osm_place
    (feature);

COMMIT;
