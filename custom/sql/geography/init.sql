BEGIN;

CREATE SCHEMA geography;

CREATE TABLE geography.label_geography_marine AS
    SELECT * FROM label_geography_marine;
    
CREATE TABLE geography.label_geography_regions AS
    SELECT * FROM label_geography_regions;

COMMIT;
