BEGIN;


INSERT INTO hydrography.label_osm_waterbody_point (
    id,
    geometry
    )
    SELECT
        id,
        ST_PointOnSurface(geometry)
    FROM hydrography.osm_waterbody
    WHERE
        name IS NOT NULL AND name != '' AND ST_IsValid(geometry);

CREATE INDEX ON hydrography.label_osm_waterbody_point
    USING gist
    (geometry);


INSERT INTO hydrography.label_osm_waterbody_line (
    id,
    geometry
    )
    SELECT
	    id,
	    ST_CurveToLine(
			ST_SetSRID(
			ST_GeomFromText(replace(
				ST_AsText(
					ST_MakeLine(
					    ARRAY [ST_PointN(diameter, 1),
					    centroid,
					    ST_PointN(diameter, 2)])),
				'LINESTRING',
				'CIRCULARSTRING'
				)),
				3857)
	    )::GEOMETRY(LINESTRING, 3857) AS geometry
    FROM (
        SELECT
            id,
            ST_LongestLine(ST_ConvexHull(geometry), ST_ConvexHull(geometry)) as diameter,
            ST_Centroid(geometry) as centroid
        FROM hydrography.osm_waterbody
        WHERE
            name IS NOT NULL AND
            name != '' AND
            name NOT LIKE '% River%' AND
            name NOT LIKE '% Creek%'
    ) bar;

CREATE INDEX ON hydrography.label_osm_waterbody_line
    USING gist
    (geometry);


CREATE OR REPLACE VIEW hydrography.label_osm_waterbody_line_view AS
    SELECT
        a.id,
        b.feature,
        b.osm_id,
        b.osm_class,
        b.osm_type,
        b.name,
        b.name_length,
        b.water,
        b.is_salt,
        b.area,
        a.geometry
    FROM
        hydrography.label_osm_waterbody_line a
        JOIN
        hydrography.osm_waterbody b
        ON (a.id = b.id AND b.feature IN ('water', 'reservior') AND b.water != 'river')
    ORDER BY
        b.area DESC;

CREATE OR REPLACE VIEW hydrography.label_osm_waterbody_point_view AS
    SELECT
        a.id,
        b.feature,
        b.osm_id,
        b.osm_class,
        b.osm_type,
        b.name,
        b.name_length,
        b.water,
        b.is_salt,
        b.area,
        a.geometry
    FROM
        hydrography.label_osm_waterbody_point a
        JOIN
        hydrography.osm_waterbody b
        ON (a.id = b.id AND b.feature IN ('water', 'reservior') AND b.water != 'river')
    ORDER BY
        b.area DESC;


COMMIT;
