BEGIN;


INSERT INTO hydrography.osm_waterway (
    feature, osm_id, osm_class, osm_type, name, is_intermittent, is_salt, geometry)
    SELECT
        type,
        osm_id,
        class,
        type,
        name,
        is_intermittent,
        is_salt,
        geometry
    FROM public.osm_waterway;

CREATE INDEX ON hydrography.osm_waterway
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterway
    (feature);


INSERT INTO hydrography.osm_waterway_gen0 (
    feature, osm_id, osm_class, osm_type, name, is_intermittent, is_salt, geometry)
    SELECT
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        is_intermittent,
        is_salt,
        ST_SimplifyPreserveTopology(geometry, 10.0)
    FROM hydrography.osm_waterway
    WHERE feature IN ('river', 'canal');

CREATE INDEX ON hydrography.osm_waterway_gen0
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterway_gen0
    (feature);


INSERT INTO hydrography.osm_waterway_gen1 (
    feature, osm_id, osm_class, osm_type, name, is_intermittent, is_salt, geometry)
    SELECT
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        is_intermittent,
        is_salt,
        ST_SimplifyPreserveTopology(geometry, 150.0)
    FROM hydrography.osm_waterway_gen0
    WHERE feature IN ('river');


CREATE INDEX ON hydrography.osm_waterway_gen1
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterway_gen1
    (feature);


COMMIT;
