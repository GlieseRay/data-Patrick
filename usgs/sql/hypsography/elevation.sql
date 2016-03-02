BEGIN;

INSERT INTO hypsography.gnis_elevation (
    feature, gnis_id, gnis_class, name, name_length, name_abbr, name_abbr_length,
    state, county, rank, elev_in_m, elev_in_ft, geometry
    )
    SELECT
        CASE
            WHEN a.feature_class = 'Summit' THEN 'peak'
            WHEN a.feature_class = 'Valley' THEN 'valley'
            ELSE NULL
        END AS feature,
        a.feature_id,
        a.feature_class,
        a.feature_name,
        length(a.feature_name),
        elevation_name_abbr(a.feature_name),
        length(elevation_name_abbr(a.feature_name)),
        a.state_alpha,
        a.county_name,
        CASE
		WHEN b.rank IS NOT NULL THEN b.rank
		WHEN a.feature_class = 'Summit' AND b.rank IS NULL AND a.elev_in_ft::INTEGER > 13000 THEN 100
		WHEN a.feature_class = 'Summit' AND b.rank IS NULL AND a.elev_in_ft::INTEGER > 10000 THEN 110
		WHEN a.feature_class = 'Summit' AND b.rank IS NULL AND a.elev_in_ft::INTEGER > 5000 THEN 120
		WHEN a.feature_class = 'Summit' AND b.rank IS NULL AND a.elev_in_ft::INTEGER > 3000 THEN 130
		WHEN a.feature_class = 'Summit' AND b.rank IS NULL AND a.elev_in_ft::INTEGER > 1000 THEN 140
		ELSE 255
	END::SMALLINT,
	a.elev_in_m::INTEGER,
	a.elev_in_ft::INTEGER,
        a.geometry
    FROM
        gnis.domestic_names a
        LEFT JOIN
        public.elevation_rank b
        ON (a.feature_name = b.feature_name AND
            a.state_numeric = b.state_numeric AND
            a.county_numeric = b.county_numeric)
    WHERE
        a.feature_class IN ('Summit', 'Valley') AND
        a.prim_long_dec != 0 AND
        a.prim_lat_dec != 0 AND
        a.elev_in_ft != '' AND
        a.elev_in_m != ''
    ;

CREATE INDEX ON hypsography.gnis_elevation
    USING gist
    (geometry);
CREATE INDEX ON hypsography.gnis_elevation
    (feature);
CREATE INDEX ON hypsography.gnis_elevation
    (rank ASC, elev_in_ft DESC, ST_X(geometry) DESC,  gid);

COMMIT;
