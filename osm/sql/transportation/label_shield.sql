BEGIN;

WITH road_ref AS (
    SELECT
        *,
        SPLIT_PART(ref, ';', 1) AS norm_ref
    FROM
        transportation.osm_road
    WHERE
        ref IS NOT NULL AND ref != '' AND osm_class = 'highway' AND is_link = 0
)
INSERT INTO transportation.label_osm_shield (
    feature,
    osm_class,
    osm_type,
    sign_schema,
    sign_type,
    sign_num,
    sign_num_length,
    scalerank,
    roadrank,
    geometry
    )
    SELECT
        feature,
        osm_class,
        osm_type,
        sign_schema,
        sign_type,
        sign_num,
        length(sign_num),
        CASE
            WHEN sign_type = 'I' THEN 8
            WHEN sign_type IN ('Spur', 'Loop', 'Toll', 'Business') THEN 10
            WHEN sign_type = 'US' THEN 12
            WHEN sign_type = '' AND feature ='motorway' THEN 12
            ELSE 13
        END AS scalerank,
        rank AS roadrank,
        geometry
    FROM (


        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            SPLIT_PART(norm_ref, ' ', 1) AS sign_type,
            SPLIT_PART(norm_ref, ' ', 2) AS sign_num,
            rank,
            geometry
        FROM road_ref
        WHERE
            norm_ref ~* '^([A-Z]{1,4}|Spur|Loop|Hwy|Park|Toll|Route|Business) [A-Z0-9]+$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            SPLIT_PART(norm_ref, ' ', 2) AS sign_type,
            SPLIT_PART(norm_ref, ' ', 1) AS sign_num,
            rank,
            geometry
        FROM road_ref
        WHERE
            norm_ref ~* '^[A-Z0-9]+ ([A-Z]{1,4}|Spur|Loop|Hwy|Park|Toll|Route|Business)$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            '' AS sign_type,
            norm_ref AS sign_num,
            rank,
            geometry
        FROM road_ref
        WHERE
            norm_ref ~* '^\d+[A-Z]*$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            '' AS sign_type,
            substring(norm_ref, '^\((\d+[A-Z]*)\)$') AS sign_num,
            rank,
            geometry
        FROM road_ref
        WHERE
            norm_ref ~* '^\(\d+[A-Z]*\)$'

    ) foo;

CREATE INDEX ON transportation.label_osm_shield
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_shield
    (feature);
CREATE INDEX ON transportation.label_osm_shield
    (scalerank ASC,
     roadrank ASC,
     sign_num_length ASC,
     sign_num,
     id);


WITH road_ref_gen0 AS (
    SELECT
        b.feature,
        b.osm_class,
        b.osm_type,
        b.ref,
        length(b.ref),
        b.rank,
        ST_LineSubstring(
            geometry,
            25000.00 * n / length,
            CASE
                WHEN 25000.00 * (n + 1) < length THEN 25000.00 * (n + 1) / length
                ELSE 1
            END
        ) As geometry,
        SPLIT_PART(ref, ';', 1) AS norm_ref
    FROM (
	    SELECT *, ST_Length(geometry) AS length FROM (
		    SELECT
		        feature,
		        osm_class,
		        osm_type,
		        ref,
		        rank,
		        is_tunnel,
		        is_bridge,
		        is_toll,
		        (
		            ST_DUMP(
		                ST_LineMerge(
			                ST_Collect(geometry)
		        ))).geom AS geometry
		    FROM transportation.osm_road_gen0
		    WHERE ref IS NOT NULL AND ref != '' AND is_link = 0 AND feature IN ('motorway', 'trunk', 'primary')
		    GROUP BY feature, osm_class, osm_type, ref, rank, is_tunnel, is_bridge, is_toll
	    ) a
    ) b
    JOIN generate_series(0,100) n ON (n * 25000.00 / b.length <= 1)
)
INSERT INTO transportation.label_osm_shield_gen0 (
    feature,
    osm_class,
    osm_type,
    sign_schema,
    sign_type,
    sign_num,
    sign_num_length,
    scalerank,
    roadrank,
    geometry
    )
    SELECT
        feature,
        osm_class,
        osm_type,
        sign_schema,
        sign_type,
        sign_num,
        length(sign_num),
        CASE
            WHEN sign_type = 'I' THEN 8
            WHEN sign_type IN ('Spur', 'Loop', 'Toll', 'Business') THEN 10
            WHEN sign_type = 'US' THEN 12
            WHEN sign_type = '' AND feature ='motorway' THEN 12
            ELSE 13
        END AS scalerank,
        rank AS roadrank,
        geometry
    FROM (

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            SPLIT_PART(norm_ref, ' ', 1) AS sign_type,
            SPLIT_PART(norm_ref, ' ', 2) AS sign_num,
            rank,
            geometry
        FROM road_ref_gen0
        WHERE
            norm_ref ~* '^([A-Z]{1,4}|Spur|Loop|Hwy|Park|Toll|Route|Business) [A-Z0-9]+$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            SPLIT_PART(norm_ref, ' ', 2) AS sign_type,
            SPLIT_PART(norm_ref, ' ', 1) AS sign_num,
            rank,
            geometry
        FROM road_ref_gen0
        WHERE
            norm_ref ~* '^[A-Z0-9]+ ([A-Z]{1,4}|Spur|Loop|Hwy|Park|Toll|Route|Business)$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            '' AS sign_type,
            norm_ref AS sign_num,
            rank,
            geometry
        FROM road_ref_gen0
        WHERE
            norm_ref ~* '^\d+[A-Z]*$'

        UNION ALL

        SELECT
            feature,
            osm_class,
            osm_type,
            '' AS sign_schema,
            '' AS sign_type,
            substring(norm_ref, '^\((\d+[A-Z]*)\)$') AS sign_num,
            rank,
            geometry
        FROM road_ref_gen0
        WHERE
            norm_ref ~* '^\(\d+[A-Z]*\)$'
    ) foo;


CREATE INDEX ON transportation.label_osm_shield_gen0
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_shield_gen0
    (feature);
CREATE INDEX ON transportation.label_osm_shield_gen0
    (scalerank ASC,
     roadrank ASC,
     sign_num_length ASC,
     sign_num,
     id);


INSERT INTO transportation.label_osm_shield_gen1
    SELECT * FROM transportation.label_osm_shield_gen0
    WHERE
        feature IN (
                'motorway',
                'trunk',
                'ferry');


CREATE INDEX ON transportation.label_osm_shield_gen1
    USING gist
    (geometry);
CREATE INDEX ON transportation.label_osm_shield_gen1
    (feature);
CREATE INDEX ON transportation.label_osm_shield_gen1
    (scalerank ASC,
     roadrank ASC,
     sign_num_length ASC,
     sign_num,
     id);


CREATE OR REPLACE VIEW transportation.label_osm_shield_view AS
    SELECT *
    FROM
        transportation.label_osm_shield
    ORDER BY
        scalerank ASC,
        roadrank ASC,
        sign_num_length ASC,
        sign_num,
        id;

CREATE OR REPLACE VIEW transportation.label_osm_shield_gen0_view AS
    SELECT *
    FROM
        transportation.label_osm_shield_gen0
    ORDER BY
        scalerank ASC,
        roadrank ASC,
        sign_num_length ASC,
        sign_num,
        id;

CREATE OR REPLACE VIEW transportation.label_osm_shield_gen1_view AS
    SELECT * FROM transportation.label_osm_shield_gen1
    ORDER BY
        scalerank ASC,
        roadrank ASC,
        sign_num_length ASC,
        sign_num,
        id;


COMMIT;
