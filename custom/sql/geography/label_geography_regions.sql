BEGIN;

CREATE INDEX ON geography.label_geography_regions(scalerank);

CREATE VIEW geography.label_geography_regions_view AS
	SELECT * FROM geography.label_geography_regions
	ORDER BY scalerank ASC, id;

COMMIT;
