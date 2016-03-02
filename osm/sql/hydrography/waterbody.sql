BEGIN;

INSERT INTO hydrography.osm_waterbody (
    feature, osm_id, osm_class, osm_type, name, name_length, water, is_salt, area, geometry)
    SELECT
        type,
        osm_id,
        class,
        type,
        name,
        length(name),
        water,
        is_salt,
        area,
        ST_Multi(geometry)
    FROM public.osm_waterbody;

-- patching...
DELETE FROM hydrography.osm_waterbody WHERE osm_id IN (-1120169, -5678328,-4228055);

CREATE INDEX ON hydrography.osm_waterbody
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterbody
    (feature);
CREATE INDEX ON hydrography.osm_waterbody
    (area);


INSERT INTO hydrography.osm_waterbody_gen0 (
    feature, osm_id, osm_class, osm_type, name, name_length, water, is_salt, area, geometry)
    SELECT
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        length(name),
        water,
        is_salt,
        area,
        ST_Multi(ST_SimplifyPreserveTopology(geometry, 10.0))
    FROM hydrography.osm_waterbody
    WHERE area > 100000.0;

CREATE INDEX ON hydrography.osm_waterbody_gen0
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterbody_gen0
    (feature);
CREATE INDEX ON hydrography.osm_waterbody_gen0
    (area);



INSERT INTO hydrography.osm_waterbody_gen1 (
    feature, osm_id, osm_class, osm_type, name, name_length, water, is_salt, area, geometry)
    SELECT
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        length(name),
        water,
        is_salt,
        area,
        ST_Multi(ST_SimplifyPreserveTopology(geometry, 150.0))
    FROM hydrography.osm_waterbody_gen0
    WHERE area > 1000000.0;

CREATE INDEX ON hydrography.osm_waterbody_gen1
    USING gist
    (geometry);
CREATE INDEX ON hydrography.osm_waterbody_gen1
    (feature);
CREATE INDEX ON hydrography.osm_waterbody_gen1
    (area);


COMMIT;
