BEGIN;

INSERT INTO transportation.label_osm_road (
    feature,
    osm_class,
    osm_type,
    name,
    name_length,
    name_abbr,
    name_abbr_length,
    rank,
    dir,
    is_tunnel,
    is_bridge,
    is_toll,
    geometry
    )
    SELECT
        feature,
        osm_class,
        osm_type,
        name,
        length(name),
        road_name_abbr(name),
        length(road_name_abbr(name)),
        rank,
        dir,
        is_tunnel,
        is_bridge,
        is_toll,
        geometry
    FROM transportation.osm_road
    WHERE name IS NOT NULL AND name != '' AND is_link = 0;

CREATE INDEX ON transportation.label_osm_road
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_road
    (feature);
CREATE INDEX ON transportation.label_osm_road
    (rank, is_bridge DESC, is_tunnel DESC, name_length, name, id);

INSERT INTO transportation.label_osm_road_gen0 (
    feature,
    osm_class,
    osm_type,
    name,
    name_length,
    name_abbr,
    name_abbr_length,
    rank,
    dir,
    is_tunnel,
    is_bridge,
    is_toll,
    geometry
    )
    SELECT
        b.feature,
        b.osm_class,
        b.osm_type,
        b.name,
        length(b.name),
        road_name_abbr(b.name),
        length(road_name_abbr(b.name)),
        b.rank,
        b.dir,
        b.is_tunnel,
        b.is_bridge,
        b.is_toll,
        ST_LineSubstring(
            geometry,
            25000.00 * n / length,
            CASE
                WHEN 25000.00 * (n + 1) < length THEN 25000.00 * (n + 1) / length
                ELSE 1
            END
        ) As geometry
    FROM (
	    SELECT *, ST_Length(geometry) AS length FROM (
		    SELECT
		        feature,
		        osm_class,
		        osm_type,
		        name,
		        rank,
		        dir,
		        is_tunnel,
		        is_bridge,
		        is_toll,
		        (
		            ST_DUMP(
		                ST_LineMerge(
			                ST_Collect(geometry)
		        ))).geom AS geometry
		    FROM transportation.osm_road_gen0
		    WHERE name IS NOT NULL AND name != '' AND is_link = 0
		    GROUP BY feature, osm_class, osm_type, name, rank, dir, is_tunnel, is_bridge, is_toll
	    ) a
    ) b
    JOIN generate_series(0, 100) n ON (n * 25000.00 / b.length <= 1);


CREATE INDEX ON transportation.label_osm_road_gen0
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_road_gen0
    (feature);
CREATE INDEX ON transportation.label_osm_road_gen0
    (rank, is_bridge DESC, is_tunnel DESC, name_length, name, id);


INSERT INTO transportation.label_osm_road_gen1
    SELECT * FROM transportation.label_osm_road_gen0
    WHERE
        feature IN (
                'motorway',
                'trunk',
                'primary',
                'ferry');


CREATE INDEX ON transportation.label_osm_road_gen1
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_road_gen1
    (feature);
CREATE INDEX ON transportation.label_osm_road_gen1
    (rank, is_bridge DESC, is_tunnel DESC, name_length, name, id);


CREATE OR REPLACE VIEW transportation.label_osm_road_view AS
    SELECT * FROM transportation.label_osm_road
    ORDER BY
        rank,
        is_bridge DESC,
        is_tunnel DESC,
        name_length,
        name,
        id;

CREATE OR REPLACE VIEW transportation.label_osm_road_gen0_view AS
    SELECT * FROM transportation.label_osm_road_gen0
    ORDER BY
        rank,
        is_bridge DESC,
        is_tunnel DESC,
        name_length,
        name,
        id;

CREATE OR REPLACE VIEW transportation.label_osm_road_gen1_view AS
    SELECT * FROM transportation.label_osm_road_gen1
    ORDER BY
        rank,
        is_bridge DESC,
        is_tunnel DESC,
        name_length,
        name,
        id;


COMMIT;
