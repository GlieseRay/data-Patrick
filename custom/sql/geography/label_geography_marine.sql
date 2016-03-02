BEGIN;

CREATE INDEX ON geography.label_geography_marine(scalerank);

CREATE VIEW geography.label_geography_marine_view AS
	SELECT * FROM geography.label_geography_marine
	ORDER BY scalerank ASC, id;


COMMIT;
