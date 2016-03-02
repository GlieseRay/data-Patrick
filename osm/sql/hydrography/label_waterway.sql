BEGIN;

INSERT INTO hydrography.label_osm_waterway (
name,
name_length,
rank,
geometry
)
SELECT
    name,
    length(name) AS name_length,
    CASE
        WHEN feature = 'river' THEN 10
        WHEN feature = 'canal' THEN 20
        WHEN feature = 'stream' THEN 30
        ELSE 255
    END AS rank,
    ST_Multi(geometry)
FROM (
		SELECT
		a.feature,
		CASE
		    WHEN a.name ~* '.*?;.*'
		        THEN regexp_replace(a.name, '(.*);.*', '\1', 'i')
			ELSE a.name
		END AS name,
		a.geometry AS geometry
	FROM hydrography.osm_waterway a
	WHERE
	    name IS NOT NULL AND
	    name != '' AND
	    lower(name) != 'no name' AND
	    NOT EXISTS
	    (
		SELECT id
		FROM hydrography.osm_waterbody
	        WHERE feature IN ('water', 'reservior') AND water != 'river' AND
	        ST_Intersects(a.geometry, geometry)
	    )
) foo;


CREATE INDEX ON hydrography.label_osm_waterway
    USING gist
    (geometry);

CREATE INDEX ON hydrography.label_osm_waterway
    (rank ASC, ST_Length(geometry) DESC, id);


CREATE VIEW hydrography.label_osm_waterway_view AS
    SELECT *
    FROM hydrography.label_osm_waterway
    ORDER BY
        rank ASC,
        ST_Length(geometry) DESC,
        id;


INSERT INTO hydrography.label_osm_waterway_gen0 (
name,
name_length,
rank,
geometry
)
SELECT
    name,
    length(name) AS name_length,
    CASE
        WHEN feature = 'river' THEN 10
        WHEN feature = 'canal' THEN 20
        WHEN feature = 'stream' THEN 30
        ELSE 255
    END AS rank,
    ST_Multi(geometry)
FROM (
		SELECT
		a.feature,
		CASE
		    WHEN a.name ~* '.*?;.*'
		        THEN regexp_replace(a.name, '(.*);.*', '\1', 'i')
			ELSE a.name
		END AS name,
		a.geometry AS geometry
	FROM hydrography.osm_waterway_gen0 a
	WHERE
	    name IS NOT NULL AND
	    name != '' AND
	    lower(name) != 'no name' AND
	    NOT EXISTS
	    (
		SELECT id
		FROM hydrography.osm_waterbody
	        WHERE feature IN ('water', 'reservior') AND water != 'river' AND
	        ST_Intersects(a.geometry, geometry)
	    )
) foo;


CREATE INDEX ON hydrography.label_osm_waterway_gen0
    USING gist
    (geometry);

CREATE INDEX ON hydrography.label_osm_waterway_gen0
    (rank ASC, ST_Length(geometry) DESC, id);


CREATE VIEW hydrography.label_osm_waterway_gen0_view AS
    SELECT *
    FROM hydrography.label_osm_waterway_gen0
    ORDER BY
        rank ASC,
        ST_Length(geometry) DESC,
        id;


COMMIT;
