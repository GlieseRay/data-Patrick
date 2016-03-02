BEGIN;


-- boundary line

INSERT INTO administration.sa1m_admin_0_boundary_line (geometry)
SELECT
	ST_Transform(geometry, 3857) AS geometry
FROM usa1m.countyl010g
WHERE linetype = 'International';

CREATE INDEX ON administration.sa1m_admin_0_boundary_line 
    USING gist(geometry);
    


INSERT INTO administration.sa1m_admin_1_boundary_line (geometry)
SELECT
	ST_Transform(geometry, 3857) AS geometry
FROM usa1m.countyl010g
WHERE linetype = 'State';

CREATE INDEX ON administration.sa1m_admin_1_boundary_line 
    USING gist(geometry);


-- boundary line label
INSERT INTO administration.sa1m_admin_0_boundary_line_label (name, name_length, geometry)
SELECT name, LENGTH(name) AS name_length, geometry FROM
(
    SELECT
    	CASE
    		WHEN gid IN (3105, 3106, 3107, 3108) THEN 'United States'
    		WHEN gid = 3109 THEN 'Canada'
    		ELSE NULL
    	END AS name,
    	ST_Transform(geometry, 3857) AS geometry
    FROM usa1m.countyl010g
    WHERE linetype = 'International' AND gid IN (3105, 3106, 3107, 3108, 3109)
    UNION ALL
    SELECT
    	CASE
    		WHEN gid IN (3105, 3106, 3107) THEN 'Canada'
    		WHEN gid = 3109 THEN 'United States'
    		WHEN gid = 3108 THEN 'Mexico'
    		ELSE NULL
    	END AS name,
    	ST_Transform(ST_Reverse(geometry), 3857) AS geometry
    FROM usa1m.countyl010g
    WHERE linetype = 'International' AND gid IN (3105, 3106, 3107, 3108, 3109)
) foo;

CREATE INDEX ON administration.sa1m_admin_0_boundary_line_label 
    USING gist(geometry);


INSERT INTO administration.sa1m_admin_1_boundary_line_label (name, name_length, geometry)
SELECT 
	name,
    LENGTH(name) AS name_length,
	ST_Transform(geometry, 3857) AS geometry
FROM (
	SELECT b.name AS name, ST_Multi(ST_LineMerge(ST_CollectionExtract(ST_Intersection(a.geometry, b.geometry), 2))) AS geometry FROM
	usa1m.statesp010g a
	JOIN
	usa1m.statesp010g b
	ON (a.gid != b.gid AND a.name != b.name AND ST_Intersects(a.geometry, b.geometry))
) foo
WHERE NOT ST_IsEmpty(geometry);

CREATE INDEX ON administration.sa1m_admin_1_boundary_line_label 
    USING gist(geometry);


COMMIT;