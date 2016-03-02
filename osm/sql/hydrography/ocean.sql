BEGIN;

INSERT INTO hydrography.osm_ocean (geometry)
    SELECT geometry
    FROM public.osm_ocean;

CREATE INDEX ON hydrography.osm_ocean
    USING gist
    (geometry);

-- COUNT: 36235

COMMIT;
