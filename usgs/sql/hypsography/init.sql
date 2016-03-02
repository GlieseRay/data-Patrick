BEGIN;

CREATE SCHEMA hypsography;

CREATE FUNCTION elevation_name_abbr(name TEXT) RETURNS text AS $$
DECLARE
	abbr TEXT;
BEGIN
    CASE
	    WHEN name ~* '^Mount Saint '
		    THEN abbr := regexp_replace("name", '^(Mount Saint) ', 'Mt. St. ', 'i');
	    WHEN name ~* '^Mount '
		    THEN abbr := regexp_replace("name", '^(Mount) ', 'Mt. ', 'i');
	    WHEN name ~* ' Peak$'
		    THEN abbr := regexp_replace("name", ' (Peak)$', ' Pk.', 'i');
        ELSE abbr := name;
    END CASE;
	RETURN abbr;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE TABLE hypsography.gnis_elevation (
    gid                     SERIAL NOT NULL,
    feature                 VARCHAR,
    gnis_id                 VARCHAR,
    gnis_class              VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    name_abbr               VARCHAR,
    name_abbr_length        VARCHAR,
    state                   VARCHAR,
    county                  VARCHAR,
    rank                    SMALLINT,
    elev_in_m               INTEGER,
    elev_in_ft              INTEGER,
    geometry                GEOMETRY(Point, 3857),

    PRIMARY KEY (gid)
);

COMMIT;
